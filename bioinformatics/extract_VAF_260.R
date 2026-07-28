#!/usr/bin/env Rscript

# Load necessary library
library(vcfR)
library(dplyr)

# Read the VCF file
vcf_file <- "/lustre/BIF/nobackup/brigg002/analysis_new_global_data/global_final_AD_5.vcf.gz" #This is the vcf.gz after filtering out high-variant samples (n=2).
global_vaf <- read.vcfR(vcf_file, verbose = FALSE, convertNA = TRUE)

# Extract the VAF values as numeric
global_vaf <- extract.gt(global_vaf, element = "VAF", as.numeric = TRUE)

# Write the matrix to a TSV file
output_file <- "/lustre/BIF/nobackup/brigg002/analysis_new_global_data/VAF_new_global.tsv"
write.table(global_vaf, file = output_file, sep = "\t", quote = FALSE, row.names = TRUE, col.names = NA)

cat("VAF values successfully written to", output_file, "\n")

vaf_tsv <- "/lustre/BIF/nobackup/brigg002/analysis_new_global_data/VAF_new_global.tsv"
write.table(global_vaf, file = output_file, sep = "\t", quote = FALSE, row.names = TRUE, col.names = NA)

cat("VAF values successfully written to", output_file, "\n")

vaf_tsv <- "/lustre/BIF/nobackup/brigg002/analysis_new_global_data/VAF_new_global.tsv"
df_new_global_vaf <- read.table(vaf_tsv, header = TRUE, row.names = 1, sep = "\t", check.names = FALSE)
head(df_new_global_vaf)

df_new_global_vaf[df_new_global_vaf < 0.01] <- 0
df_new_global_vaf[df_new_global_vaf > 0.9] <- 1

#Now the rows that have only 1 or only 0 will be removed. Also, all rows with values that are not 0 or 1 will be removed.
df_new_global_vaf_filtered <- df_new_global_vaf[
  apply(df_new_global_vaf, 1, function(x) all(x %in% c(0, 1))),
]

before_filter <- nrow(df_new_global_vaf)
after_filter <- nrow(df_new_global_vaf_filtered)
number_removed <- before_filter - after_filter

cat("Before filter:", before_filter, "\n")
cat("After filter:", after_filter, "\n")
cat("Removed:", number_removed, "\n")

set.seed(123)
n_subsets <- 10
subset_sizes <- seq(10, 260, by = 10)

cat("⚙️  Generating random subsets...\n")

all_subsets <- lapply(subset_sizes, function(k) {
  replicate(n_subsets, {
    sampled_cols <- sample(ncol(df_new_global_vaf_filtered), k)
    df_new_global_vaf_filtered[, sampled_cols, drop = FALSE]
  }, simplify = FALSE)
})

names(all_subsets) <- paste0("k", subset_sizes)
                                                               # ---- 4. Filter invariant rows within each subset ----
filter_invariant_rows <- function(subset) {
  row_sums <- rowSums(subset)
subset[row_sums != 0 & row_sums != ncol(subset), , drop = FALSE]
}

cat("⚙️  Filtering invariant rows within subsets...\n")

all_subsets_filtered <- lapply(all_subsets, function(sublist) {
  lapply(sublist, filter_invariant_rows)
})

# ---- 5. Count rows per subset ----
nrows_after <- lapply(all_subsets_filtered, function(sublist) {
  sapply(sublist, nrow)
})

# ---- 6. Prepare plot data ----
cat("⚙️  Preparing data for plotting...\n")

plot_data <- lapply(names(nrows_after), function(size) {
  data.frame(
subset_size = as.numeric(gsub("k", "", size)),
    nrows = nrows_after[[size]],
    subset_id = seq_along(nrows_after[[size]])
  )
}) %>% bind_rows()

# ---- 7. Save plot data ----
plot_data_out <- "/lustre/BIF/nobackup/brigg002/analysis_new_global_data/new_global_260.rds"
saveRDS(plot_data, file = plot_data_out)
cat("✅ plot_data saved to", plot_data_out, "\n")

