#! usr/bin/bash

#convert RIVET excel sheets to csv
xlsx2csv RIVET_TL_alone_Padj0.05_DN.xlsx RIVET_TL_alone_Padj0.05_DN.csv
xlsx2csv RIVET_TL_alone_Padj0.05_UP.xlsx RIVET_TL_alone_Padj0.05_UP.csv

## extract the TX IDs
awk -F',' {'print $1'} RIVET_TL_alone_Padj0.05_DN.csv | tail -n +2 > RIVET_TL_DOWN_List.txt
awk -F',' {'print $1'} RIVET_TL_alone_Padj0.05_UP.csv | tail -n +2 > RIVET_TL_UP_List.txt

cut -f1 mergedTable-H9_EXON-CDS-sub3UTR-sub5utr_NOPRIMARY_Q0.txt | tail -n +2 > RIVET_TL_ALL_List.txt


## merge the UP AND DOWN AND EXTRACT IT FROM ALL
cat RIVET_TL_UP_List.txt RIVET_TL_DOWN_List.txt | sort | uniq > merged_RIVET_TL_upanddown.txt
comm --check-order RIVET_TL_ALL_List.txt merged_RIVET_TL_upanddown.txt ## all good
comm -23 RIVET_TL_ALL_List.txt merged_RIVET_TL_upanddown.txt | sort | uniq > RIVET_TL_NS_List.txt


## PREPARE GTF FILES
## UP
cat RIVET_TL_UP_List.txt | while read LINE; do echo $LINE; cat filtered_CCDS_APPRIS_TSL_LENGTH_Homo_sapiens.GrcH38.V97.gtf | grep -wi $LINE >> GTFs/TL_UP.gtf;  done

cat GTFs/TL_UP.gtf | awk 'BEGIN{FS="\t"}{split($9,a,";"); if($3~"transcript") print a[3]"\t"a[3]"."a[4]"\t"a[1]}' | sed 's/transcript_id "//g'  | sed 's/transcript_version "//' | sed 's/gene_id "//' | sed 's/"//g'  | sed 's/\. /./' | sed 's/^ //' > GTFs/UP_GTF_TXLIST.txt

## DOWN
cat RIVET_TL_DOWN_List.txt | while read LINE; do echo $LINE; cat filtered_CCDS_APPRIS_TSL_LENGTH_Homo_sapiens.GrcH38.V97.gtf | grep -wi $LINE >> GTFs/TL_DOWN.gtf;  done

cat GTFs/TL_DOWN.gtf | awk 'BEGIN{FS="\t"}{split($9,a,";"); if($3~"transcript") print a[3]"\t"a[3]"."a[4]"\t"a[1]}' | sed 's/transcript_id "//g'  | sed 's/transcript_version "//' | sed 's/gene_id "//' | sed 's/"//g'  | sed 's/\. /./' | sed 's/^ //' > GTFs/DOWN_GTF_TXLIST.txt

## ALL
cat RIVET_TL_ALL_List.txt | while read LINE; do echo $LINE; cat filtered_CCDS_APPRIS_TSL_LENGTH_Homo_sapiens.GrcH38.V97.gtf | grep -wi $LINE >> GTFs/TL_ALL.gtf;  done
 
 
## NS :
cat RIVET_TL_NS_List.txt | while read LINE; do echo $LINE; cat filtered_CCDS_APPRIS_TSL_LENGTH_Homo_sapiens.GrcH38.V97.gtf | grep -wi $LINE >> GTFs/TL_NS.gtf;  done

####### LETS PLOT WITH DEEPTOOLS !!!
############# RPF ############

#Lets update deeeptools:
conda install -c bioconda deeptools 
'''
## check the version
computeMatrix --version
computeMatrix 3.5.0
'''

######### TSS #############
CPM_13_KO="mean_offset_13_CPM_KO.bigWig"
CPM_13_WT="mean_offset_13_CPM_WT.bigWig"
REGULAR_13_KO="mean_offset_13_REGULAR_KO.bigWig"
REGULAR_13_WT="mean_offset_13_REGULAR_WT.bigWig"

echo "For 1) UP REGULAR START :KO vs WT"

