#!/bin/bash

echo "Step-1 : Create a genome index with HUGO filtered V97 Ensembl GTF and V97 Ensembl FASTA"
################# ENSEMBL V97 STAR INDEX PREPARATION #################
STAR-2.5.1a --runMode genomeGenerate --runThreadN 14 --genomeDir V97_HUGO_hg38_genome_index/ --genomeFastaFiles V97_GRCh38_Ensembl_Genome/Homo_sapiens.GRCh38.dna.primary_assembly.fa --outFileNamePrefix hg38  --sjdbGTFfile V97_GRCh38_Ensembl_Genome/HUGO/HUGO_V97_Homo_sapiens.GRCh38.97_HUGO-filtered.gtf

nice STAR-2.5.1a --runMode alignReads --runThreadN 14 --outFilterMultimapNmax 50 --outFilterMismatchNoverLmax 0.075 --outFilterScoreMinOverLread 0 --outFilterMatchNminOverLread 0.95 --outSAMheaderCommentFile COfile.txt --outSAMattributes All --outSAMheaderHD @HD VN:1.4 SO:coordinate --genomeLoad NoSharedMemory --outSAMunmapped None  --outSAMtype BAM SortedByCoordinate --quantMode TranscriptomeSAM  --limitBAMsortRAM 60000000000 --chimSegmentMin 1 --chimOutType SeparateSAMold --twopassMode Basic outWigType wiggle --genomeDir V97_HUGO_hg38_genome_index/ --readFilesIn "$filename" --readFilesCommand zcat --outFileNamePrefix "$prefix" --outReadsUnmapped Fastx 
