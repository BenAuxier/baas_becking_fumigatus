#!/bin/bash

#bcftools query -l LFHF_global_final_AD_5_50000.vcf.gz | grep 'SNEL_2025' > snelders_population.txt
#Get the res list - needs to be done if certain isolates were filtered out.

#grep -Fxf res_snelders.txt snelders_population.txt > res_snelders_fst.txt

#grep -Fxf sus_snelders.txt snelders_population.txt > sus_snelders_fst.txt

##Now, we will perform the analysis of the res against HF, and the sus against the LF. 

vcftools --gzvcf LFHF_global_final_AD_5_50000_diploid.vcf.gz --weir-fst-pop HF_population.txt --weir-fst-pop res_snelders_fst.txt --fst-window-size 10000 --fst-window-step 5000 --out fst_HF_snel

vcftools --gzvcf LFHF_global_final_AD_5_50000_diploid.vcf.gz --weir-fst-pop LF_population.txt --weir-fst-pop sus_snelders_fst.txt --fst-window-size 10000 --fst-window-step 5000 --out fst_LF_snel

