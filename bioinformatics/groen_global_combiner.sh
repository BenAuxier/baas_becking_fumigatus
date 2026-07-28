export PATH="/lustre/BIF/nobackup/brigg002/programs/conda/bin"
REFERENCE=/lustre/BIF/nobackup/brigg002/novogene2024/Af293_combined.fna

export PATH="/lustre/BIF/nobackup/brigg002/programs/conda/bin"
#Still have to check if it goes into the folders correctly
#gatk CombineGVCFs -R $REFERENCE -O LFHF_global.g.vcf.gz -V groen_global_GVCF.list
#Joined genotyping - the combined variants will be spit out by this
#gatk IndexFeatureFile -I  LFHF_global.g.vcf.gz
#gatk GenotypeGVCFs -R $REFERENCE -O LFHF_global.vcf.gz -V LFHF_global.g.vcf.gz

#The variants will be filtered based on their likelyhood  (see criteria in script); filter out low quality variants
#export PATH="/lustre/BIF/nobackup/brigg002/programs/conda/bin"
#gatk SplitVcfs -I LFHF_global.vcf.gz --SNP_OUTPUT LFHF_global_combined_SNPs.vcf.gz --INDEL_OUTPUT LFHF_global_combined_INDELs.vcf.gz --STRICT false
#echo "starting filtering SNPs"
#export PATH="/usr/bin"
#bcftools filter -O u -s "QD" -m + -e "QD < 2.0" LFHF_global_combined_SNPs.vcf.gz | bcftools filter -O u -s "MQ" -m + -e "MQ < 40.0" |bcftools filter -O u -s "FS" -m + -e "FS > 60.0" | bcftools filter -O u -s "MQRank" -m + -e "MQRankSum < -12.5" | bcftools filter -O u -s "ReadPos" -m + -e "ReadPosRankSum < -8.0" | bcftools view -O z -f "PASS" > LFHF_global_combined_SNPs_filtered.vcf.gz
#echo "finished filtering SNPs"
#bcftools index LFHF_global_combined_SNPs_filtered.vcf.gz
#bcftools view LFHF_global_combined_SNPs_filtered.vcf.gz | bcftools +fill-tags -Oz -o LFHF_global_VAF_combined_SNPs_filtered.vcf.gz -- -t FORMAT/VAF
#bcftools index LFHF_global_VAF_combined_SNPs_filtered.vcf.gz
#echo "VAF added to SNPs"
##Here we will adapt the VAF values
#echo "Start filtering VAF in SNPs"
#bcftools +setGT LFHF_global_VAF_combined_SNPs_filtered.vcf.gz \
#  -Oz -o LFHF_global_SNPs_VAF_adjusted.vcf.gz \
#  -- -tq .  -i 'FMT/VAF>0.05 & FMT/VAF<0.95' --new-gt .

#bcftools index LFHF_global_SNPs_VAF_adjusted.vcf.gz
#echo "Finished filtering VAF in SNPs"

#echo "starting filtering INDELs"
#bcftools filter -O u -s "QD" -m + -e "QD < 2.0" LFHF_global_combined_INDELs.vcf.gz | bcftools filter -O u -s "FS" -m + -e "FS > 200.0" | bcftools filter -O u -s "ReadPos" -m + -e "ReadPosRankSum < -20.0" | bcftools view -O z -f "PASS" > LFHF_global_combined_INDELs_filtered.vcf.gz
#echo "finished filtering INDELs"
#bcftools index LFHF_global_combined_INDELs_filtered.vcf.gz
#bcftools view LFHF_global_combined_INDELs_filtered.vcf.gz | bcftools +fill-tags -Oz -o LFHF_global_VAF_combined_INDELs_filtered.vcf.gz -- -t FORMAT/VAF
#bcftools index LFHF_global_VAF_combined_INDELs_filtered.vcf.gz
#echo "VAF added to INDELs"
##Here we will adapt the VAF values

#echo "Start filtering VAF in INDELs"
#bcftools +setGT LFHF_global_VAF_combined_INDELs_filtered.vcf.gz \
#  -Oz -o LFHF_global_INDELs_VAF_adjusted.vcf.gz \
#  -- -tq .  -i 'FMT/VAF>0.10 & FMT/VAF<0.80' --new-gt .

#bcftools index LFHF_global_INDELs_VAF_adjusted.vcf.gz
#echo "Finished filtering INDELs in SNPs"
#echo "If VAF shouldn't be included, GT has been set to NA (.)"
#echo "Merge SNPs and INDELs"

