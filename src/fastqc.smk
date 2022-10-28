# need to run fastqc in order to find the mean length and sd of the reads 
# the basic command is this 
# fastqc \
# -o test/20221020_Celegans/output/qc_SRR21711053 \
# data/fastq/SRR21711053.fastq.gz
#
# i need to make the directory before I run this 




import smk_additonal_functions as saf

sample_output_files = []
for fq in fastq_names:
    sample_output_files.append(saf.output_sample_name(fq))

# which files do I need to get 


rule fastqc:
    input: 
        fastq_R1 = expand(config["fastq_R1"]),
        fastq_R2 = expand(config["fastq_R2"]),
    
