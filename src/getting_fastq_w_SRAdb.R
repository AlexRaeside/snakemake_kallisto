# a r script to get the C.elegans experimental fastq data 

BiocManager::install("SRAdb")


###---- Setting Enviroment ---------------------------------

library(SRAdb)




###----- Getting SSR ids for samples ---------------------


sqlfile <- getSRAdbFile()


# Find the SRR ids for the fastq samples



# Get Fastq using SSR samples 