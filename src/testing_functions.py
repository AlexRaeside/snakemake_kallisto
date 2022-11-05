# a script to test importing modules 


from snakemake_modules.metadata import output_sample_name 
import yaml
import os 

# read in config and print out the sample names 


dir_path = os.path.dirname(os.path.abspath(__file__))



with open(os.path.join(dir_path, "TestConfigA.yaml") , 'r') as stream:
    yaml_data = yaml.safe_load(stream)

fastq_r1_list = yaml_data["fastq_R1"]

print([output_sample_name(i) for i in fastq_r1_list])
