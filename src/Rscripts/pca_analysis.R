# PCA analysis of transformed counts data 
# based very very closely on:
# https://tavareshugo.github.io/data-carpentry-rnaseq/03_rnaseq_pca.html


# test dummy data 


#metadata_file <- "test/RunA_Maize/metadata/metadata.csv"
#counts_file <- "vst_counts_filtered_medi200.csv"
#samples_col <- "Run"
#experiment_col <- "GENOTYPE"
#out_dir <- "test/RunA_Maize/"

###----- Set the environment ---------------------------------------------------

require(tidyverse, quietly = TRUE)
require(ggplot2, quietly = TRUE)
require(plotly, quietly = TRUE)
require(dplyr, quietly = TRUE)
require(svglite, quietly = TRUE)
require(htmlwidgets, quietly = TRUE)




###------ handle input ---------------------------------------------------------

counts_file <- snakemake@params[["counts"]]
metadata_file <-snakemake@params[["meta"]]
out_dir <- snakemake@params[["out"]]
sample_col <- snakemake@params[["sample_col"]]
exp_col <- snakemake@params[["exp_col"]]


### ----- PCA analysis ---------------------------------------------------------


counts_tbl <- read_csv(counts_file, show_col_types = FALSE)
meta_tbl <- read_csv(metadata_file, show_col_types = FALSE)

pca_matrix <- counts_tbl %>%
    column_to_rownames(colnames(counts_tbl)[1]) %>%
    as.matrix() %>%
    t()

sample_pca <- prcomp(pca_matrix)

pc_eigenvalues <- sample_pca$sdev^2

pc_eigenvalues <- tibble(
    PC = factor(1:length(pc_eigenvalues)),
    variance = pc_eigenvalues) %>%
    mutate(pct = variance/sum(variance)*100) %>%
    mutate(pct_cum = cumsum(pct))


gg_pareto <- pc_eigenvalues %>% 
    ggplot(aes(x = PC)) +
    geom_col(aes(y = pct)) +
    geom_line(aes(y = pct_cum, group = 1)) +
    geom_point(aes(y = pct_cum)) +
    labs(x = "Principal component", y = "Fraction variance explained")
    


pc_scores <- sample_pca$x %>%
    as_tibble(rownames = "sample")

# add the experimental variable to pc_scores 

pc_scores <- merge(pc_scores, meta_tbl, by.x = "sample", by.y = sample_col)


# create tooltip text 
# with Sample name, experimental value and 

tooltip_tbl <- pc_scores %>%
    dplyr::select(PC1, PC2, sample, !!sym(exp_col))

tooltip_tbl$PC1 <- paste0("PC1: ", tooltip_tbl$PC1)
tooltip_tbl$PC2 <- paste0("PC2: ", tooltip_tbl$PC2)

df_args <- c(tooltip_tbl, sep ="\n")
tooltip <- do.call(paste, df_args)


# get percentages of variation explained by 
# PC1 and PC2

pc1_stat <- paste0("PC1 (", round(pc_eigenvalues[[1,3]],1), "%)")
pc2_stat <- paste0("PC2 (", round(pc_eigenvalues[[2,3]],1), "%)")


gg_pc_scores <- pc_scores %>% 
    ggplot(
        aes(
            x = PC1, 
            y = PC2, 
            colour = !!sym(exp_col),
            text = tooltip)) +
    geom_point() +
    xlab(pc1_stat) +
    ylab(pc2_stat) +
    theme_bw()

plotly_pca <- ggplotly(gg_pc_scores, tooltip = "text")



##---- print out png, svg and wegits -------------------------------------------


# take the file name 
basename <- paste0("pca_", str_remove(basename(counts_file), ".csv"))


# write the png, svg to figures folder 

ggsave(
    paste0(out_dir, "/figures/", basename, ".png"),
    plot = gg_pc_scores,
    device = "png")

ggsave(
    paste0(out_dir, "/figures/", basename, ".svg"),
    plot = gg_pc_scores,
    device = "svg")


# write the widget to widgets folder 

html_file <- paste0(out_dir, "/plotly_widgets/", basename, ".html")

saveWidget(
    plotly_pca,
    html_file, selfcontained = F, libdir = "lib")






