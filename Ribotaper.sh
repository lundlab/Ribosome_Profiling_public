# Gencode: GRCh38.p12, release 31 referring to the ENSEMBL V97
echo "Save the gencode files"
# I will use PRI --> primary assembly (this includes scaffolds, but not haplotypes and assembly patches) genome file
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_31/GRCh38.primary_assembly.genome.fa.gz
gunzip GRCh38.primary_assembly.genome.fa.gz
# I will use basic gene annotation
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_31/gencode.v31.primary_assembly.annotation.gtf.gz
gunzip gencode.v31.primary_assembly.annotation.gtf.gz 


# then index the genome file
samtools faidx GRCh38.primary_assembly.genome.fa
# create annotation file
create_annotations_files.bash gencode.v31.primary_assembly.annotation.gtf GRCh38.primary_assembly.genome.fa true true "$ribotaper_output_dir"
## I will use RPF files in here.
# Usage: Usage: create_metaplots.bash <ribo.bam> <bedfile> <name>
## conda install "samtools>=1.10"
create_metaplots.bash $mfile "$ribotaper_output_dir"/start_stops_FAR.bed $basefilename