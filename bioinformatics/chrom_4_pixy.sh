#!/bin/bash
bcftools query -l LFHF_global_final_AD_5.vcf.gz > LFHF_global_populations.txt ##This still needs to change to the <50,000 file to comply with the final combined.vcf.gz. 

##To add the population to the list
awk '
/BB_/ {print $0 "\tPopA"}
/HF_/ {print $0 "\tPopB"}
/SHELT|RHODES|HE_|ABDOL|BARBER|CELIA|ZHAO|ETIEN|KANG|SNEL|WINT|FISHER|GIBBO/ {print $0 "\tPopC"}
' LFHF_global_populations.txt > LFHF_global_populations_2.txt

pixy --stats pi --vcf LFHF_global_final_AD_5.vcf.gz --populations LFHF_global_populations_2.txt --bed_file chrom_4_groen_global.bed --output_folder pixy --output_prefix LFHF_global_chrom_4 --bypass_invariant_check

