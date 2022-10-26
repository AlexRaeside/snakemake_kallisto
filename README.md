---
title: "Kallisto Snakemake"
output: html_document
date: "2022-10-20"
---


## What is Snakemake 



## Why Kallisto 


## Source Data 

Using C.elegans 




## Config file 

You can also embed plots, for example:

```
output_folder: test/20221020_Celegans/output/
fasta: data/transcriptomes/Celegans.cdna.all.fa.gz
idx_name: Celegans

```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.


## Kallisto index 

Lets try building the index from the fasta 
What i want is the index 

test/20221020_Celegans/output/Celegans.idx

that snakemake line should be something like 

```

snakemake \
--dryrun \
--snakefile src/kallisto_index.smk \
--cores 1 \
--configfile src/TestConfigA.yaml \
--dag \
Celegans.idx | dot -Tsvg > figures/dag.svg


snakemake \
--dryrun \
--snakefile src/basic_kallisto_index.smk \
--cores 1 \
--dag \
Celegans.idx | dot -Tsvg > figures/dag.svg

# this works 
snakemake \
--configfile src/TestConfigA.yaml \
--dryrun \
--snakefile src/config_kallisto_index.smk \
--cores 1 \
--dag \
Celegans.idx | dot -Tsvg > figures/dag.svg


snakemake \
--use-conda \
--configfile src/TestConfigA.yaml \
--snakefile src/kallisto_index.smk \
--cores 1 \
test/20221020_Celegans/output/Celegans.idx 

```

## Kallisto Quant 





Your conda installation is not configured to use strict channel priorities. This is however crucial for having robust and correct environments (for details, see https://conda-forge.org/docs/user/tipsandtricks.html). Please consider to configure strict priorities by executing 'conda config --set channel_priority strict'.

## Kallisto quant 