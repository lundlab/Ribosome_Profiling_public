echo "Step 1 : Make a quality control of the raw sequencing files"

Raw_RNA_seq_PATH=""
Raw_RPF_seq_PATH=""

## RNA FASTQC ##
fastqc -o /RNASEQ/FASTQC/Q1 --noextract -f fastq ${mfile}; done

## RPF FASTQC ##
fastqc -o /RPF/FASTQC/Q1 --noextract -f fastq ${mfile}; done


######### CUTADAPT #############
RNA_CUTADAPT_PATH_H9="/RNASEQ/CUTADAPT"
RPF_CUTADAPT_PATH_H9="/RPF/CUTADAPT"


echo "Step 2 : Cut the adapters from raw reads"
## conda install cutadapt for multicore analysis 
## This is cutadapt 2.1 with Python 3.7.1

## The new Truseq adapter is made with TruSeqSingleIndexes in https://support.illumina.com/content/dam/illumina-support/documents/documentation/chemistry_documentation/experiment-design/illumina-adapter-sequences-1000000002694-11.pdf AND https://support.illumina.com/sequencing/sequencing_kits/truseq-ribo-profile-mammalian.html.

## RNA SEQ
filelist="Raw_RNA-seq/*R1_001.fastq.gz"
cutadapt -a file:NEW_Illumina_TruSeq_Adapter_27index.fa --cores=8 -q 30,30 --minimum-length 20 --discard-untrimmed --trim-n -o "$RNA_CUTADAPT_PATH_H9"/"$basefilename_RNA_SEQ"_cutadapt.fastq.gz ${mfile}

# RPF
filelist="Raw_RPF/*R1_001.fastq.gz"
cutadapt -a file:NEW_Illumina_TruSeq_Adapter_27index.fa --cores=8 -q 30,30 --minimum-length 20 --discard-untrimmed --trim-n -o "$RPF_CUTADAPT_PATH_H9"/"$basefilename_RPF"_cutadapt.fastq.gz ${mfile};
