#!/bin/bash
bcftools query -l LFHF_global_final_AD_5_50000.vcf.gz > LFHF_global_populations_v02.txt

##To add the population to the list
awk '
/BB_/ {print $0 "\tPopA"}
/HF_/ {print $0 "\tPopB"}
/SHELT|RHODES|HE_|ABDOL|BARBER|CELIA|ZHAO|ETIEN|KANG|SNEL|WINT|FISHER|GIBBO/ {print $0 "\tPopC"}
' LFHF_global_populations_v02.txt > LFHF_global_populations_2.txt

pixy --stats pi --vcf LFHF_global_final_AD_5_50000.vcf.gz --populations LFHF_global_populations_2.txt --bed_file /lustre/BIF/nobackup/brigg002/analysis_groenafval/chromosomes.bed --output_folder pixy --output_prefix LFHF_global --bypass_invariant_check

awk '
{3
    diffs[$1] += $7
    comps[$1] += $8
}
END{
    print "PopA", diffs["PopA"]/comps["PopA"]
    print "PopB", diffs["PopB"]/comps["PopB"]
    print "PopC", diffs["PopC"]/comps["PopC"]
}' ./pixy/LFHF_global_pi.txt > ./pixy/LFHF_global_pi_average_v02.txt