computeMatrix reference-point -S $REGULAR_13_KO $REGULAR_13_WT -R COUNTMATRIX/TSS/StartCodon_CDS_strand_UP.bed -o REGULAR_MEAN_UP_offset-13-TSS-30U300D.gz --upstream 30 --downstream 300  --binSize 1 --referencePoint TSS --smartLabels --numberOfProcessors 10 --verbose

plotProfile --matrixFile REGULAR_MEAN_UP_offset-13-TSS-30U300D.gz --outFileName REGULAR_MEAN_UP_offset-13-TSS-30U300D.pdf --plotType lines --colors orange green --plotTitle "UP-Regular-TSS"  --perGroup --legendLocation best  --plotFileFormat pdf  --verbose

echo "For 2) UP CPM START :KO vs WT"

computeMatrix reference-point -S $CPM_13_KO $CPM_13_WT -R COUNTMATRIX/TSS/StartCodon_CDS_strand_UP.bed -o CPM_MEAN_UP_offset-13-TSS-30U300D.gz --upstream 30 --downstream 300  --binSize 1 --referencePoint TSS --smartLabels --numberOfProcessors 10 --verbose

plotProfile --matrixFile CPM_MEAN_UP_offset-13-TSS-30U300D.gz --outFileName CPM_MEAN_UP_offset-13-TSS-30U300D.pdf --plotType lines --colors orange green --plotTitle "UP-CPM-TSS"  --perGroup --legendLocation best  --plotFileFormat pdf  --verbose

echo "For 3) DOWN REGULAR START :KO vs WT"

computeMatrix reference-point -S $REGULAR_13_KO $REGULAR_13_WT -R COUNTMATRIX/TSS/StartCodon_CDS_strand_DOWN.bed  -o REGULAR_MEAN_DOWN_offset-13-TSS-30U300D.gz --upstream 30 --downstream 300  --binSize 1 --referencePoint TSS  --smartLabels --numberOfProcessors 10 --verbose

plotProfile --matrixFile REGULAR_MEAN_DOWN_offset-13-TSS-30U300D.gz --outFileName REGULAR_MEAN_DOWN_offset-13-TSS-30U300D.pdf --plotType lines --colors orange green --plotTitle "DOWN-Regular-TSS"  --perGroup --legendLocation best  --plotFileFormat pdf  --verbose

echo "For 4) DOWN CPM START :KO vs WT"

computeMatrix reference-point -S $CPM_13_KO $CPM_13_WT -R COUNTMATRIX/TSS/StartCodon_CDS_strand_DOWN.bed -o CPM_MEAN_DOWN_offset-13-TSS-30U300D.gz --upstream 30 --downstream 300  --binSize 1 --referencePoint TSS  --smartLabels --numberOfProcessors 10 --verbose

plotProfile --matrixFile CPM_MEAN_DOWN_offset-13-TSS-30U300D.gz --outFileName CPM_MEAN_DOWN_offset-13-TSS-30U300D.pdf --plotType lines --colors orange green --plotTitle "DOWN-CPM-TSS"  --perGroup --legendLocation best  --plotFileFormat pdf  --verbose

echo "For 5) NS Regular START :KO vs WT"

computeMatrix reference-point -S $REGULAR_13_KO $REGULAR_13_WT -R COUNTMATRIX/TSS/StartCodon_CDS_strand_NS.bed -o REGULAR_MEAN_NS_offset-13-TSS-30U300D.gz --upstream 30 --downstream 300 --binSize 1 --referencePoint TSS --smartLabels --numberOfProcessors 10 --verbose

plotProfile --matrixFile REGULAR_MEAN_NS_offset-13-TSS-30U300D.gz --outFileName REGULAR_MEAN_NS_offset-13-TSS-30U300D.pdf --plotType lines --colors orange green --plotTitle "NS-Regular-TSS"  --perGroup --legendLocation best  --plotFileFormat pdf  --verbose

echo "For 6) NS CPM START :KO vs WT"

computeMatrix reference-point -S $CPM_13_KO $CPM_13_WT -R COUNTMATRIX/TSS/StartCodon_CDS_strand_NS.bed -o CPM_MEAN_NS_offset-13-TSS-30U300D.gz --upstream 30 --downstream 300  --binSize 1 --referencePoint TSS --smartLabels --numberOfProcessors 10 --verbose

