# Snakemake file to generate kallisto counts from paired or 
# single reads 


##---------- Setting the envrioment --------------------------------------------
# what additonal python modules do i need to import?
# my previous snakemakes have involved running lots of little 
# Python and Rscripts invoked by the shell() command but this time around #
# I would like as many small intermediate steps in my pipeline, moving 
# count data from one table to another to be handled by python commands 
# run from the snakemake. I've create a python module file called 
# smk_additional_functions.py which has functions for all the intermediate 
# steps in the pipeline. I will also need modules like os to handle paths.


import os


## ---- Rule: Generating Kallisto Index from FASTA ---------------------------




rule kallisto_index:
    
    # config fasta contains the path to a fasta or fa file 
    # remove path and file ext and replace with indx 
    
    fasta_file = os.path.basename(config['fasta'])
    index_file = os.path.splitext(fasta_file)[0] + ".idx"
    
    
    input:
        fasta= config["fasta"]
    output:
        index = expand(
            "{out}/{idx}", 
            idx = index_file, 
            out = config["output_dir"])
    
    shell(
    "kallisto index "  # Tool
    "--index={output.index} "  # Output file
    "{input.fasta} "  # Input FASTA files
    )


## -----Rule: Generating FastQC report from FASTQ -----------------------------


## ---- Rule: Kallisto pseduoalignmentusing FASTQ, index and FastQC report -----


## ---- Rule: Create blank counts and count summary files ----------------------



##----- Rule: Aggregate kallisto counts ----------------------------------------



## ---- Rule: Aggreagte kallisot summary stats ---------------------------------







