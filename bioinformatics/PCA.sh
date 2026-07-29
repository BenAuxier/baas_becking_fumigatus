# !/bin/bash

#First, run the initial plink on all isolates. The results will be used to make a preliminary PCA
plink --vcf LFHF_global_final_AD_5_50000.vcf.gz \
      --make-bed \
      --out LFHF_global_filtered_plink_50000 \
      --allow-extra-chr \
      --double-id

plink --bfile LFHF_global_filtered_plink_50000 \
      --allow-extra-chr \
      --double-id \
      --genome \
      --pca

##The filtering will be done in this script just to keep track. The .txt files contains the file names of the outliers that will be filtered out based on PC-value (see /plotting/LFHF_global_PCA_BB.R)
#bcftools view -S "^Remove_PCA_LFHF_global_50000_v01.txt" -Oz -o LFHF_global_final_AD_5_50000_v02.vcf.gz LFHF_global_final_AD_5_50000.vcf.gz
#bcftools index -f LFHF_global_final_AD_5_50000_v02.vcf.gz

#plink --vcf LFHF_global_final_AD_5_50000_v02.vcf.gz \
#      --make-bed \
#      --out LFHF_global_filtered_plink_50000_v02 \
#      --allow-extra-chr \
#      --double-id

#plink --bfile LFHF_global_filtered_plink_50000_v02 \
#      --allow-extra-chr \
#      --double-id \
#      --genome \
#      --pca