plotProfile --matrixFile CPM_MEAN_NS_offset-13-TSS-30U300D.gz --outFileName CPM_MEAN_NS_offset-13-TSS-30U300D.pdf --plotType lines --colors orange green --plotTitle "NS-CPM-TSS"  --perGroup --legendLocation best  --plotFileFormat pdf  --verbose

echo "For 7) ALL Regular START :KO vs WT"
cd COUNTMATRIX/MATRICES_RPF/ALL

computeMatrix reference-point -S $REGULAR_13_KO $REGULAR_13_WT -R COUNTMATRIX/TSS/StartCodon_CDS_strand_ALL.bed -o REGULAR_MEAN_ALL_offset-13-TSS-30U300D.gz --upstream 30 --downstream 300 --binSize 1 --referencePoint TSS --smartLabels --numberOfProcessors 10 --verbose

plotProfile --matrixFile REGULAR_MEAN_ALL_offset-13-TSS-30U300D.gz --outFileName REGULAR_MEAN_ALL_offset-13-TSS-30U300D.pdf --plotType lines --colors orange green --plotTitle "ALL-Regular-TSS"  --perGroup --legendLocation best  --plotFileFormat pdf  --verbose

echo "For 8) ALL CPM START :KO vs WT"

computeMatrix reference-point -S $CPM_13_KO $CPM_13_WT -R COUNTMATRIX/TSS/StartCodon_CDS_strand_ALL.bed -o CPM_MEAN_ALL_offset-13-TSS-30U300D.gz --upstream 30 --downstream 300  --binSize 1 --referencePoint TSS --smartLabels --numberOfProcessors 10 --verbose

plotProfile --matrixFile CPM_MEAN_ALL_offset-13-TSS-30U300D.gz --outFileName CPM_MEAN_ALL_offset-13-TSS-30U300D.pdf --plotType lines --colors orange green --plotTitle "ALL-CPM-TSS"  --perGroup --legendLocation best  --plotFileFormat pdf  --verbose


##############################################################
##############################################################
############ TSS IS DONE. LETS DO THE TES!!
echo "For 1) UP REGULAR STOP:KO vs WT"

computeMatrix reference-point -S $REGULAR_13_KO $REGULAR_13_WT -R COUNTMATRIX/TES/StopCodon_CDS_strand_UP.bed -o REGULAR_MEAN_UP_offset-13-TES-300U30D.gz --upstream 300 --downstream 30  --binSize 1 --referencePoint TSS  --smartLabels --numberOfProcessors 10 --verbose

plotProfile --matrixFile REGULAR_MEAN_UP_offset-13-TES-300U30D.gz --outFileName REGULAR_MEAN_UP_offset-13-TES-300U30D.pdf --plotType lines --colors black green --plotTitle "UP-Regular-TES" --perGroup --legendLocation best  --plotFileFormat pdf  --verbose

echo "For 2) UP CPM STOP:KO vs WT"

computeMatrix reference-point -S $CPM_13_KO $CPM_13_WT -R COUNTMATRIX/TES/StopCodon_CDS_strand_UP.bed -o CPM_MEAN_UP_offset-13-TES-300U30D.gz --upstream 300 --downstream 30  --binSize 1 --referencePoint TSS  --smartLabels --numberOfProcessors 10 --verbose

plotProfile --matrixFile CPM_MEAN_UP_offset-13-TES-300U30D.gz --outFileName CPM_MEAN_UP_offset-13-TES-300U30D.pdf --plotType lines --colors black green --plotTitle "UP-CPM-TES" --perGroup --legendLocation best  --plotFileFormat pdf  --verbose


echo "For 3) DOWN REGULAR STOP:KO vs WT"

computeMatrix reference-point -S $REGULAR_13_KO $REGULAR_13_WT -R COUNTMATRIX/TES/StopCodon_CDS_strand_DOWN.bed -o REGULAR_MEAN_DOWN_offset-13-TES-300U30D.gz --upstream 300 --downstream 30 --binSize 1 --referencePoint TSS  --smartLabels --numberOfProcessors 10 --verbose

