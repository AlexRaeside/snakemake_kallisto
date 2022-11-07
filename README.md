---
title: "Kallisto Snakemake"
output: html_document
date: "2022-10-20"
---


# Creating a Kallisto Snakemake pipeline for single-read RNA-Seq

## Overview 

![image info](./figures/dag.svg)



## Creating the yaml 


## Usage

```
# download dependencies using conda
conda env create -f environment.yml 

# activate the conda enviroment to add dependencies to path
activate snakemake_env

# run the snakemake 
snakemake -c1 -s src/Snakefile \
test/20221020_Celegans/output/done/all_counts_moved.done
```

## Updates




