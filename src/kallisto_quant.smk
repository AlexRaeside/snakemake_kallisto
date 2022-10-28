# snakemake rule for kallisto  quant 
# this is for the single reads 


# the fastq samples are used as output directory names 

import smk_additonal_functions as saf

sample_output_files = []
for fq in fastq_names:
    sample_output_files.append(saf.output_sample_name(fq))


# opting to not use a wrapper so I can change the command 
# easier 

# if there is no R2 reads then add the param 
# --single to the kallisto command 


rule kallisto_quant:
    input:
        fastq_R1 = expand(config["fastq_R1"]),
        fastq_R2 = expand(config["fastq_R2"]),
        index= expand(
            "{out}/{idx}.idx",
            out = config["output_dir"],
            idx = config["index_name"]),
    output:
        out_dir = directory(expand(
            "quant_results_{sample}",
            sample = sample_output_files),
    params:
        extra="",
        
    threads: config["threads"]
    
    # the kallisto quant commadns are behind if statements
    # there are three different kallisto quants being run 
    # single end, paired-read and single cell 
    
    if len(config["fastq_R2"]) == 0:
        
        shell(
        "kallisto quant "  # Tool
        "{extra} "  # Optional parameters
        "--threads={threads} "  # Number of threads
        "--index={input.index} "  # Input file
        "--output-dir={output.out_dir} "  # Output directory
        "{input.fastq_R1} "  # Input FASTQ files
        )
    
    if len(config["fastq_R2"]) != 0:
        
        shell(
        "kallisto quant "  # Tool
        "{extra} "  # Optional parameters
        "--threads={threads} "  # Number of threads
        "--index={input.index} "  # Input file
        "--output-dir={output.out_dir} "  # Output directory
        "{input.fastq_R1} {input.fastq_R2}"  # Input FASTQ files
        )
