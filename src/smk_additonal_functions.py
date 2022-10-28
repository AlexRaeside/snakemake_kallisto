# A module of python functions that are called in the snakemake 

import os
import pandas as pd

# A function that takes in fasta_R1 list of sample names and outputs 
# needs to be vectorized 


def output_sample_name(fastq_name):
    
    fastq_exp = os.path.expanduser(fastq_name)
    fastq_file = os.path.basename(fastq_exp)
    out_name = fastq_file.replace(
        ".fastq.gz", "").replace(".fastq", "").replace("FASTQ.gz", "")
    
    return(out_name)
    


## get the 





# A function that takes the features from a count files 
# and creates a blank count.csv

def create_blank_count_tables(path_to_counts, output_path):
    
    path_expand = os.path.expanduser(path_to_counts)
    counts_tbl 
    
    # take feature names
    
    

