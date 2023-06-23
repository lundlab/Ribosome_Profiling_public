## First, lets install it
conda install -c bioconda rsem 

### If this option is on, RSEM assumes that 'reference_fasta_file(s)' contains the sequence of a genome, and will extract transcript reference sequences using the gene annotations specified in <file>, which should be in GTF format.

# rsem-prepare-reference [options] reference_fasta_file(s) reference_name

rsem-prepare-reference --gtf HUGO_V97_Homo_sapiens.GRCh38.97_HUGO-filtered.gtf V97_GRCh38_Ensembl_Genome/Homo_sapiens.GRCh38.dna.primary_assembly.fa ensembl97hugo

##############

##### RSEM TXTOME TO GENOME
######## RNASEQ

## Usage: rsem-tbam2gbam reference_name unsorted_transcript_bam_input genome_bam_output [-p number_of_threads]

rsem-tbam2gbam ensembl97hugo $mfile /RSEM/TX-GENOME-BAM/$basefilename.bam -p 14
### SORT and INDEX THEM
samtools sort $mfile -o sorted_$basefilename.bam --threads 14
samtools index sorted_$basefilename.bam


## Merge the files
samtools merge -f merged_KO_total_toTranscriptome-ConvertedtoGenome.bam KO_total_1.bam KO_total_2.bam KO_total_3.bam

samtools merge -f merged_WT_total_toTranscriptome-ConvertedtoGenome.bam WT_total_1.bam WT_total_2.bam WT_total_3.bam

## Convert them to bigwigs
samtools index $mfile
bamCoverage -p 12 --binSize 1 -b $mfile -o /RSEM/TX-GENOME-BAM/BIGWIGS/$basefilename.bigWig

#######################
#######################
### RPF
## Extract reads with lengths of Xnt_Ynt

basefilename=$(sed 's/Aligned.toTranscriptome.out.bam//g' <<< $basefilename)
samtools view -h $mfile |  awk 'length($10) >= X && length($10) <= Y | $1 ~ /^@/' | samtools view -bS - > /TXTOME-Xnt_Ynt/Xnt_Ynt_$basefilename-Transcriptome.bam

##############################################
##### RSEM TXTOME TO GENOME
######## RPF

## Usage: rsem-tbam2gbam reference_name unsorted_transcript_bam_input genome_bam_output [-p number_of_threads]
cd /TXTOME-Xnt_Ynt
rsem-tbam2gbam ensembl97hugo $mfile $basefilename-toTranscriptome-ConvertedtoGenome.bam -p 14
samtools sort $mfile -o sorted_$basefilename.bam --threads 5
samtools index sorted_$basefilename.bam

samtools merge -f merged_Xnt_Ynt_KO_RP_toTranscriptome-ConvertedtoGenome.bam KO_RP_1.bam KO_RP_2.bam KO_RP_3.bam
samtools merge -f merged_Xnt_Ynt_WT_RP_toTranscriptome-ConvertedtoGenome.bam WT_RP_1.bam WT_RP_2.bam WT_RP_3.bam

## Convert them to bigwigs
## TURN THEM TO BIGWIGS 
samtools index $mfile
bamCoverage -p 12 --binSize 1 -b $mfile -o BIGWIGS/$basefilename.bigWig