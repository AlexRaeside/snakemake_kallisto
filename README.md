# Creating a Kallisto_Snakemake pipeline for single-read RNA-Seq

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
scale with additional cores. There is a few things to add like 
creating additional summary tables of the FASTQC reports of 
each of the samples and it would be good to adapt the 
pipeline for parired-end reads. Am not currently 
adding to the snakemake pipeline.


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

```
conda install snakemake mamba 

```
Once snakemake and mamba are installed and
added to path its time to run the sankemake pipeline 

```


# create a working directory 
# same path as the working directory in the config

mkdir test/exampleA

# before running the full snakemake 
# try creating a DAG figure and 
# rulegraoh figure to check the rules 
# and config file are working corrrectly 

# Perform a dry run 
# Will determine the about of jobs necessary 
# to produce the output file art.done 
# if you don't want to use aRtsy you can 
# use run.done as the final output file

snakemake \
--snakefile src/Snakefile \
--configfile data/configs/ConfigA.yaml \
--cores 1 --dry-run test/exampleA/done/art.done

# Create a rule graph
snakemake \
--snakefile src/Snakefile \
--configfile data/configs/ConfigA.yaml \
--cores 1 --rulegraph test/exampleA/done/art.done | dot -Tsvg > \
figures/testA_rulegraph.svg


# Create a DAG 
snakemake \
--snakefile src/Snakefile \
--configfile data/configs/ConfigA.yaml \
--cores 1 --DAG test/exampleA/done/art.done | dot -Tsvg > \
figures/testA_dag.svg




```

If the DAG and rule graph figures looks like the figures at 
the bottom of this README then the snakemake is 
good to go. Using 1 core the full pipeline 
will take around a hour. 

```

snakemake -s src/snakefile.smk \
--config-file data/configs/configA.yaml \
-c1 test/exampleA/done/art.done 

```

## Example figures 


![ Snakemake rule graph](figures/testA_rulegraph.svg)


Snakemake rule graph for single-read RNA-Seq


![ DAG for dataset A](figures/maize_dag.svg)


8 FASTQ samples pseudoaligned to maize transcriptome

![Pseudoalignment summary for dataset A](figures/maize_pseudoalignment_summary.svg)


Pseudoalignment summary for test A

![PCA for dataset A](figures/maize_pca_vst_counts_filtered_medi200.svg)


PCA for dataset A based on VST normalization of counts

The summary table gets used to generate some via aRtsy

![Art for DatasetA](figures/title_art.svg)


## Dev Diary

### 2023 01 09 
I've been thinking about what I can add to this or what would need to improve in order for the project to seem more 'professional' at first glance. In terms of project structure, there are a few things I can improve by placing conda envs into a separate directory and more importantly
placing the snakemake rules and helper functions into separate files. It would make the snakemake file itself look a lot clearer and help me understand which rules could be reimported and reused if I want to make a paired-end read RNA-Seq pipeline along with the single-read RNA-Seq pipeline I have now.


I have been thinking about visualization and reporting and how I would want to add this. Originally the idea was to have the pipeline create a projects results folder that could be opened and viewed by a web app, either RShiny or Streamlit. But I've been thinking does need to be a web app
that would need a whole bunch of stuff or just a standalone html report that could be emailed to the user when the pipeline is complete.


Quarto has a function to produce a standalone html from a quarto markdown .qmd file. Might be worth looking at as the final stage of the analysis. 
I'll probably create and close a seperate branch for just tidying up the code before I think to much about reporting. 
I could use really improve the art generation using something like [this](https://medium.com/@yanhann10/paint-like-the-artist-piet-mondrian-in-r-784c5264d5cc)





