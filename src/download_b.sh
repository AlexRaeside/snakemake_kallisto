#!/usr/bin/env bash
mkdir data/fastq/rat

curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR214/094/SRR21401494/SRR21401494.fastq.gz \
-o data/fastq/rat/SRR21401494.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR214/095/SRR21401495/SRR21401495.fastq.gz \
-o data/fastq/rat/SRR21401495.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR214/014/SRR21401514/SRR21401514.fastq.gz \
-o data/fastq/rat/SRR21401514.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR214/010/SRR21401510/SRR21401510.fastq.gz \
-o data/fastq/rat/SRR21401510.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR214/002/SRR21401502/SRR21401502.fastq.gz \
-o data/fastq/rat/SRR21401502.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR214/006/SRR21401506/SRR21401506.fastq.gz \
-o data/fastq/rat/SRR21401506.fastq.gz

# also download the rat transcriptome from ensembl 

mkdir data/transcriptomes

curl -L \
https://ftp.ensembl.org/pub/release-108/fasta/rattus_norvegicus/cdna/Rattus_norvegicus.mRatBN7.2.cdna.all.fa.gz \
-o data/transcriptomes/Rattus_norvegicus.mRatBN7.2.cdna.all.fa.gz