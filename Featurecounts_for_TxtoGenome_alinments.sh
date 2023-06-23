##################### FEATURECOUNTS FOR THE TX-TO-GENOME COORDINATES

### RNA SEQ ###
# Exon
featureCounts -R -T 14 -t exon -g transcript_id -O -M -Q 0 --largestOverlap -a filtered_CCDS_APPRIS_TSL_LENGTH_Homo_sapiens.GrcH38.V97.gtf -o NOPRIMARY_EXON_COUNTS_RNASEQ_TX_LEVEL_rsemconverted.txt sorted*bam 2> /log_NOPRIMARY_EXON_COUNTS_RNASEQ_TX_LEVEL_rsemconverted.log

## 3UTR and 5UTR FOR RNASEQ
## 3utr
featureCounts -R -T 16 -t three_prime_utr -g transcript_id -O -M -Q 0 --largestOverlap --fracOverlap 0.72 -a filtered_CCDS_APPRIS_TSL_LENGTH_Homo_sapiens.GrcH38.V97.gtf -o NOPRIMARY_3UTR_COUNTS_RNASEQ_TX_LEVEL_rsemconverted.txt sorted*bam 2> log_NOPRIMARY_3UTR_COUNTS_RNASEQ_TX_LEVEL_rsemconverted.log

## 5utr
featureCounts -R -T 16 -t five_prime_utr -g transcript_id -O -M -Q 0 --largestOverlap --fracOverlap 0.53 -a filtered_CCDS_APPRIS_TSL_LENGTH_Homo_sapiens.GrcH38.V97.gtf -o NOPRIMARY_5UTR_COUNTS_RNASEQ_TX_LEVEL_rsemconverted.txt sorted*bam 2> log_NOPRIMARY_5UTR_COUNTS_RNASEQ_TX_LEVEL_rsemconverted.log

#############################
## RPF
# Exon
featureCounts -R -T 14 -t exon -g transcript_id -O -M -Q 0 --largestOverlap -a filtered_CCDS_APPRIS_TSL_LENGTH_Homo_sapiens.GrcH38.V97.gtf -o NOPRIMARY_EXON_COUNTS_RPF_TX_LEVEL_rsemconverted.txt sorted_Xnt_Ynt_*bam 2> log_NOPRIMARY_EXON_COUNTS_RPF_TX_LEVEL_rsemconverted.log

# Primary 3UTR
featureCounts -R -T 14 -t three_prime_utr -g transcript_id -O -M -Q 0 --largestOverlap --fracOverlap 0.72 -a filtered_CCDS_APPRIS_TSL_LENGTH_Homo_sapiens.GrcH38.V97.gtf -o NOPRIMARY_3UTR_COUNTS_RPF_TX_LEVEL_rsemconverted.txt sorted_Xnt_Ynt_*bam 2> log_NOPRIMARY_3UTR_COUNTS_RPF_TX_LEVEL_rsemconverted.log

# Primary 5UTR
featureCounts -R -T 14 -t five_prime_utr -g transcript_id -O -M -Q 0 --largestOverlap --fracOverlap 0.53 -a filtered_CCDS_APPRIS_TSL_LENGTH_Homo_sapiens.GrcH38.V97.gtf -o NOPRIMARY_5UTR_COUNTS_RPF_TX_LEVEL_rsemconverted.txt sorted_Xnt_Ynt_*bam 2> log_NOPRIMARY_5UTR_COUNTS_RPF_TX_LEVEL_rsemconverted.log