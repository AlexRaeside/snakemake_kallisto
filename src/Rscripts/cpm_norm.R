# Rscript for CPM normalization 
# two arguments: 
# input counts file 
# output file name 

###------ setting the environment ----------------------------------------------

require(edgeR)
require(dplyr)
require(argparser)
require(readr)
require(tibble)

###----- args parse  -----------------------------------------------------------

p <- arg_parser("CPM normalization")
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


# for testing
#counts_file <- "test/RunA_Maize/tables/counts_filtered_medi100.csv"
#out_dir <- "test/RunA_Maize/tables"



counts_tbl <-read_csv(counts_file)

###-------- CPM Normalization --------------------------------------------------


# remove the target names 

target_ids <- counts_tbl[[1]]

# convert to CPM and add back target ids

counts_cpm <- as_tibble(cpm(counts_tbl[,-1])) %>%
    round(digits = 3) %>%
    add_column(target_ids, .before = 1)





###------- Write the CPM -------------------------------------------------------


# take the file name 
file <- basename(counts_file)
cpm_file <- paste0(out_dir, "/cpm_", file)
print(cpm_file)
write_csv(counts_cpm, cpm_file)







