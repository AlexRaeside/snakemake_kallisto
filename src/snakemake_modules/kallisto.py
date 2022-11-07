# a fucntion to work out the index name using the fasta file path

import os 
import pandas as pd
import json as json
import csv

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

