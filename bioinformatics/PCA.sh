# !/bin/bash

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

##The filtering will be done in this script just to keep track. 
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

