This folder contains all scripts that were used during the analysis on the server. 
Below it will be listed what each of the scripts were used for, the visualization will be done using the Rscripts in plotting. 
At the bottom of this file, it will be listed what versions of certain software were while running these analyses. 

**aligner.sh** (Based on https://github.com/fungalsnelderslab/2024_Dutch_fumigatus/tree/main/aligner_mapping)
This script is used to align the fastq.gz files to the reference (Af293 incl. Mitochondrial DNA). 
For the global samples, fastp is used to QC the FASTQ sequencing data. bwamem2 and samtools are used to create the sorted.bam files
& gatk HaplotypeCaller is used to call variants relative to the reference. 

**groen_global_combiner.sh** (Based on https://github.com/fungalsnelderslab/2024_Dutch_fumigatus/tree/main/aligner_mapping)
This script will combine the individual files and turn them into a combined.vcf.gz. The exact filtering steps are explained in the script itself.

**calc_depth.sh**
This script was used to approximate the average coverage per sample based on the combined.vcf.gz that results from groen_global_combiner.sh

**resistance.sh** 
This script was used to take specific locations in the genome related to multi-fungicide resistance and mutation rate from the combined.vcf.gz.
The variants are then printed into an .tsv file. This script was used to genotypically determine the % of triazole-resistance (based on the TR haplotype of the _cyp51A_ in the populations. 

**extract_VAF_750.R**
This Rscript is used to filter on the VAF values; it removes variants that are too far from 0 or 1. The variants per sample are than counted and random subsets of that increase in steps of 10 are made.
The .rds output file is used to make the plot in plotting/Variant_counts_BB.R that was used to estimate the number of isolates that were before we stopped sequencing. 

**pixy.sh**
This script was used to determine the genomic diversity (pi) in the whole genome of the three populations (LF/HF/Global) that were part of this study. 

**chrom_4_pixy.sh**
This script was used to determine the genomic diversity (pi) in the chromosome 4 of the three populations (LF/HF/Global) that were part of this study. 

**sub_pixy.sh**
This script was used to determine the genomic diversity (pi) in the whole genome of the subpopulations (=sampling spot) in two of the populations (LF/HF).

**PCA.sh** (Based on https://github.com/fungalsnelderslab/2024_Dutch_fumigatus/tree/main/pca_plotting)
This script was performed to make the PCA with all three populations. Since at first there was a group of outliers that were scewing the data visualization, additional filtering was performed based on the PC values in R.
The isolates that would be removed were listed in the .txt file that would than filter them, and re-do the plink analysis. 

**HF_LF_Fst.sh** (Based on https://github.com/fungalsnelderslab/2024_Dutch_fumigatus/tree/main/pca_plotting)
This script compares the whole genomes of the LF and HF populations by calculating the Fixation Index for every 10 kb. 

**snelders_fst.sh** (Based on https://github.com/fungalsnelderslab/2024_Dutch_fumigatus/tree/main/plotting_fst)
This script compares the whole genome of the LF to the sensitive Dutch isolates from Snelders et al., 2025. 
It also compares the HF samples to the resistant Dutch isolates that paper. It again calcultates the Fixation Index for every 10kb. 


**Versions of software**
- Fastp -> v0.23.4
- bwamem2 -> v2.2.1
- samtools -> v1.6 (hitslib 1.6)
- gatk -> v4.6.1.0
- bcftools -> v1.23.1 (hitslib 1.23.1)
- plink -> v1.9.0-b.7.7
- vcftools -> v0.1.17
- R -> v4.5.3
