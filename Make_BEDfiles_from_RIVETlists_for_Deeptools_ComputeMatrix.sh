### Prepare the RIVET BED FILES:

#### UP ###########
## START CODON
######### Extract start codons : UP #################
####
echo "Extract the start codons: UP"

UP_PATH="/COUNTMATRIX/TSS"
GTF_UP="TL_UP.gtf"


SHORTNAME_UP=$(basename "$GTF_UP" .gtf)
awk 'BEGIN{FS="\t"}{if($3~"start_codon") print $0}' "$GTF_UP" > "$UP_PATH"/START_CODON_"$SHORTNAME_UP"
awk 'BEGIN{FS="\t"} {$6=$7; print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9}' "$UP_PATH"/START_CODON_"$SHORTNAME_UP" > "$UP_PATH"/strand_START_CODON_"$SHORTNAME_UP"
sed  's/start_codon/CDS/g' "$UP_PATH"/strand_START_CODON_"$SHORTNAME_UP" > "$UP_PATH"/StartCodon_CDS_strand_UP_TX.gtf

grep -P "\tCDS\t" "$UP_PATH"/StartCodon_CDS_strand_UP_TX.gtf | cut -f1,4,5,7,9 |sed 's/[[:space:]]/\t/g' | sed 's/[;|"]//g' | awk -F $'\t' 'BEGIN { OFS=FS } { print "chr"$1,$2-1,$3,$10,".",$4}' | awk -v OFS="\t" '$1=$1' | sort -k1,1  > "$UP_PATH"/modified_StartCodon_CDS_strand_UP_TX_fromGTF.bed

## STOP CODON
############## 
## Extract stop codons : UP 

echo "Extract the stop codons: UP"
UP_PATH_TES="/COUNTMATRIX/TES"
GTF_UP="TL_UP.gtf"


SHORTNAME_UP=$(basename "$GTF_UP" .gtf)
awk 'BEGIN{FS="\t"}{if($3~"stop_codon") print $0}' "$GTF_UP" > "$UP_PATH_TES"/STOP_CODON_"$SHORTNAME_UP"
awk 'BEGIN{FS="\t"} {$6=$7; print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9}' "$UP_PATH_TES"/STOP_CODON_"$SHORTNAME_UP" > "$UP_PATH_TES"/strand_STOP_CODON_"$SHORTNAME_UP"
sed  's/stop_codon/CDS/g' "$UP_PATH_TES"/strand_STOP_CODON_"$SHORTNAME_UP" > "$UP_PATH_TES"/StopCodon_CDS_strand_UP_TX.gtf

grep -P "\tCDS\t" "$UP_PATH_TES"/StopCodon_CDS_strand_UP_TX.gtf | cut -f1,4,5,7,9 | sed 's/[[:space:]]/\t/g' | sed 's/[;|"]//g' | awk -F $'\t' 'BEGIN { OFS=FS } { print "chr"$1,$2-1,$3,$10,".",$4}' | awk -v OFS="\t" '$1=$1' | sort -k1,1  > "$UP_PATH_TES"/modified_StopCodon_CDS_strand_UP_TXfromGTF.bed

####### UP IS DONE.
#### DOWN ####
echo "Extract the start codons: DOWN"

UP_PATH="/COUNTMATRIX/TSS"
GTF_DOWN="TL_DOWN.gtf"


SHORTNAME_UP=$(basename "$GTF_DOWN" .gtf)
awk 'BEGIN{FS="\t"}{if($3~"start_codon") print $0}' "$GTF_DOWN" > "$UP_PATH"/START_CODON_"$SHORTNAME_UP"
awk 'BEGIN{FS="\t"} {$6=$7; print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9}' "$UP_PATH"/START_CODON_"$SHORTNAME_UP" > "$UP_PATH"/strand_START_CODON_"$SHORTNAME_UP"
sed  's/start_codon/CDS/g' "$UP_PATH"/strand_START_CODON_"$SHORTNAME_UP" > "$UP_PATH"/StartCodon_CDS_strand_DOWN_TX.gtf

grep -P "\tCDS\t" "$UP_PATH"/StartCodon_CDS_strand_DOWN_TL_NS_TX.gtf | cut -f1,4,5,7,9 |sed 's/[[:space:]]/\t/g' | sed 's/[;|"]//g' | awk -F $'\t' 'BEGIN { OFS=FS } { print "chr"$1,$2-1,$3,$10,".",$4}' | awk -v OFS="\t" '$1=$1' | sort -k1,1  > "$UP_PATH"/modified_StartCodon_CDS_strand_DOWN_TX_fromGTF.bed


echo "Extract the stop codons: DOWN"
UP_PATH_TES="/COUNTMATRIX/TES"
GTF_DOWN="TL_DOWN.gtf"

SHORTNAME_UP=$(basename "$GTF_DOWN" .gtf)
awk 'BEGIN{FS="\t"}{if($3~"stop_codon") print $0}' "$GTF_DOWN" > "$UP_PATH_TES"/STOP_CODON_"$SHORTNAME_UP"
awk 'BEGIN{FS="\t"} {$6=$7; print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9}' "$UP_PATH_TES"/STOP_CODON_"$SHORTNAME_UP" > "$UP_PATH_TES"/strand_STOP_CODON_"$SHORTNAME_UP"
sed  's/stop_codon/CDS/g' "$UP_PATH_TES"/strand_STOP_CODON_"$SHORTNAME_UP" > "$UP_PATH_TES"/StopCodon_CDS_strand_DOWN_TX.gtf

