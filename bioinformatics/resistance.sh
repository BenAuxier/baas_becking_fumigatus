##In this script we will work on finding known resistant mutations within this dataset 

#!/bin/bash
export PATH="/usr/bin"
#extract knrown fungicide mutations based on sample names
bcftools query -l groenafval_clean_filtered_123_AD_5.vcf.gz | tr "\n" "\t" > LF_antifungal_mutations.tsv
echo "" >> LF_antifungal_mutations.tsv
#cytBG213A
echo -e "cytB_G143A\t$(bcftools view groenafval_clean_filtered_123_AD_5.vcf.gz JQ346808.1:428-428 | bcftools query -f '[%TGT\t]\n')" >> LF_antifungal_mutations.tsv
#sdhB H270Y is C->T
echo -e "sdhB_H270Y\t$(bcftools view groenafval_clean_filtered_123_AD_5.vcf.gz NC_007198.1:2654913-2654913 | bcftools query -f '[%TGT\t]\n')" >> LF_antifungal_mutations.tsv
#benA F219Y
echo -e "benA_F219Y\t$(bcftools view groenafval_clean_filtered_123_AD_5.vcf.gz NC_007194.1:2849059-2849059 | bcftools query -f '[%TGT\t]\n')" >> LF_antifungal_mutations.tsv
#cyp51A TR34
echo -e "TR34\t$(bcftools view groenafval_clean_filtered_123_AD_5.vcf.gz NC_007197.1:1782107-1782107 | bcftools query -f '[%TGT\t]\n')" >> LF_antifungal_mutations.tsv
#cyp51A TR46
echo -e "TR46\t$(bcftools view groenafval_clean_filtered_123_AD_5.vcf.gz NC_007197.1:1782102-1782102 | bcftools query -f '[%TGT\t]\n')" >> LF_antifungal_mutations.tsv
#msh6 G240A
echo -e "msh6_G240A\t$(bcftools view groenafval_clean_filtered_123_AD_5.vcf.gz NC_007197.1:2148956-2148956 | bcftools query -f '[%TGT\t]\n')" >> LF_antifungal_mutations.tsv