plotProfile --matrixFile REGULAR_MEAN_DOWN_offset-13-TES-300U30D.gz --outFileName REGULAR_MEAN_DOWN_offset-13-TES-300U30D.pdf --plotType lines --colors black green --plotTitle "DOWN-Regular-TES" --perGroup --legendLocation best  --plotFileFormat pdf  --verbose

echo "For 4) DOWN CPM STOP:KO vs WT"

computeMatrix reference-point -S $CPM_13_KO $CPM_13_WT -R COUNTMATRIX/TES/StopCodon_CDS_strand_DOWN.bed -o CPM_MEAN_DOWN_offset-13-TES-300U30D.gz --upstream 300 --downstream 30 --binSize 1 --referencePoint TSS  --smartLabels --numberOfProcessors 10 --verbose

plotProfile --matrixFile CPM_MEAN_DOWN_offset-13-TES-300U30D.gz --outFileName CPM_MEAN_DOWN_offset-13-TES-300U30D.pdf --plotType lines --colors black green --plotTitle "DOWN-CPM-TES" --perGroup --legendLocation best  --plotFileFormat pdf  --verbose

echo "For 5) NS REGULAR STOP:KO vs WT"

computeMatrix reference-point -S $REGULAR_13_KO $REGULAR_13_WT -R COUNTMATRIX/TES/StopCodon_CDS_strand_NS.bed -o REGULAR_MEAN_NS_offset-13-TES-300U30D.gz --upstream 300 --downstream 30 --binSize 1 --referencePoint TSS  --smartLabels --numberOfProcessors 10 --verbose

plotProfile --matrixFile REGULAR_MEAN_NS_offset-13-TES-300U30D.gz --outFileName REGULAR_MEAN_NS_offset-13-TES-300U30D.pdf --plotType lines --colors black green --plotTitle "NS-Regular-TES" --perGroup --legendLocation best  --plotFileFormat pdf  --verbose

echo "For 6) NS CPM STOP:KO vs WT"

computeMatrix reference-point -S $CPM_13_KO $CPM_13_WT -R COUNTMATRIX/TES/StopCodon_CDS_strand_NS.bed -o CPM_MEAN_NS_offset-13-TES-300U30D.gz --upstream 300 --downstream 30 --binSize 1 --referencePoint TSS  --smartLabels --numberOfProcessors 10 --verbose

plotProfile --matrixFile CPM_MEAN_NS_offset-13-TES-300U30D.gz --outFileName CPM_MEAN_NS_offset-13-TES-300U30D.pdf --plotType lines --colors black green --plotTitle "NS-CPM-TES" --perGroup --legendLocation best  --plotFileFormat pdf  --verbose

echo "For 7) ALL REGULAR STOP:KO vs WT"

computeMatrix reference-point -S $REGULAR_13_KO $REGULAR_13_WT -R COUNTMATRIX/TES/StopCodon_CDS_strand_ALL.bed -o REGULAR_MEAN_ALL_offset-13-TES-300U30D.gz --upstream 300 --downstream 30 --binSize 1 --referencePoint TSS  --smartLabels --numberOfProcessors 10 --verbose

plotProfile --matrixFile REGULAR_MEAN_ALL_offset-13-TES-300U30D.gz --outFileName REGULAR_MEAN_ALL_offset-13-TES-300U30D.pdf --plotType lines --colors black green --plotTitle "ALL-Regular-TES" --perGroup --legendLocation best  --plotFileFormat pdf  --verbose

echo "For 8) ALL CPM STOP:KO vs WT"

computeMatrix reference-point -S $CPM_13_KO $CPM_13_WT -R COUNTMATRIX/TES/StopCodon_CDS_strand_ALL.bed -o CPM_MEAN_ALL_offset-13-TES-300U30D.gz --upstream 300 --downstream 30 --binSize 1 --referencePoint TSS  --smartLabels --numberOfProcessors 10 --verbose

plotProfile --matrixFile CPM_MEAN_ALL_offset-13-TES-300U30D.gz --outFileName CPM_MEAN_ALL_offset-13-TES-300U30D.pdf --plotType lines --colors black green --plotTitle "ALL-CPM-TES" --perGroup --legendLocation best  --plotFileFormat pdf  --verbose