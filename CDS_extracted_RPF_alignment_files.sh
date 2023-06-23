#!/bin/bash

echo "This step will give exon counted bam files for RPF"
grep 'Assigned' EXON_MAPPED_$basefilename.bam.featureCounts | cut -f1 | sort | uniq > exon_mapped_$basefilename.bam.featureCounts
python exctract_reads.py -b $mfile -n exon_mapped_$basefilename.bam.featureCounts -o exon_counted_$basefilename.bam


echo "Now I extract 3UTR and 5UTR, merge them, and get the reads which exists in exon assigned ones but not in UTRs"
grep 'Assigned' FEATURECOUNTS/3UTR/$basefilename.bam.featureCounts | cut -f1 | sort | uniq > FEATURECOUNTS/3UTR/3utr_mapped_Xnt-Ynt_$basefilename.bam.featureCounts
grep 'Assigned' FEATURECOUNTS/5UTR/$basefilename.bam.featureCounts | cut -f1 | sort | uniq > FEATURECOUNTS/5UTR/5utr_mapped_Xnt-Ynt_$basefilename.bam.featureCounts
echo "merge 3UTR and 5UTR"
cat FEATURECOUNTS/3UTR/3utr_mapped_Xnt-Ynt_$basefilename.bam.featureCounts FEATURECOUNTS/5UTR/5utr_mapped_Xnt-Ynt_$basefilename.bam.featureCounts | sort | uniq > FEATURECOUNTS/MERGED-UTRS/merged_mapped_Xnt-Ynt_$basefilename.bam.featureCounts
echo "SUBSTRACT EXONS FROM MERGED UTRs"
comm -23 exon_mapped_$basefilename.bam.featureCounts FEATURECOUNTS/MERGED-UTRS/merged_mapped_Xnt-Ynt_$basefilename.bam.featureCounts | sort | uniq > FEATURECOUNTS/CDS/EXON-UTRS_mapped_Xnt-Ynt_$basefilename.bam.featureCounts
echo "This step will create cds (exon-uts) counted bam files for RPF"
python exctract_reads.py -b $mfile -n FEATURECOUNTS/CDS/EXON-UTRS_mapped_Xnt-Ynt_$basefilename.bam.featureCounts -o COUNTED/CDS/exon-utrs_counted_$basefilename.bam