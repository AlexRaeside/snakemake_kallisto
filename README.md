---
title: "Kallisto Snakemake"
output: html_document
date: "2022-10-20"
---


# Creating a Kallisto Snakemake pipeline for single-read RNA-Seq

## Overview

A Bioinformatics project to show that I can create basic NGS pipeline using some
common bioinformatics tools like bioconda, snakemake, python and R.

[Snakemake](https://snakemake.readthedocs.io/en/stable/) pipeline which takes a
transcriptiome fasta file and singe-read RNA-Seq fastq files and create counts
tables using [Kallisto](https://pachterlab.github.io/kallisto/about). 
Strictly speaking Kallisto does not align reads it pseudoaligns them using
fancy matching so doesn't produce a BAM or anything I can use to do varaint 
calling or anything like that. Kallisto was used since it works well on a laptop.

Once a counts table is produce the snakemake pipeline will then create 
some basic QC plots showing the porportion of reads pseudoaligned and 
a PCA with the samples coloured by a experimental variable found in the 
metdata. Along with .png and .svg files for the figures, plotly wedgits made 
with the [plotly r]() package will also be produced which can be added
to a [quarto]() or [streamlit]() report at some point.

There is no particular reason for a NGS pipeline to create little 
art works but I really just made this to practice stringing 
python, R and shell togtheir in a automation pipeline that 
scale with additional cores. 


## Running the Snakemake 

Once cloned the repo contains configs and metadata for two 
test runs on maize and rat data. To download the rest of the
data, FASTQ reads and FASTA transcriptomes, run the two
shell scripts in the scr/ folder.

```

src/download_exampleA.sh
src/download_exampleB.sh

```

Download snakemake and mamba. Mamba is used
to quickly download the other programs and 
R pcakages in conda enviroments.

``
conda install snakemake mamba 

``

Before running the pipeline from start to 
finish, generate a DAG diagram to make sure 
the rules and config are connecting correctly.

```

```


If the DAG figure looks like the DAG at 
the bottom of this README then the snakemake is 
good to go. Using 1 core the full pipeline 
will take around a hour. 

'''


'''

## Example figures 

![ DAG for dataset A](figures/maize_dag.svg)
* 8 FASTQ samples pseudoaligned to maize transcriptome 

![Pseudoalignment summary for dataset A]()


![Pseudoalignment summary for dataset A]()
