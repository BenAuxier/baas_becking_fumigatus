#!/bin/bash
##Similar to pixy.sh only the annotation of the populations is different, as we now look at the subpopulations (=sampling sites within the heaps) in the HF and LF populations.

#bcftools query -l groenafval_clean_filtered_123_AD_5.vcf.gz > LF_populations.txt

##To add the population to the list
#awk '
#/28A/ {print $0 "\tA"}
#/28B/ {print $0 "\tB"}
#/28C/ {print $0 "\tC"}
#/28D/ {print $0 "\tD"}
#/28E/ {print $0 "\tE"}
#' LF_populations.txt > LF_populations_2.txt

#pixy --stats pi --vcf groenafval_clean_filtered_123_AD_5.vcf.gz --populations LF_populations_2.txt --bed_file chromosomes.bed --output_folder pixy --output_prefix LF --bypass_invariant_check

#awk '
#{
#    diffs[$1] += $7
#    comps[$1] += $8
#}
#END{
#    print "A", diffs["A"]/comps["A"]
#    print "B", diffs["B"]/comps["B"]
#    print "C", diffs["C"]/comps["C"]
#    print "D", diffs["D"]/comps["D"]
#    print "E", diffs["E"]/comps["E"]
#}' ./pixy/LF_pi.txt > ./pixy/LF_pi_average.txt

###There are quite some high values for pixy, Ben suspects this might be due to outliers. Recently, in the global dataset, we've removed >50,000 variant samples compared to the >100,000 threshold that we had before. Let's see if this alters the values drastically or not. 

bcftools query -l /lustre/BIF/nobackup/brigg002/analysis_new_global_data/LFHF_global_final_AD_5_50000.vcf.gz > LFHF_global_populations.txt

awk '
/28A/ {print $0 "\tA"}
/28B/ {print $0 "\tB"}
/28C/ {print $0 "\tC"}
/28D/ {print $0 "\tD"}
/28E/ {print $0 "\tE"}
/G1/ {print $0 "\tG1"} 
/G2/ {print $0 "\tG2"}
/G3/ {print $0 "\tG3"}
/G4/ {print $0 "\tG4"} 
/G8/ {print $0 "\tG8"} 

' LFHF_global_populations.txt > HFLF_sub_populations.txt

pixy --stats pi --vcf /lustre/BIF/nobackup/brigg002/analysis_new_global_data/LFHF_global_final_AD_5_50000.vcf.gz --populations HFLF_sub_populations.txt --bed_file chromosomes.bed --output_folder pixy --output_prefix HFLF_sub --bypass_invariant_check

awk '
{
    diffs[$1] += $7
    comps[$1] += $8
}
END{
    print "A", diffs["A"]/comps["A"]
    print "B", diffs["B"]/comps["B"]
    print "C", diffs["C"]/comps["C"]
    print "D", diffs["D"]/comps["D"]
    print "E", diffs["E"]/comps["E"]
    print "G1", diffs["G1"]/comps["G1"]
    print "G2", diffs["G2"]/comps["G2"]
    print "G3", diffs["G3"]/comps["G3"]
    print "G4", diffs["G4"]/comps["G4"]
    print "G8", diffs["G8"]/comps["G8"]
}' ./pixy/HFLF_sub_pi.txt > ./pixy/HFLF_sub_pi_average.txt


