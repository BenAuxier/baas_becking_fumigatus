bcftools query -l LFHF_global_final_AD_5_50000.vcf.gz > all_samples.txt

echo "sample,average_depth" > average_depth.csv

while read sample; do
    avg=$(bcftools query -s "$sample" -f '[%DP\n]' LFHF_global_final_AD_5_50000.vcf.gz | \
        awk '$1!="." {sum+=$1; n++} END {if(n>0) printf "%.2f", sum/n; else print "NA"}')

    echo "$sample,$avg" >> average_depth.csv
done < all_samples.txt
