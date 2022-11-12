#!/usr/bin/env bash
mkdir data/fastq/maize


curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR648/009/ERR6484009/ERR6484009.fastq.gz \
-o data/fastq/maize/ERR6484009.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR648/004/ERR6484004/ERR6484004.fastq.gz \
-o data/fastq/maize/ERR6484004.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR648/003/ERR6484003/ERR6484003.fastq.gz \
-o data/fastq/maize/ERR6484003.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR648/009/ERR6483999/ERR6483999.fastq.gz \
-o data/fastq/maize/ERR6483999.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR648/000/ERR6484000/ERR6484000.fastq.gz \
-o data/fastq/maize/ERR6484000.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR648/008/ERR6484008/ERR6484008.fastq.gz \
-o data/fastq/maize/ERR6484008.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR648/001/ERR6484001/ERR6484001.fastq.gz \
-o data/fastq/maize/ERR6484001.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR648/007/ERR6484007/ERR6484007.fastq.gz \
-o data/fastq/maize/ERR6484007.fastq.gz


# also download the maize transcriptome from ensembl plants

mkdir data/transcriptomes

curl -L https://ftp.ensemblgenomes.org/pub/plants/release-55/fasta/zea_mays/cdna/Zea_mays.Zm-B73-REFERENCE-NAM-5.0.cdna.all.fa.gz \
-o data/transcriptomes/Zea_mays.Zm-B73-REFERENCE-NAM-5.0.cdna.all.fa.g