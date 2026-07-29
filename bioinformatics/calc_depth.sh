#Makes a list of all the files
bcftools query -l LFHF_global_final_AD_5_50000.vcf.gz > all_samples.txt

#Start to make the csv file, the calculations of population averages can be performed in R or Excel. 
echo "sample,average_depth" > average_depth.csv

#Calculates the average coverage based on the DP values in the combined.vcf.gz
while read sample; do
    avg=$(bcftools query -s "$sample" -f '[%DP\n]' LFHF_global_final_AD_5_50000.vcf.gz | \
        awk '$1!="." {sum+=$1; n++} END {if(n>0) printf "%.2f", sum/n; else print "NA"}')

    echo "$sample,$avg" >> average_depth.csv
done < all_samples.txt
