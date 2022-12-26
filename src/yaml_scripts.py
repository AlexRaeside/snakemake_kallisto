import yaml
import time 
import pandas as pd
import snakemake_modules.metadata as meta
import datetime

start_time = datetime.datetime.now()

with open('data/configs/ConfigA.yaml', 'r') as file:
    run_info = yaml.safe_load(file)

end_time = time.time()


run_info["run_start"] = start_time 
run_info["end"] = end_time 


# load the summary table 
# total number of samples processed 
# total number of reads 
# total number of reads aligned 

summary_stats = pd.read_csv("test/RunA_Maize/tables/counts_summary.csv")


new_config = {
    "name" : run_info["run_name"],
    "fasta" : run_info["fasta"],
    "metadata" : run_info["metadata_experiment_col"],
    "n_samples": len(summary_stats.index),
    "total_reads_n" : sum(summary_stats["n_processed"]),
    "total_pseduoaligned_n" : sum(summary_stats["n_pseudoaligned"]) ,
    "total_pseduoaligned_p" : round(
        sum(summary_stats["n_pseudoaligned"]) / sum(summary_stats["n_processed"]
        )),
    "run_start_time": str(start_time),
    "run_end_time": str(end_time)}




