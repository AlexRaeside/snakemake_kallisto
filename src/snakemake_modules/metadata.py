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


def output_sample_name(fastq_name):
    
    fastq_exp = os.path.expanduser(fastq_name)
    fastq_file = os.path.basename(fastq_exp)
    out_name = fastq_file.replace(
        ".fastq.gz", "").replace(".fastq", "").replace("FASTQ.gz", "")
    
    return(out_name)


def write_sample_metadata(fastq_r1_list, out_dir):
    
    sample_names = [output_sample_name(i) for i in fastq_r1_list]
    
    sample_tbl = pd.DataFrame(
        {
            "sample_name" : sample_names,
            "fastqR1_file" : fastq_r1_list
        }
    )
    
    out_file = os.path.join(out_dir, "metadata", "metadata.csv")
    
    # check if metadata dir exists 
    
    if not os.path.exists(os.path.join(out_dir, "metadata")):
        os.mkdir(os.path.join(out_dir, "metadata"))
    
    sample_tbl.to_csv(out_file, index = False)
    
    
def get_fastq_in_dir(fastq_dir):
    
    files_list = os.listdir(fastq_dir)
    
    fastq_patterns = [".FASTQ", ".fastq", ".fastq.gz", ".FASTQ.gz"]
    
    fastq_files = [k for k in files_list if any(p in k for p in fastq_patterns)]
    
    fastq_paths = [os.path.join(fastq_dir, fq) for fq in fastq_files]
    
    return(fastq_paths)






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
