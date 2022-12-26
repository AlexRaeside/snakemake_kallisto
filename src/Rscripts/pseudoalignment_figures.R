# R script for pseduoalignment 
# The rule will have two inputs:
# tables/counts_summary.csv and the done/all_counts_moved.done 



##-------- Setting environment -------------------------------------------------

require(tidyr)
require(plotly)
require(ggplot2)
require(readr)
require(yaml)
require(dplyr)
require(svglite)
require(htmlwidgets)
require(argparser)

##--- snakemake input -----------------------------------------------------------



work_dir <- snakemake@params[['out']]

##------- Loading tables -------------------------------------------------------

# work_dir <- "test/RunA_Maize"


# 
counts_summary <- read_csv(
    paste0(work_dir, "/tables/counts_summary.csv"), 
    show_col_types = FALSE)

##----- Create static figure --------------------------------------------------


figure_name <- "pseudoalignment_summary"
figure_path <- paste0(work_dir, "/figures/")
png_file <- paste0(figure_path, figure_name, ".png")
svg_file <- paste0(figure_path, figure_name, ".svg")


# place summary information in a table with 
# sample, number, percent, stat_type

counts_processed <- counts_summary %>%
    dplyr::select(sample, n_processed)
colnames(counts_processed) <- c("sample", "reads")
counts_processed$porportion <- NA
counts_processed$stat_type <- "processed"
counts_processed$reads_in_group <- counts_summary$n_processed - 
    counts_summary$n_pseudoaligned

counts_aligned <- counts_summary %>%
    dplyr::select(sample, n_pseudoaligned)
colnames(counts_aligned) <- c("sample", "reads")
counts_aligned$porportion <- counts_summary$p_pseudoaligned
counts_aligned$stat_type <- "pseudoaligned"
counts_aligned$reads_in_group <- 
    counts_summary$n_pseudoaligned - counts_summary$n_unique

counts_unique <- counts_summary %>%
    dplyr::select(sample, n_unique)
colnames(counts_unique) <- c("sample", "reads")
counts_unique$porportion <- counts_summary$p_unique
counts_unique$stat_type <- "unique"
counts_unique$reads_in_group <- counts_summary$n_unique


summary_gg_tbl <- rbind(counts_processed, counts_aligned)
summary_gg_tbl <- rbind(summary_gg_tbl, counts_unique)



summary_bar_gg <- ggplot(
    data = summary_gg_tbl, aes(x= sample, y =reads_in_group, fill = stat_type)) +
    geom_bar(stat= "identity") + 
    geom_text(aes (y = reads, label = porportion), vjust = 2) +
    labs(x = "", y = "Reads") + 
    theme_classic() +
    scale_fill_manual(values = c(
        "processed" = "#855C75",
        "pseudoaligned" = "#D9AF6B",
        "unique" = "#AF6458")) +
    theme(legend.title=element_blank()) +
    theme(
        axis.text.x = element_text(
            face="bold", size=10, angle=90),
        axis.text.y = element_text(
            face="bold", size=10, angle=45))


suppressWarnings(ggsave(
    png_file, 
    plot = summary_bar_gg, 
    device = "png"))

suppressWarnings(ggsave(
    svg_file, 
    plot = summary_bar_gg, 
    device = "svg"))



##----- Create plotly figure --------------------------------------------------


plotly_file <- paste0(work_dir, "/plotly_widgets/pseduoalignment_summary.html") 


read_type <- case_when(
    summary_gg_tbl$stat_type == "unique" ~ " reads uniquely pseduoaligned\n",
    summary_gg_tbl$stat_type == "processed" ~ " reads processed\n",
    summary_gg_tbl$stat_type == "pseudoaligned" ~ " reads pseudoaligned\n"
)

porportions <- case_when(
    is.na(summary_gg_tbl$porportion) ~ "",
    !is.na(summary_gg_tbl$porportion) ~ paste0(
        summary_gg_tbl$porportion, "%\n"
    )
)



summary_gg_tbl$labels <- paste0(
    paste0(summary_gg_tbl$sample, "\n"),
    paste0(summary_gg_tbl$reads, read_type),
    porportions
    
)


plotly_gg <- ggplot(
    data = summary_gg_tbl, aes(
        x= sample, 
        y =reads_in_group, 
        fill = stat_type, 
        text = labels)) +
    geom_bar(stat= "identity") + 
    labs(x = "", y = "Reads") + 
    theme_classic() +
    scale_fill_manual(values = c(
        "processed" = "#855C75",
        "pseudoaligned" = "#D9AF6B",
        "unique" = "#AF6458")) +
    theme(legend.title=element_blank()) +
    theme(
        axis.text.x = element_text(
            face="bold", size=10, angle=90),
        axis.text.y = element_text(
            face="bold", size=10, angle=45))



plotly_pseduoalign <- ggplotly(plotly_gg, tooltip = "text") %>%
    layout(legend = list(title = list(text = "")))

saveWidget(
    plotly_pseduoalign,
    plotly_file, selfcontained = F, libdir = "lib")

