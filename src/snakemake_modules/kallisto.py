# a fucntion to work out the index name using the fasta file path

import os 
import pandas as pd

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
        out_path + "/counts_raw.csv", index=False, header=None)
    
    # a blank file to place summary data 
    summary_list = [
        "sample", "n_targets", "n_processed", "n_pseudoaligned",
        "n_unique", "p_pseudoaligned", "p_unique"]
    summary_tbl = pd.DataFrame([summary_list])
    summary_tbl.to_csv(
        out_path + "/counts_summary.csv", index=False, header=None)


