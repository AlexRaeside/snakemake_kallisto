# a python script demonstrating the different ways to write the 
# metadata table if the user does not provide it 
# will take info from the config 
# just messing around and will move things to module file later 
# right now it just does single read 


# whta is the bare 


# a python module 

import pandas as pd
import yaml
import os
import numpy as np

def output_sample_name(fastq_name):
    
    fastq_exp = os.path.expanduser(fastq_name)
    fastq_file = os.path.basename(fastq_exp)
    out_name = fastq_file.replace(
        ".fastq.gz", "").replace(".fastq", "").replace("FASTQ.gz", "")
    
    return(out_name)


def write_sample_table(fastq_r1_list, out_dir):
    
    sample_names = [output_sample_name(i) for i in fastq_r1_list]
    
    sample_tbl = pd.DataFrame(
        {
            "sample_name" : sample_names,
            "fastqR1_file" : fastq_r1_list
        }
    )
    
    out_file = os.path.join(out_dir, "sample_table", "sample_table.csv")
    
    # check if metadata dir exists 
    
    if not os.path.exists(os.path.join(out_dir, "sample_table")):
        os.mkdir(os.path.join(out_dir, "sample_table"))
    
    sample_tbl.to_csv(out_file, index = False)
    
    
def get_fastq_in_dir(fastq_dir):
    
    files_list = os.listdir(fastq_dir)
    
    fastq_patterns = [".FASTQ", ".fastq", ".fastq.gz", ".FASTQ.gz"]
    
    fastq_files = [k for k in files_list if any(p in k for p in fastq_patterns)]
    
    fastq_paths = [os.path.join(fastq_dir, fq) for fq in fastq_files]
    
    return(fastq_paths)


def get_samples(sample_table_path):
    
    sample_tbl = pd.read_csv(sample_table_path)
    sample_matrix = sample_tbl[sample_tbl.columns[0]].to_numpy()
    samples = sample_matrix.tolist()
    
    return(samples)


def move_metadata(metadata_path, col_list):
    
    # load metadata tbl csv, take the cols wanted and 
    # return the pandas df
    
    meta = pd.read_csv(metadata_path)
    
    if len(col_list) == 0:
        meta_sub = meta
    
    if len(col_list) != 0:
        meta_sub = meta[meta.columns.intersection(col_list)]
        
    return meta_sub




if __name__ == "__main__" :
    
    
    # just for testing the fucntions 
    
    with open("src/TestConfigA.yaml", 'r') as stream:
        yaml_data = yaml.safe_load(stream)

    fastq_r1 = yaml_data["fastq_R1"]
    fastq_dir = yaml_data["fastq_dir"]
    metadata = yaml_data["metadata"]
    out_dir = yaml_data['output_dir']
    
    x = get_fastq_in_dir(yaml_data["fastq_dir"])
    
    write_sample_metadata(x, out_dir)
    sample_name = "SRR21711073"
    metadata_path = "test/20221020_Celegans/output/metadata/metadata.csv"
