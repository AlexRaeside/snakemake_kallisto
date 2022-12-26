# Rscript for VST normalization 
# two arguments: 
# input counts file 
# output file name 


###------ setting the environment ----------------------------------------------

require(DESeq2, quietly = TRUE)
require(dplyr, quietly = TRUE)
require(readr, quietly = TRUE)
require(tibble, quietly = TRUE)

###----- snakemake inputs   ----------------------------------------------------

# counts file 
counts_file <- snakemake@input[["filtered_counts_file"]]

# tables directory to write the resulting file 
out_dir <- snakemake@params[["out_dir"]]

# test file 


#counts_file <- "test/RunA_Maize/tables/counts_filtered_medi200.csv"
#out_dir <- "."


counts_tbl <-read_csv(counts_file, show_col_types = FALSE)

###-------- CPM Normalization --------------------------------------------------


# store target names 

targets <- counts_tbl[["target"]]

# convert to CPM and add back target ids

counts_tbl <- counts_tbl %>%
    column_to_rownames("target") %>%
    as.matrix() 

mode(counts_tbl) <- "integer"
    
    
counts_vst <- as_tibble(
    varianceStabilizingTransformation(as.matrix(counts_tbl))) %>%
    round(digits = 3) %>%
    add_column(targets, .before = 1)



###------- Write the VST -------------------------------------------------------


# take the file name 
file <- basename(counts_file)
vst_file <- paste0(out_dir, "/vst_", file)
write_csv(counts_vst, vst_file)
