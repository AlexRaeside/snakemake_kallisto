# Rscript for VST normalization 
# two arguments: 
# input counts file 
# output file name 


###------ setting the environment ----------------------------------------------

require(DESeq2, quietly = TRUE)
require(dplyr, quietly = TRUE)
require(argparser, quietly = TRUE)
require(readr, quietly = TRUE)
require(tibble, quietly = TRUE)

###----- args parse  -----------------------------------------------------------

p <- arg_parser("VST normalization")
p <- add_argument(
    p, 
    "--counts",
    help="path to raw counts table")
p <- add_argument(
    p, 
    "--out",
    help="output directory to write the cpm counts too")


argv <- parse_args(p)

counts_file <- argv$counts
out_dir <- argv$out


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
