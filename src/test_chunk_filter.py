"""
A script to test loading the tmp_counts_raw.csv which has targets as cols and
samples as rows producing a counts_raw.csv which is transposed and
filtered_counts_raw.csv which is only contains the targets with a median
count => 25

The ncols is the target number + 1  and the first col is sample names
the rest are estimated counts

The nrows is the sample number +1 with the first row being
target ids (usually between 25000-75000) and the rest being
estimated counts.

I don't really need to preserve an order of targets but the
first row in the new table must be samples. That's
easy to make with the SAMPLES var. Write as
counts_raw.csv and filtered_counts_raw.csv

Then take col 2-1000 using ncols, transpose and write under the
counts_raw.csv.

Filter the transposed table and write under filtered_counts_raw.csv

Would be really useful if I had an indices of the col chunks
"""

targets = 72301

max_batch = 2000

chunk_number = targets // max_batch + bool(targets % max_batch)

for n in range(0, chunk_number):
    start = n * max_batch
    end = start + max_batch
    print((n, start, end))