#bcftools concat -O z -a LFHF_global_INDELs_VAF_adjusted.vcf.gz LFHF_global_SNPs_VAF_adjusted.vcf.gz > LFHF_VAF_adjusted_global.vcf.gz
#export PATH="/lustre/BIF/nobackup/brigg002/programs/conda/bin"
#gatk IndexFeatureFile -I LFHF_VAF_adjusted_global.vcf.gz
#gatk VariantFiltration -R $REFERENCE -V LFHF_VAF_adjusted_global.vcf.gz -O LFHF_global_filtered_GT_AD_5.vcf.gz --genotype-filter-expression "(AD[0] > 5 || AD[1] > 5)" --genotype-filter-name "keep_variant"
export PATH="/usr/bin"
#bcftools +setGT LFHF_global_filtered_GT_AD_5.vcf.gz -Oz -o LFHF_global_VAF_AD_5_filtered.vcf.gz -- -t q -n . -i 'FMT/FT[*]=="PASS"'
#bcftools index -f LFHF_global_VAF_AD_5_filtered.vcf.gz
#echo "Done filtering AD"
#echo "Start recalculating INFO field"
#bcftools +fill-tags LFHF_global_VAF_AD_5_filtered.vcf.gz -Oz -o tmp.vcf.gz -- -t AC,AN,AF
#mv tmp.vcf.gz LFHF_global_VAF_AD_5_filtered_new_INFO.vcf.gz
#bcftools index -f LFHF_global_VAF_AD_5_filtered_new_INFO.vcf.gz
#echo "Print number of samples in combined vcf.gz file"

#echo "Start calculating % missing GT per variant"
#bcftools +fill-tags -Oz -o LFHF_global_variants_missing_GT_AD_5.vcf.gz LFHF_global_VAF_AD_5_filtered_new_INFO.vcf.gz -- -t F_MISSING

#echo "Start filtering variats with low % of GT"
#bcftools view -i 'F_MISSING<=0.15' LFHF_global_variants_missing_GT_AD_5.vcf.gz -Oz -o LFHF_global_good_variants_AD_5.vcf.gz
#bcftools index LFHF_global_good_variants_AD_5.vcf.gz  #Still discuss with Ben if this is not too strict!

#echo "Done filtering variants"

#echo "Start calculating samples with low nr of variants"

#TOTAL_VAR=$(bcftools view -H LFHF_global_good_variants_AD_5.vcf.gz | wc -l)
#echo $TOTAL_VAR
#bcftools stats -s - LFHF_global_good_variants_AD_5.vcf.gz | \
#awk -v total="$TOTAL_VAR" 'BEGIN{OFS="\t"}
#$1=="PSC" {
#nPresent = ($12 + $13)
#    perc = (nPresent/total*100)
#    print $0, perc
#}' > LFHF_global_perc_variants_AD_5.tsv #This file can be used to check if the samples removed are correct


#bcftools stats -s - LFHF_global_good_variants_AD_5.vcf.gz | \
#awk -v total="$TOTAL_VAR" 'BEGIN{OFS="\t"}
#$1=="PSC" {
#nPresent = ($12 + $13)
#    percPresent = (nPresent/total*100)
#    if(percPresent<90) print $3
#}' > LFHF_global_samples_to_remove_AD_5.txt

#bcftools view -S ^LFHF_global_samples_to_remove_AD_5.txt -Oz \
#        -o LFHF_global_bad_samples_removed_AD_5.vcf.gz LFHF_global_good_variants_AD_5.vcf.gz

#echo "Done filtering low variant-coverage samples"

#bcftools index LFHF_global_bad_samples_removed_AD_5.vcf.gz

#echo "Removing outgroup samples"

#bcftools query -f '[%SAMPLE\t%GT\n]' LFHF_global_bad_samples_removed_AD_5.vcf.gz | \
#awk -F '\t' '$2 ~ /1/ {count[$1]++} END {for (s in count) print s, count[s]}' | \
#sort > LFHF_global_variant_counts_AD_5.list

awk '$2 <= 50000 {print $1}' LFHF_global_variant_counts_AD_5.list > LFHF_global_no_outgroup_AD_5_50000.list
bcftools view -S LFHF_global_no_outgroup_AD_5_50000.list -Oz -o LFHF_global_clean_filtered_AD_5_50000.vcf.gz LFHF_global_bad_samples_removed_AD_5.vcf.gz
bcftools index -f LFHF_global_clean_filtered_AD_5_50000.vcf.gz


echo "Start filtering on AC"
TOTAL_SAMPLE=$(bcftools query -l LFHF_global_clean_filtered_AD_5_50000.vcf.gz | wc -l)
bcftools view -i "INFO/AC!=0 & INFO/AC<$TOTAL_SAMPLE" LFHF_global_clean_filtered_AD_5_50000.vcf.gz -Oz -o LFHF_global_final_AD_5_50000.vcf.gz
bcftools index -f LFHF_global_final_AD_5_50000.vcf.gz

echo "Ready to continue in R"
                                 