grep -P "\tCDS\t" "$UP_PATH_TES"/StopCodon_CDS_strand_DOWN_TL_NS_TX.gtf | cut -f1,4,5,7,9 | sed 's/[[:space:]]/\t/g' | sed 's/[;|"]//g' | awk -F $'\t' 'BEGIN { OFS=FS } { print "chr"$1,$2-1,$3,$10,".",$4}' | awk -v OFS="\t" '$1=$1' | sort -k1,1  > "$UP_PATH_TES"/modified_StopCodon_CDS_strand_DOWN_TXfromGTF.bed

####### DOWN IS DONE.

### ALL ###
echo "Extract the start codon for ALL "

ALL_PATH="/COUNTMATRIX/TSS"
GTF_ALL="TL_ALL.gtf"

SHORTNAME_ALL=$(basename "$GTF_ALL" .gtf)
awk 'BEGIN{FS="\t"}{if($3~"start_codon") print $0}' "$GTF_ALL" > "$ALL_PATH"/START_CODON_"$SHORTNAME_ALL"
awk 'BEGIN{FS="\t"} {$6=$7; print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9}' "$ALL_PATH"/START_CODON_"$SHORTNAME_ALL" > "$ALL_PATH"/strand_START_CODON_"$SHORTNAME_ALL"
sed  's/start_codon/CDS/g' "$ALL_PATH"/strand_START_CODON_"$SHORTNAME_ALL" > "$ALL_PATH"/StartCodon_CDS_strand_ALL_TX.gtf

grep -P "\tCDS\t" "$ALL_PATH"/StartCodon_CDS_strand_ALL_TX.gtf | cut -f1,4,5,7,9 | sed 's/[[:space:]]/\t/g' | sed 's/[;|"]//g' | awk -F $'\t' 'BEGIN { OFS=FS } { print "chr"$1,$2-1,$3,$10,".",$4}' | awk -v OFS="\t" '$1=$1' | sort -k1,1  > "$ALL_PATH"/modified_StartCodon_CDS_strand_ALL_TXfromGTF.bed

### ALL ###
echo "Extract the stop codon for ALL "

ALL_PATH_TES="/COUNTMATRIX/TES"
GTF_ALL="TL_ALL.gtf"


SHORTNAME_ALL=$(basename "$GTF_ALL" .gtf)
awk 'BEGIN{FS="\t"}{if($3~"stop_codon") print $0}' "$GTF_ALL" > "$ALL_PATH_TES"/STOP_CODON_"$SHORTNAME_ALL"
awk 'BEGIN{FS="\t"} {$6=$7; print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9}' "$ALL_PATH_TES"/STOP_CODON_"$SHORTNAME_ALL" > "$ALL_PATH_TES"/strand_STOP_CODON_"$SHORTNAME_ALL"
sed  's/stop_codon/CDS/g' "$ALL_PATH_TES"/strand_STOP_CODON_"$SHORTNAME_ALL" > "$ALL_PATH_TES"/StopCodon_CDS_strand_ALL_TX.gtf

grep -P "\tCDS\t" "$ALL_PATH_TES"/StopCodon_CDS_strand_ALL_TX.gtf | cut -f1,4,5,7,9 | sed 's/[[:space:]]/\t/g' | sed 's/[;|"]//g' | awk -F $'\t' 'BEGIN { OFS=FS } { print "chr"$1,$2-1,$3,$10,".",$4}' | awk -v OFS="\t" '$1=$1' | sort -k1,1  > "$ALL_PATH_TES"/modified_StopCodon_CDS_strand_ALL_TXfromGTF.bed


########## ALL IS COMPLETED ####
####

#### NS
echo "Extract the start codons: NOT SIGNIFICANT"

NS_PATH="/COUNTMATRIX/TSS"
GTF_NS="TL_NS.gtf"

SHORTNAME_NS=$(basename "$GTF_NS" .gtf)
awk 'BEGIN{FS="\t"}{if($3~"start_codon") print $0}' "$GTF_NS" > "$NS_PATH"/START_CODON_"$SHORTNAME_NS"
awk 'BEGIN{FS="\t"} {$6=$7; print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9}' "$NS_PATH"/START_CODON_"$SHORTNAME_NS" > "$NS_PATH"/strand_START_CODON_"$SHORTNAME_NS"
sed  's/start_codon/CDS/g' "$NS_PATH"/strand_START_CODON_"$SHORTNAME_NS" > "$NS_PATH"/StartCodon_CDS_strand_NS_TX.gtf

grep -P "\tCDS\t" "$NS_PATH"/StartCodon_CDS_strand_NS_TX.gtf | cut -f1,4,5,7,9 | sed 's/[[:space:]]/\t/g' | sed 's/[;|"]//g' | awk -F $'\t' 'BEGIN { OFS=FS } { print "chr"$1,$2-1,$3,$10,".",$4}' | awk -v OFS="\t" '$1=$1' | sort -k1,1   > "$NS_PATH"/modified_StartCodon_CDS_strand_NS_TXfromGTF.bed


#### NS
echo "Extract the stop codons: NOT SIGNIFICANT"

NS_PATH_TES="/COUNTMATRIX/TES"
GTF_NS="TL_NS.gtf"

SHORTNAME_NS=$(basename "$GTF_NS" .gtf)
awk 'BEGIN{FS="\t"}{if($3~"stop_codon") print $0}' "$GTF_NS" > "$NS_PATH_TES"/STOP_CODON_"$SHORTNAME_NS"
awk 'BEGIN{FS="\t"} {$6=$7; print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9}' "$NS_PATH_TES"/STOP_CODON_"$SHORTNAME_NS" > "$NS_PATH_TES"/strand_STOP_CODON_"$SHORTNAME_NS"
sed  's/stop_codon/CDS/g' "$NS_PATH_TES"/strand_STOP_CODON_"$SHORTNAME_NS" > "$NS_PATH_TES"/StopCodon_CDS_strand_NS_TX.gtf