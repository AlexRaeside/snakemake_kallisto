# make some art from the sample summary file 
# and results config file


##----- Setting the environment ------------------------------------------------

require(readr)
require(dplyr)
require(stringr)
require(yaml)
require(ggplot2)

# artsy isn't one of the many R packages stored on the conda repo 
# so will need to be installed the first time this is run 


if (!("aRtsy" %in% installed.packages()[,"Package"])){
    
    print("R package aRtsy missing")
    print("Downloading aRtsy from Cran")
    
    install.packages("aRtsy", verbose = FALSE)
    
}

require(aRtsy)


##---- Loading in files --------------------------------------------------------


# requires as input a results folder 
# which will contain counts summary and config file 

results_dir <- snakemake@params["results_dir"]

counts_summary_file <- paste0(results_dir, "/counts_summary.csv")
config_file <- paste0(results_dir, "/config.yaml")


counts_summary <- read_csv(counts_summary_file, show_col_types = FALSE)
config <- read_yaml(config_file)




##----- select vars to find into artsy canvas functions ------------------------

# what numbers and names represent the run 

title <- config$run_name
target_n <- counts_summary$n_targets[[1]]
samples_n <- config$n_samples
fasta <- strsplit(basename(config$fasta), ".", fixed = TRUE)[[1]][[1]]
subtitle <- paste0(samples_n, " samples aligned to ", fasta)

style_n = as.numeric(stringr::str_sub(target_n, -1, -1))

style <- case_when(
    style_n == 0 ~ "splits",
    style_n == 1 ~ "petri",
    style_n == 2 ~ "flow",
    style_n == 3 ~ "langtonst",
    style_n == 4 ~ "collatz",
    style_n == 5 ~ "maze",
    style_n == 6 ~ "mesh",
    style_n == 7 ~ "planets",
    style_n == 8 ~ "recamans",
    style_n == 9 ~ "phyllotaxis"
)


# set seed base on the last 5 digits of total reads aligned 

if(config$total_pseduoaligned_n >= 10000){
    
    seed_n = as.numeric(
        stringr::str_sub(
            config$total_pseduoaligned_n, -5, -1))}

if(config$total_pseduoaligned_n < 10000){
    
    seed_n = config$total_pseduoaligned_n
    }


# the color pallet is determined by the median p_aligned 
# so negative controls do not disrupt 

median_aligned <- median(counts_summary$p_pseudoaligned)

palette <- case_when(
    median_aligned >= 0.90 ~ "klimt",
    median_aligned >= 0.80 ~ "gogh",
    median_aligned >= 0.70 ~ "jasp",
    median_aligned >= 0.60 ~ "biology1",
    median_aligned < 0.60 ~ "dark1"
)



##------ Generate Art ----------------------------------------------------------


set.seed(seed_n)

if(style == "splits"){
    art <- canvas_splits(colors = colorPalette(palette))}

if(style == "petri"){
    # takes time
    print("Running petri dish algorithm. Takes some time")
    art <- canvas_petri(
        colors = colorPalette(palette),
        iterations = 15,
        hole = 0.0,
        background = "white",
        dish = "lightgrey")
    }

if(style == "flow"){
    art <- canvas_flow(colors = colorPalette(palette))
    
}


if(style == "langtonst"){
    art <- canvas_ant(colors = colorPalette(palette))
}

if(style == "collatz"){
    art <- canvas_collatz(colors = colorPalette(palette))
}


if(style == "maze"){
    art <- canvas_maze(
        color = colorPalette(palette)[3],
        walls = colorPalette(palette)[2])
    }

if(style == "mesh"){
    art <- canvas_mesh(
        colors = colorPalette(palette),
        transform = "perlin"
    )
}
    
if(style == "planets"){
    print("Running planet algorithm. Takes some time")
    art <- canvas_planet(
        colors = colorPalette(palette),
        iterations = 100)
}

if(style == "recamans"){
    art <- canvas_recaman(
        colors = colorPalette(palette)
    )
    
    
}


if(style == "phyllotaxis"){
    art <- canvas_phyllotaxis(colors = colorPalette(palette))
    
}


##--------- Print out art ------------------------------------------------------

art_w_title <- art +
    ggplot2::ggtitle(
        config["run_name"],
        subtitle = subtitle)

art_path <- paste0(results_dir, "/figures/")


ggsave("art.png", plot = art, device = "png", path = art_path)
ggsave("art.svg", plot = art, device = "svg", path = art_path)
ggsave("title_art.png", plot = art_w_title, device = "png", path = art_path)
ggsave("title_art.svg", plot = art_w_title, device = "svg", path = art_path)

##---------- Write done file ---------------------------------------------------

done_file <- snakemake@output["art_done"][[1]]
print(done_file)
file.create(done_file)

