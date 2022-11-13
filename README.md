---
title: "Kallisto Snakemake"
output: html_document
date: "2022-10-20"
---


# Creating a Kallisto Snakemake pipeline for single-read RNA-Seq

## Overview 

![image info](./figures/dag.svg)



## Finding test datasets 



## Creating the yaml 


## Usage

```
# download dependencies using conda
conda env create -f environment.yml 

# activate the conda enviroment to add dependencies to path
activate snakemake_env

# run the snakemake 
snakemake -c1 -s src/Snakefile \
test/RunA_Maize/done/all_counts_moved.done


# run this if you want a nice figure
snakemake -c1 --dag -s src/Snakefile \
test/20221020_Celegans/output/done/all_counts_moved.done | dot -Tsvg > \
figures/dag.svg

# looks like it will work

snakemake -c1 --use-conda --dag --configfile data/configs/ConfigA.yaml \
-s src/Snakefile test/RunA_Maize/done/all_counts_moved.done| dot -Tsvg > \
figures/maize_dag.svg

snakemake -c1 --use-conda -s src/Snakefile \
test/RunA_Maize/done/all_counts_moved.done

```

## Updates

### 2022_11_13

Going to add logging and conda env. Done. Snakemake checks the the 
same folder as the snakemake script for the conda first. 

What is the problem with the yamls files? Placing the line
configfile: "data/configs/ConfigA.yaml" in the Snakemake works fine but 
running the line..

```

snakemake -c1 --use-conda --dag --configfile data/configs/ConfigA.yaml \
-s src/Snakefile test/RunA_Maize/done/all_counts_moved.done| dot -Tsvg > \
figures/maize_dag.svg


```
Also works. 


### 2022_11_12

Renaming the metadata table into a sample table.
Added the metadata as a separate table.
Added new datasets and shell scripts to downloads them.
Remerging to main branch before starting work on automated figures and 
report building. 





