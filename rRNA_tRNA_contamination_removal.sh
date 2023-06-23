### CLEAN THE CONTAMINANTS ###
echo "Make an rRNA index with bowtie2"
#gunzip -c arb-silva.de_2019-06-24_id671191.tgz | tar xvf -
#gunzip -c arb-silva.de_2019-06-24_id671193.tgz | tar xvf -
#cat arb-silva.de_2019-06-24_id671191_tax_silva.fasta arb-silva.de_2019-06-24_id671193_tax_silva.fasta >> LSU_SSU_rRNA_human.fasta
#sed '/^[^>]/ y/uU/tT/' LSU_SSU_rRNA_human.fasta > dna_LSU_SSU_rRNA_human.fasta

bowtie2-build --threads 6 dna_LSU_SSU_rRNA_human.fasta rRNA_Homo_sapiens

echo "Make a tRNA index with bowtie2"

#wget -c http://gtrnadb.ucsc.edu/GtRNAdb2/genomes/eukaryota/Hsapi38/hg38-tRNAs.fa
cd BOWTIE_INDEX/tRNA_Homo_sapiens
bowtie2-build --threads 6 hg38-tRNAs.fa tRNA_Homo_sapiens

echo " Step 5: Clean the contaminants from the datasets"
## INDEX PATHS ##
tRNA_bowtie_index="BOWTIE_INDEX/tRNA_Homo_sapiens/tRNA_Homo_sapiens"
rRNA_bowtie_index="BOWTIE_INDEX/rRNA_Homo_sapiens/rRNA_Homo_sapiens"

## BOWTIE RESULT PATHS : RNA SEQ ## 
tRNA_bowtie_result="RNASEQ/BOWTIE2/tRNA"
rRNA_bowtie_result="RNASEQ/BOWTIE2/rRNA"

## BOWTIE RESULT PATHS : RPF ## 
tRNA_bowtie_result_RPF="RPF/BOWTIE2/tRNA"
rRNA_bowtie_result_RPF="RPF/BOWTIE2/rRNA"

## RNASEQ
filelist="RNASEQ/CUTADAPT/*_cutadapt.fastq.gz"

echo "tRNA alignment starts"
bowtie2 --local -D 20 -R 3 -N 1 -L 20 -i S,1,0.75 --threads 6 --un-gz $tRNA_bowtie_result/tRNA_unaligned_"$basefilename_RNA_SEQ".fastq.gz -x $t
RNA_bowtie_index -U ${mfile} -S $tRNA_bowtie_result/tRNA_aligned_"$basefilename_RNA_SEQ".sam 2>> $tRNA_bowtie_result/stats_tRNA_"$basefilename_
RNA_SEQ".txt

echo "rRNA alignment starts"
bowtie2 --local -D 20 -R 3 -N 1 -L 20 -i S,1,0.75  --threads 6 --un-gz $rRNA_bowtie_result/rRNA_tRNA_unaligned_"$basefilename_RNA_SEQ".fastq.gz
 -x $rRNA_bowtie_index -U $tRNA_bowtie_result/tRNA_unaligned_"$basefilename_RNA_SEQ".fastq.gz -S $rRNA_bowtie_result/rRNA_aligned_"$basefilenam
e_RNA_SEQ".sam 2>> $rRNA_bowtie_result/stats_rRNA_"$basefilename_RNA_SEQ".txt

echo "Changing name to clean : not having rRNA and tRNA"
mv $rRNA_bowtie_result/rRNA_tRNA_unaligned_"$basefilename_RNA_SEQ".fastq.gz $rRNA_bowtie_result/cleaned_"$basefilename_RNA_SEQ".fastq.gz


## RPF
filelist="RPF/CUTADAPT/*_cutadapt.fastq.gz"

echo "tRNA alignment starts"
bowtie2 --local -D 20 -R 3 -N 1 -L 20 -i S,1,0.75 --threads 6 --un-gz $tRNA_bowtie_result_RPF/tRNA_unaligned_"$basefilename_RPF".fastq.gz -x $t
RNA_bowtie_index -U ${mfile} -S $tRNA_bowtie_result_RPF/tRNA_aligned_"$basefilename_RPF".sam 2>> $tRNA_bowtie_result_RPF/stats_tRNA_"$basefilename_RPF".txt

echo "rRNA alignment starts"
bowtie2 --local -D 20 -R 3 -N 1 -L 20 -i S,1,0.75  --threads 6 --un-gz $rRNA_bowtie_result_RPF/rRNA_tRNA_unaligned_"$basefilename_RPF".fastq.gz
 -x $rRNA_bowtie_index -U $tRNA_bowtie_result_RPF/tRNA_unaligned_"$basefilename_RPF".fastq.gz -S $rRNA_bowtie_result_RPF/rRNA_aligned_"$basefilename_RPF".sam 2>> $rRNA_bowtie_result_RPF/stats_rRNA_"$basefilename_RPF".txt

echo "Changing name to clean : not having rRNA and tRNA"
mv $rRNA_bowtie_result_RPF/rRNA_tRNA_unaligned_"$basefilename_RPF".fastq.gz $rRNA_bowtie_result_RPF/cleaned_"$basefilename_RPF".fastq.gz