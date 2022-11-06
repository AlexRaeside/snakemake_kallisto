---
title: "Kallisto Snakemake"
output: html_document
date: "2022-10-20"
---



This project needs to be done more then it needs to be written about 
One usable rule at a time and its going to be just single seq and simple 
figures and will add everything else later

Rule 1: Create a metadata table
The user has three options to state what fastq files are used in the pipeline
    1. Add a metadata.csv into the output/metadata/ folder before the snakemake
    is run 
    2. In the config state a list of fastq files paths that will be used to create a 
    metadata table with the paths to fastq files and sample names which will 
    be the fastq files with the .fastq.gz removed 
    3. State in the config a directory of fastq files, all the fastq files in 
    this directory will be used to create the metadata files.
    
In the future the metadata will have other things like a category to state if 
the sample is an experiment or a control. These things will be used to make 
nice PCAs and other stats. 


### Making a metadata 


```
conda activate snakemake_env

snakemake -c1 -s src/Snakefile test/20221020_Celegans/output/metadata/metadata.csv

```

### making the index 

```

snakemake -c1 -s src/Snakefile test/20221020_Celegans/output/index/Celegans.cdna.all.fa.idx


```


### Finding fastq average read length using fastqc

Create a fastqc report for the fastq file in order to get the average 
read length for kallisto 

The basic command for fastqc is something like

```

mkdir test/20221020_Celegans/output/fastqc 
fastqc -o test/20221020_Celegans/output/fastqc --extract data/fastq/SRR21711053.fastq.gz

```

This creates a file in the folder fastqc called SRR21711053_fastqc which 
contains a file fastqc_data.txt. The 9th line of the file is contains 
the average sequence length. Average read length is a required param when 
running kallisto on single read fastq.

```
##FastQC	0.11.9
>>Basic Statistics	pass
#Measure	Value
Filename	SRR21711053.fastq.gz
File type	Conventional base calls
Encoding	Sanger / Illumina 1.9
Total Sequences	2324326
Sequences flagged as poor quality	0
Sequence length	120
%GC	40
```

The function read_length_average takes the file path to fastqc_data.txt and 
returns the length int for kallisto to use. 

This rule in snakemake is going to use wildcards and is it need to know
to run with different fastq files producing different fastqc reports with 
the same name. So with the wildcard system will look a little like.

It would be easier if i used the fastq path 

```
rule fastqc_report:
    input: 
        fq_file = multiext(
            "{wildcards.fq_dir}/{wildcards.fq}",
            ".fastq.gz", ".fastq", ".FATSQ.gz", "FASTQ.GZ", ""),
        out_dir = config{"output_dir"}
    output:
        qc_report_file = expand(
            "{out}/fastqc/{wildcards.fq}_fastqc/fastqc_data.txt", 
            out = config["output_dir"])
```

So if the next stage in the snakemake requires the fastqc_data.txt for
SRR21711053 

No the way to do this is with a metadata.csv file. The wildcard is the
fastq sample name. And i can use that fastq sample name with the metadata
so lets imagine this with some python code 


```

rule run_fastqc:
    
    fastqc_dir = config["output_dir"] + "/fastqc"
    metadata_path = config["output_dir"] + "/metadata/metadata.csv" 
    
    input: 
        fq = fastq_path(wildcard.sample, config["output_dir"] + "/metadata/metadata.csv"),
        metadata = metadata_path
        out_path = fastqc_dir
    output:
        fastqc_report = fastqc_dir + "/{wildcard.sample}_fastqc/fastqc_data.txt"
    
    run:
        
        if not os.path.exists(fastqc_dir):
            os.mkdir(fastqc_dir)
    
    shell:
        
        "fastqc -o {fastqc_dir} --extract {input.fq}""







```




