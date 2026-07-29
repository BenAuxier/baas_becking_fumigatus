#!/bin/bash

#To get the list of the names of the samples that are still included in the LF and HF datasets.
#bcftools query -l LFHF_global_final_AD_5_50000.vcf.gz | grep 'BB_28' > LF_population.txt
#bcftools query -l LFHF_global_final_AD_5_50000.vcf.gz | grep 'HF_G' > HF_population.txt

##First, the GTs that are currently a 2 or 3 need to go, as these will be problematic later on. These will be set to .
#bcftools view -m2 -M2 LFHF_global_final_AD_5_50000.vcf.gz -Oz -o LF_HF_global_biallelic.vcf.gz

#This line will make sure that the haploid GT-calls will become diploid, as Fst doesn't run on haploid samples. 
#bcftools +fixploidy LF_HF_global_biallelic.vcf.gz -- -f 2 > LFHF_global_final_AD_5_50000_diploid.vcf.gz

#Doing the actual Fst.
#vcftools --gzvcf LFHF_global_final_AD_5_50000_diploid.vcf.gz --weir-fst-pop LF_population.txt --weir-fst-pop HF_population.txt --fst-window-size 10000 --fst-window-step 5000 --out fst_LF_HF

