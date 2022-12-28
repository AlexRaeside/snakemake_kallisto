---
title: "Kallisto Snakemake"
output: html_document
date: "2022-10-20"
---


# Creating a Kallisto Snakemake pipeline for single-read RNA-Seq

## Overview

A Bioinformatics project to show that I can create basic NGS pipeline using some
common bioinformatics tools like bioconda, snakemake, python and R.

The project snakemake pipeline which takes a
transcriptiome fasta file and set of singe-read RNA-Seq fastq files
and produces a counts table, or 'estimated counts' as this has to be in kallisto
in order to run on my laptop. Once counts have fastq files have been produced,
counts are aggregated into a single counts file and filtered before being
used to create a PCA figures. After the tables and figures are produced the
pipeline places the important files into a separate results folder which
can be zipped up and sent elsewhere. Maybe to be used in a streamlit project
at some point.

There is plenty that could be improved here like getting the snakemake to 
work on both single and paired reads and getting the PCA plotly plots to show 
samples colored by different variables but for now think of the 
project just as evidence that I am able to create basic automated NGS pipelines 
using python, R and shell. 

## Some intreasting things about the project

### Edit config.yaml not the snakemake

To run the pipeline on different datasets, the user edits the config file and not
the snakemake. Plus there are three different ways to specfify what samples 
you want processed. You can place a path to each sample fastq file as a list 
in the config, give a directory which contains the fastq files or create your
own sample table linking sample names to files. The idea is to keep the pipeline
convient for users ether runnng 20 or 200 fastq samples. 

There does appear to be some difficulty in getting snakemake to read the config 
file correctly though. When executing the snakemake command if the desired 
output file is argument is palced after the conf file param and config file 
then snakemake will assume the output file is another config file and try to 
open it, crashing the program. 

### Scales vertically, maybe horizontenially later


### Reprodocible, more or less 

Software reproducibility 
[here](https://www.software.ac.uk/blog/2017-02-20-software-reproducibility-possible-and-practical) 
means the ability for someone to replicate a
computational experiment that was done by someone else, using the same 
software and data, and then to be able to change part of it (the software 
and/or the data) to better understand the experiment and its bounds.

I believe the project achieves this. As long as the user has snakemake, conda 
and mamba installed in PATH which is not particularly hard then the other 
most complex software requirements like fastqc, kallisto and the R packages 
are downloaded as conda virtual environments. The config files for the conda
environments can be found in the src/ folder. Only one R package used, aRtsy, 
is currently not part of the conda R repo so has to be installed from CRAN the
first time the rscript. 

### Creates HTML wedgits along with .pngs

### The full counts table is never loaded into memory

### Kallisto does not align reads it pseudoaligns 


### Makes some art using the aRtsy package

## Running the Snakemake 


Snakemake itself is easiest to download from the conda repository bioconda.

Also download mamba to which will help download the programs in the conda 
environments faster.


In the data folder there are metadata files and configs for two test runs, 
what's missing for each run is the FASTQ samples of RNA-Seq reads and FASTA
transcriptomes to align them too. To download the FASTQ and FASTA files 
run the two shell scripts, download_a.sh and download_b.sh from the project
folder. 


The shell scripts contain wget commands for downloading the FASTQ files
from SRA and downloading the FASTA transcriptomes from ensembl. Now you have
the FASTQ samples, metadata table as a csv file and, FASTA transcriptome and 



## Config parameters 









## Some figures from the example data

### Example A



### Example B
