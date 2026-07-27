install.packages("ggrepel")
library(ggplot2)
library(dplyr)
library(cowplot)
library(ggrepel)
library(readxl)
setwd("~/Library/CloudStorage/OneDrive-WageningenUniversity&Research/3_Experimental_work/4_groenafval/Sequencing")
getwd()

# read in the eigenvectors, produced in PLINK
eigenvec_LFHF_global <- read.table('LFHF_global_50000_plink.eigenvec', header = FALSE)
eigenval_LFHF_global <- read.table('LFHF_global_50000_plink.eigenval', header = FALSE)
colnames(eigenvec_LFHF_global) <- c("FID", "Sample", paste0("PC", 1:(ncol(eigenvec_LFHF_global)-2)))
eigenvec_LFHF_global$FID <- NULL
class(eigenvec_LFHF_global)
head(eigenvec_LFHF_global)

meta <- read_xlsx('Meta_PCA_LFHF_global.xlsx')
head(meta)
meta <- meta[, 1:3]
colnames(eigenvec_LFHF_global)
colnames(meta)
eigenvec_LFHF_global$Sample <- as.character(eigenvec_LFHF_global$Sample)
meta$Sample <- as.character(meta$Sample)
data <- left_join(eigenvec_LFHF_global, meta, by = "Sample")
head(data)

##To calculate the percentages of difference
var_explained <- eigenval_LFHF_global$V1 / sum(eigenval_LFHF_global$V1) * 100  # percentage
var_explained
xlab <- paste0("PC1 (", round(var_explained[1], 1), "%)")
ylab <- paste0("PC2 (", round(var_explained[2], 1), "%)")


ragg::agg_tiff("PCA_LFHF_global_v01.tiff", width = 6.98, height = 5.91, units = "in", res = 300) #to get a high-resolution image #
ggplot(data) + theme_classic(base_size = 12) +
  geom_point(aes(x=PC1, y=PC2, color=Type), size=1.5, alpha=0.6) + 
  labs(x = xlab, y = ylab)

dev.off()

##This gave quite a bit of outliers, that seem to belong to the "weird" group in the A. fumigatus population. 
##Therefore, samples that seem to belong to these group have been removed from the combined.vcf.gz & the PCA.sh was ran again on the new vcf.gz. 
##Below, we will redo most of the work with the new documents. 

samples_to_remove <- data$Sample[data$PC2 > 0.05] #To filter the values to seem to form a separate group within the PCA. 
samples_to_remove

filter_2 <- data_filtered$Sample[data_filtered$PC2 > 0.04] #for second filter

filter_3 <- data_filtered$Sample[data_filtered$PC2 > 0.05] #for third filter
filter_3

samples_to_remove <- append(samples_to_remove, filter_2)
samples_to_remove <- append(samples_to_remove, filter_3)
samples_to_remove

write.table(samples_to_remove, "Remove_PCA_LFHF_global_5000_v01.txt", #This document is the input for filtering the combined.vcf.gz
            row.names = FALSE, col.names = FALSE, quote = FALSE)


###When wanting to work on the new data; start here. 
#Here we will start using the new data. 
eigenvec_LFHF_global_filtered <- read.table('LFHF_global_50000_v04_plink.eigenvec', header = FALSE)
eigenval_LFHF_global_filtered <- read.table('LFHF_global_50000_v04_plink.eigenval', header = FALSE)
colnames(eigenvec_LFHF_global_filtered) <- c("FID", "Sample", paste0("PC", 1:(ncol(eigenvec_LFHF_global_filtered)-2)))
eigenvec_LFHF_global_filtered$FID <- NULL
class(eigenvec_LFHF_global_filtered)
head(eigenvec_LFHF_global_filtered)

meta <- read_xlsx('Meta_PCA_LFHF_global.xlsx')
head(meta)
meta <- meta[, 1:3]
colnames(eigenvec_LFHF_global_filtered)
colnames(meta)
eigenvec_LFHF_global_filtered$Sample <- as.character(eigenvec_LFHF_global_filtered$Sample)
meta$Sample <- as.character(meta$Sample)
data_filtered <- left_join(eigenvec_LFHF_global_filtered, meta, by = "Sample")
head(data_filtered)

##To calculate the percentages of difference
var_explained_filtered <- eigenval_LFHF_global_filtered$V1 / sum(eigenval_LFHF_global_filtered$V1) * 100  # percentage
var_explained_filtered
xlab <- paste0("PC1 (", round(var_explained_filtered[1], 1), "%)")
ylab <- paste0("PC2 (", round(var_explained_filtered[2], 1), "%)")

#To make sure the populations go in the correct order
data_filtered$Type <- factor(data_filtered$Type, levels = c("Global", "Low fungicide", "High fungicide"))

ragg::agg_tiff("PCA_LFHF_global_filtered_v03.tiff", width = 6.98, height = 5.91, units = "in", res = 300) #to get a high-resolution image #
ggplot(data_filtered %>% arrange(Type)) + theme_classic(base_size = 12) +
  geom_point(aes(x=PC1, y=PC2, color=Type, alpha=Type), size=1.5) + 
  labs(x = xlab, y = ylab) +
  scale_color_manual(values = c(
    "Global" = "#F0DDE4",
    "High fungicide" = "#ffb8f2" ,
    "Low fungicide" = "#850D6F"
  )) +
  scale_alpha_manual(values = c(
    "Global" = 0.5,
    "High fungicide" = 0.6,
    "Low fungicide" = 0.6
  ))


dev.off()

##Add the further filtering requirements to the list above in samples_to_remove. 

filter_3 <- data_filtered$Sample[data_filtered$PC2 > 0.05] #for third filter
filter_3

not_found_meta <- data_filtered$Sample[data_filtered$Type = NA] 



