#!/bin/bash

REFERENCE=/lustre/BIF/nobackup/brigg002/novogene2024/Af293_combined.fna

#for sample in /lustre/BIF/nobackup/brigg002/new_global_data/fisher_2026/ER*

#do
#echo $sample
#sample_name="FISHER_2026_$(basename $sample)"
#echo $sample_name

#echo '@RG\tID:'$sample_name'\tSM:'$sample_name'\tLB:new_global'
#done

#for sample in /lustre/BIF/nobackup/brigg002/new_global_data/fisher_2026/ER*
#do
#        sample_name="$(basename $sample)"
#        mkdir -p fastp_out/"$sample_name"

#        fastp -i "$sample"/*_1.fastq.gz -I "$sample"/*_2.fastq.gz -o fastp_out/"$sample_name"/"$sample_name"_1.fastq.gz -O fastp_out/"$sample_name"/"$sample_name"_2.fastq.gz -h -h fastp_out/"$sample_name"/"${sample_name}.html" -j -j fastp_out/"$sample_name"/"${sample_name}.json"
#done


#for sample in /lustre/BIF/nobackup/brigg002/new_global_data/fisher_2026/fastp_out/ER*
#do 
#       sample_name="FISHER_2026_$(basename $sample)" 
#       bwa-mem2 mem -t 8 -R '@RG\tID:'$sample_name'\tSM:'$sample_name'\tLB:new_global' $REFERENCE "$sample"/*_1.fastq.gz "$sample"/*_2.fastq.gz | samtools view -b | samtools fixmate -@ 6 -m - - | samtools sort -@ 8 -m 3G - | samtools markdup -@ 6 - /lustre/BIF/nobackup/brigg002/analysis_new_global_data/fisher_2026/$sample_name.sorted.bam
#done


#samtools faidx $REFERENCE
#gatk CreateSequenceDictionary -R $REFERENCE -O /lustre/BIF/nobackup/brigg002/novogene2024/Af293_combined.dict

#First, the BAM files will need to be indexed. This part is to call all the variants in the reads.
for sample in /lustre/BIF/nobackup/brigg002/new_global_data/fisher_2026/ERR15975869*
do sample_name="FISHER_2026_$(basename $sample)"
samtools index /lustre/BIF/nobackup/brigg002/analysis_new_global_data/fisher_2026/$sample_name.sorted.bam
gatk HaplotypeCaller -I $sample_name.sorted.bam -R $REFERENCE -O $sample_name.g.vcf.gz -ERC GVCF -ploidy 1
done
