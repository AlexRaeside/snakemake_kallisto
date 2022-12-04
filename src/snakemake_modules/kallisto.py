# a function to work out the index name using the fasta file path

import os
import pandas as pd
import json as json
import csv
from multiprocessing import Pool

def get_indx_name(fasta_path):

    fasta = os.path.basename(fasta_path)
    base = os.path.splitext(fasta)[0]
    index = base + ".idx"

    return(index)


def create_blank_tbls(counts_file, out_path):

    # a blank file with sample and gene names
    # to aggregate the counts

    print(counts_file)

    data_import = pd.read_table(counts_file, usecols = [0])
    genes = data_import["target_id"].to_list()
    genes.insert(0, "sample")
    genes_sample_tbl = pd.DataFrame([genes])
    genes_sample_tbl.to_csv(
        out_path + "/tmp_counts_raw.csv", index=False, header=None)

    # a blank file to place summary data
    summary_list = [
        "sample", "n_targets", "n_processed", "n_pseudoaligned",
        "n_unique", "p_pseudoaligned", "p_unique"]
    summary_tbl = pd.DataFrame([summary_list])
    summary_tbl.to_csv(
        out_path + "/counts_summary.csv", index=False, header = False)


def aggregate_counts(sample, sample_counts_path, total_counts_path):

    counts =  pd.read_csv(sample_counts_path, sep="\t")["est_counts"].tolist()

    # add sample name

    counts.insert(0, sample)

    with open(total_counts_path, 'a') as f_object:

        writer_object = csv.writer(f_object)

        writer_object.writerow(counts)

        f_object.close()


def aggregate_summary(sample, sample_summary_path, total_summary_path):

    with open(sample_summary_path, 'r') as f:
        summary_data = json.load(f)

    # create a dic with summary data in same order

    summary_list = [
        sample, summary_data["n_targets"], summary_data["n_processed"],
        summary_data["n_pseudoaligned"], summary_data["n_unique"],
        summary_data["p_pseudoaligned"], summary_data["p_unique"]
    ]

    with open(total_summary_path, 'a') as f_object:

        writer_object = csv.writer(f_object)

        writer_object.writerow(summary_list)

        f_object.close()




def find_target_n(table_dir):

    # read the first two rows of summary stats

    summary_tbl = pd.read_csv(
        f"{table_dir}/counts_summary.csv", nrows=1)
    return summary_tbl["n_targets"][0]




def get_col_cords(target_n, max_col = 1000):

    cord_list = []

    end_col = 0
    start_col = 1

    while end_col != target_n:


        end_col = start_col + max_col - 1


        if end_col > target_n:
            end_col = target_n

        cord_list.append([start_col, end_col])

        start_col = end_col + 1

        if start_col > target_n:
            start_col = target_n


    return cord_list


def count_median_filter(counts_table, filter_by):

    median_df = pd.DataFrame(
        {"median" : counts_table.median(1)}, counts_table.index)

    keep_target =  median_df.index[median_df['median'] > filter_by].to_list()


    if filter_by == 0:
        return counts_table

    return counts_table.filter(keep_target, axis = "index")



def tmp_transpose_filter(table_dir, col_loci):

    start_col = col_loci[0]
    end_col = col_loci[1]

    col_range = list(range(start_col, end_col + 1))

    counts_table = pd.read_csv(
        f"{table_dir}/tmp_counts_raw.csv", usecols = col_range).T


    for n in (0, 25, 50, 100, 200):

        tmp_file = f"{table_dir}/tmp_{n}/zz{start_col}_{end_col}.csv"


        count_median_filter(counts_table, n).to_csv(
            tmp_file,
            header= False,
            index = True)

def create_blanks(samples, tables_dir):
    """

    before the tmp_raw_counts.csv file is transposed and filtered there
    needs to be blank directories where the tmp filtered counts can be
    written into and blank tables with sample names as headers where
    the tmp files can be aggregated into


    """

    samples.insert(0, "target")

    print(samples)

    blank_table = pd.DataFrame(columns = samples)

    print("here")
    print(blank_table)

    for n in (0, 25, 50, 100, 200):



        if not os.path.exists(f"{tables_dir}/tmp_{n}"):
            os.mkdir(f"{tables_dir}/tmp_{n}")

        if n == 0:

            blank_table.to_csv(
                f"{tables_dir}/tmp_{n}/aa_header.csv", index = False)

        if n != 0:

            blank_table.to_csv(
                f"{tables_dir}/tmp_{n}/aa_header.csv", index = False)


def transpose_and_filter(samples, tables_dir, cores, max_rows = 2000):


    targets_n = find_target_n(tables_dir)
    cords_list = get_col_cords(targets_n, max_rows)
    create_blanks(samples, tables_dir)
    args = [(tables_dir, i) for i in cords_list]

    with Pool(cores) as p:
            p.starmap(tmp_transpose_filter, args)
