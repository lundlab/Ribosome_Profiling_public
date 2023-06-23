#!/usr/bin/bash

echo "This script is to follow step by step, instead of running it from command line: it is more a documentation of the TX selection process than a running script"
# We decided to filter the TX based on the GOLD CCDS APPRIS TSL AND LENGHT.
# We have multiple categories:
1) 1 GENE 1 GOLD TX with APPRIS  : They will not be subjected to the selection process.
## File = APPRIS_SINGLE_GOLD_11379_genes_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt.
2) 1 GENE 1 GOLD no APPRIS : We will ignore the gold status in here, and Filter all TXs with: CCDS --> APPRIS--> TSL --> LENGHT. THERE ARE 450 GENES IN THIS CATEGORY (455 IN FACT, BUT 5 ARE LOST DUE TO BAD ANNOTATION BTW LIBRARIES)
## File with 1 gene 1 gold no appris : 455_genes_gold_without_appris_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt
## File to filter : allinfo_450_geneids_gold_withoutappris_otherTXappris.txt
## DONE - PART 1 : 356 GENES WITH CCDS, APPRIS, TSL INFO:  GOLD_NOAPPRIS_356_gene_transcript_CCDS_TSL_APPRIS.txt
## PART 2 : 94 GENES with incomplete info for either of these filters : to do.
3) 1 GENE WITH MULTIPLE GOLD with APPRIS : All golds goes through CCDS --> APPRIS --> TSL --> LENGHT
4) 1 GENE WITH MULTIPLE GOLD no APPRIS : All golds goes through CCDS --> TSL --> LENGHT
5) 1 GENE WITH NO GOLD YES APPRIS : CCDS (if all TXs fall through here, then start with APPRIS) --> APPRIS --> TSL --> LENGHT
6) 1 GENE WITH NO GOLD NO APPRIS : CCDS (if all TXs fall through here, then start with TSL) --> TSL --> LENGHT


#############
READY :
1) 2754 genes ( genes without gold and genes with one gold which does not have appris )
2754_genes_nogold_onegoldwithoutappris.txt

2) 5143 genes which have multiple GOLDs


# START WITH REMOVING INCOMPLETE TRANSCRIPTS:
grep $'ensembl_havana\ttranscript'

cat ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.gtf | awk 'BEGIN{FS="\t"}{split($9,a,";"); if($3~"transcript") print a[1]"\t"a[3]"\t"$1":"$4"-"$5"\t"a[5]"\t"a[7]"\t"a[10]"\t"$7"\t"a[11]"\t"a[12]"\t"a[13]"\t"a[14]"\t"a[15]}' |  sed 's/gene_id "//' | sed 's/transcript_id "//' | sed 's/gene_name "//' | sed 's/gene_biotype "//'| sed 's/transcript_biotype "//' | sed 's/ //g' |  sed 's/tag/tag\t/g' | sed 's/ccds_id/ccds_id\t/' | sed 's/transcript_support_level/transcript_support_level\t/' | sed 's/"//g' | sed 's/ //g' | grep $'protein_coding\tprotein_coding' | sort | uniq > ALLTAG_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt

#Remove all incomplete TXs
cat TRANSCRIPT_LEVEL/ALLTAG_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt | grep -v '_NF' | sort | uniq > NF_removed_ALLTAG_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt

# remove the paranthesis
cat NF_removed_ALLTAG_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt | sed "s/([^)]*)//" >  mod_NF_removed_ALLTAG_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt

## add appris information
awk 'NR==FNR{ a[$2,$3]=$5"\t"$6"\t"$7; next }{ s=SUBSEP; k=$1 s $2  }k in a{ print $0,"\t"a[k] }1' copy_appris_gene_tx_length_all.txt mod_NF_removed_ALLTAG_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt | sort | uniq > v1_NF_removed_ALLTAG_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt
# if a TX is printed twice because of a match with appris, I need the longest form, there is no need for reduncancy:
cat v1_NF_removed_ALLTAG_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt | perl -e 'print sort { length($b) <=> length($a) } <>' | awk '!a[$1,$2,$3,$4]++' > appris_added_v1_NF_removed_ALLTAG_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt


#Get all gold ones
grep $'ensembl_havana\ttranscript' ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.gtf | awk 'BEGIN{FS="\t"}{split($9,a,";"); if($3~"transcript") print a[1]"\t"a[3]"\t"$1":"$4"-"$5"\t"a[5]"\t"a[7]"\t"a[10]"\t"$7"\t"a[11]"\t"a[12]"\t"a[13]"\t"a[14]"\t"a[15]}' |  sed 's/gene_id "//' | sed 's/transcript_id "//' | sed 's/gene_name "//' | sed 's/gene_biotype "//'| sed 's/transcript_biotype "//' | sed 's/ //g' |  sed 's/tag/tag\t/g' | sed 's/ccds_id/ccds_id\t/' | sed 's/transcript_support_level/transcript_support_level\t/' | sed 's/"//g' | sed 's/ //g' | grep $'protein_coding\tprotein_coding' | grep -v '_NF' | sort | uniq > GOLD_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt

## some numbers:
cut -f1 GOLD_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt | sort | uniq -c | grep -v '1 ' | wc -l
5143 --> genes with multiple gold TXs

cut -f1 GOLD_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt | sort | uniq -c | grep  '1 ' | wc -l
11834 --> genes with single gold TX

cut -f1 GOLD_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt | sort | uniq -c | grep -v '1 ' > multiple_GOLD_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt #--> genes

cut -f1 GOLD_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt | sort | uniq -c | grep  '1 ' > single_GOLD_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt # --> genes,1 GENE 1 GOLD TX *with and without mixed APPRIS*

A) with APPRIS: select the single genes with all information from the original list

cat single_GOLD_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt | awk -v OFS="\t" '$1=$1' | cut -f2 > 11834_geneids_single_GOLD_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt
# select the information for all of these genes
awk 'NR==FNR{ a[$1]=$1; next }{ s=SUBSEP; k=$1  }k in a{ print $0,"\t"a[k] }' 11834_geneids_single_GOLD_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt GOLD_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt | sort | uniq > allinfo_11834_geneids_single_GOLD_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt

awk 'NR==FNR{ a[$2,$3]=$5"\t"$6"\t"$7; next }{ s=SUBSEP; k=$1 s $2  }k in a{ print $0,"\t"a[k] }' copy_appris_gene_tx_length_all.txt allinfo_11834_geneids_single_GOLD_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt | sort | uniq | wc -l
#11379 genes have single gold tx which have appris. They will not go into any other selection process.

awk 'NR==FNR{ a[$2,$3]=$5"\t"$6"\t"$7; next }{ s=SUBSEP; k=$1 s $2  }k in a{ print $0,"\t"a[k] }' copy_appris_gene_tx_length_all.txt allinfo_11834_geneids_single_GOLD_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt | sort | uniq > APPRIS_SINGLE_GOLD_11379_genes_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt # #11379 genes have single gold tx which have appris. They will not go into any other selection process.
cut -f1 APPRIS_SINGLE_GOLD_11379_genes_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt | sort | uniq > geneIDs_APPRIS_SINGLE_GOLD_11379_genes_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt

cut -f1 APPRIS_SINGLE_GOLD_11379_genes_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt | sort | uniq > geneIDs_single_gold_appris_list.txt --> these genes will not be further filtered. They will directly be used.

B) Genes with multiple gold IDs:
cat multiple_GOLD_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt | awk -v OFS="\t" '$1=$1' | cut -f2 > 5143_geneids_multiple_GOLD_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt

# select the information for all of these genes
awk 'NR==FNR{ a[$1]=$1; next }{ s=SUBSEP; k=$1  }k in a{ print $0,"\t"a[k] }' 5143_geneids_multiple_GOLD_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt GOLD_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt | sort | uniq > allinfo_5143_geneids_multiple_GOLD_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt

cut -f2 allinfo_5143_geneids_multiple_GOLD_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt | sort | uniq > GOLDTX_multiple_12572_allinfo_5143_geneids_multiple_GOLD.txt
#Gold TXs
# remove these and gather them separately.
#--> these transcripts will be picked in their own group.

cp appris_added_v1_NF_removed_ALLTAG_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt copy_appris_added_v1_NF_removed_ALLTAG_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt

# remove 11379 1 GOLD 1 GENE TX.
filename='geneIDs_APPRIS_SINGLE_GOLD_11379_genes_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt'
head $filename
cat $filename | while read -r fullgenename
do
echo $fullgenename
sed -i "/$fullgenename/d" copy_appris_added_v1_NF_removed_ALLTAG_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt
echo "Next one"
done

cut -f1 copy_appris_added_v1_NF_removed_ALLTAG_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt | sort | uniq | wc -l
7897
# Perfect! 19276−11379! 7897!

# We need to separate 5153 more genes from this selection, as they are genes with multiple gold IDs and they need to be filtered seperately.
# But first, trying to have the same size for each line:
cp copy_appris_added_v1_NF_removed_ALLTAG_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt filter_32677_TX.txt
## the details of the line number selection is in gold-versiontwoo.sh. The output of it was :
cat merged_16columns_copy_appris_added_v1_NF_removed_ALLTAG_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt | awk -v OFS="\t" '$1=$1' | awk -F'\t' '{print NF}'   | sort | uniq -c
# 32677 16

# extract the multiple gold genes + their TXs from this list. And, then remove them.
1) Extract 5143 gene IDs + their gold TXs from this merged list.
cat GOLDTX_multiple_12572_allinfo_5143_geneids_multiple_GOLD.txt | while read LINE; do echo $LINE; cat merged_16columns_copy_appris_added_v1_NF_removed_ALLTAG_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt | grep -wi $LINE >> multiplegold_12572_TXs_5143genes_multiple_GOLD.txt;  done
# this file will be extracted separately. It is ready!! 5143 genes with 12572 gold TXs.

######### 7TH NOVEMBER #############
######### FILTERING WITH LENGTHS ########### and add golds with none appris (173 of them )
2) Remove these genes from the merged file.
cp merged_16columns_copy_appris_added_v1_NF_removed_ALLTAG_TSL_CCDS_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt 2927_genes_nogold_onegoldnoappris.txt


cut -f1 4970_genes_multiplegold.txt | sort | uniq > GOLDTX_allinfo_4970_geneids_multiple_GOLD.txt

filename='GOLDTX_allinfo_4970_geneids_multiple_GOLD.txt'
head $filename
cat $filename | while read -r fullgenename
do
echo $fullgenename
sed -i "/$fullgenename/d" 2927_genes_nogold_onegoldnoappris.txt
echo "Next one"
done

cut -f1 2927_genes_nogold_onegoldnoappris.txt | sort | uniq | wc -l
2927


## ADD THE LENGTH
cp 2927_genes_nogold_onegoldnoappris.txt copy_2927_genes_nogold_onegoldnoappris.txt

awk '{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15}' copy_2927_genes_nogold_onegoldnoappris.txt  | awk -v OFS="\t" '$1=$1' | awk '{print NF}' | sort | uniq -c
   9706 15


awk '{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15}' copy_2927_genes_nogold_onegoldnoappris.txt | awk -v OFS="\t" '$1=$1' > 15columns_2927_genes_nogold_onegoldnoappris.txt

cat 15columns_2927_genes_nogold_onegoldnoappris.txt | awk '{print NF}' | sort | uniq -c
   9706 15


awk 'NR==FNR {a[$2,$1]=$3; next}{s=SUBSEP; k=$1 s $2}k in a {$16=$16 "\t" a[k]}1' TRANSCRIPT_LEVEL/ensembl-v97-lenghts-coding-transcripts.txt 15columns_2927_genes_nogold_onegoldnoappris.txt | awk '{print NF}' | sort | uniq -c
   9706 16


awk 'NR==FNR {a[$2,$1]=$3; next}{s=SUBSEP; k=$1 s $2}k in a {$16=$16 "\t" a[k]}1' TRANSCRIPT_LEVEL/ensembl-v97-lenghts-coding-transcripts.txt 15columns_2927_genes_nogold_onegoldnoappris.txt | awk -v OFS="\t" '$1=$1' | sort | uniq > 16columns_lengthadded_2927_genes_nogold_onegoldnoappris.txt

## Separate them into different groups based on CCDS : CCDS only or CCDS multiple/none.

filename='16columns_lengthadded_2927_genes_nogold_onegoldnoappris.txt'
head $filename
cat $filename | sort -k1,1 | awk 'NF==16' | awk '{ if ($16 > 0) print $1 }' | while read -r fullgenename
do
echo $fullgenename
counts=$(awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | cut -f9 | grep 'CCDS' | sort | wc -l )
echo $counts
if [ "$counts" = "1" ]
then
  echo "only one CCDS option for a gene"
  awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | sort | uniq >> A_nogold_nogoldappris_one_CCDS.txt
elif [ "$counts" != "1" ] && [ "$counts" != "0" ]
then
  echo "multiple CCDS options exist for a gene"
  awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename |  grep 'CCDS' | sort | uniq >> A_nogold_nogoldappris_multiple_CCDS.txt
else
  echo "none CCDS options for a gene"
  awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | sort | uniq >> A_nogold_nogoldappris_none_CCDS.txt
fi
done

'''
Perfect!

cut -f1 A_nogold_nogoldappris_* | sort | uniq | wc -l
2927

cat A_nogold_nogoldappris_none_CCDS.txt | cut -f1 | sort | uniq | wc -l
255 --> none CCDS having genes

cat A_nogold_nogoldappris_one_CCDS.txt | cut -f1 | sort | uniq | wc -l
905 --> one ccds for gene

cat A_nogold_nogoldappris_multiple_CCDS.txt | cut -f1 | sort | uniq | wc -l
1767
 --> multiple CCDS having genes

 cat A_nogold_nogoldappris_multiple_CCDS.txt | cut -f2 | sort | uniq | wc -l
 5610

'''

cat A_nogold_nogoldappris_one_CCDS.txt | sort | uniq > sorted_A_nogold_nogoldappris_one_CCDS.txt
cat sorted_A_nogold_nogoldappris_one_CCDS.txt | awk '{ if ($9 != "NONE") print $0 }'  | sort | uniq > noneremoved_sorted_A_nogold_nogoldappris_one_CCDS.txt --> READY TO BE USED!!
cat A_nogold_nogoldappris_multiple_CCDS.txt | sort | uniq > sorted_A_nogold_nogoldappris_multiple_CCDS.txt
cat A_nogold_nogoldappris_none_CCDS.txt | sort | uniq > sorted_A_nogold_nogoldappris_none_CCDS.txt

'''
cut -f1 sorted_A_nogold_nogoldappris_*| sort | uniq | wc -l
2927

'''


## Separate multiple CCDSs into different groups based on appris
filename='sorted_A_nogold_nogoldappris_multiple_CCDS.txt'
head $filename
cat $filename | sort -k1,1 | awk 'NF==16' | awk '{ if ($16 > 0) print $1 }' | sort | uniq | while read -r fullgenename
do
echo $fullgenename
counts=$(awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | cut -f14 | sort | uniq -c | wc -l )
if [ "$counts" = "3" ]
then
    awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | grep -E 'PRINCIPAL|ALTERNATIVE' | sort | uniq >> AB_nogold_onegoldnoappris_Both_prin_alt_appris.txt

elif [ "$counts" = "2" ]
then
    awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | grep -E 'PRINCIPAL|ALTERNATIVE' | sort | uniq >> AB_nogold_onegoldnoappris_either_prin_alt_appris.txt
else
    awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename  | sort | uniq >> AB_nogold_onegoldnoappris_Single_either_genelist.txt

fi
done

'''
cut -f1 AB_nogold_onegoldnoappris_* | sort | uniq | wc -l
1767


'''

cat AB_nogold_onegoldnoappris_Single_either_genelist.txt | awk '{ if ($14 == "NONE") print $0 }' | sort | uniq >> AB_nogold_onegoldnoappris_only_none_genelist.txt

cat AB_nogold_onegoldnoappris_Single_either_genelist.txt | awk '{ if ($14 == "PRINCIPAL") print $0 }' | sort | uniq >> AB_nogold_onegoldnoappris_only_principal_genelist.txt

cat AB_nogold_onegoldnoappris_Single_either_genelist.txt | awk '{ if ($14 == "ALTERNATIVE") print $0 }' | sort | uniq >> AB_nogold_onegoldnoappris_only_alternative_genelist.txt

'''
cut -f1 AB_nogold_onegoldnoappris_Single_either_genelist.txt | sort | uniq | wc -l
760

cut -f1 AB_nogold_onegoldnoappris_only_* | sort | uniq | wc -l
760

'''

cat AB_nogold_onegoldnoappris_Both_prin_alt_appris.txt AB_nogold_onegoldnoappris_either_prin_alt_appris.txt  AB_nogold_onegoldnoappris_only_principal_genelist.txt AB_nogold_onegoldnoappris_only_alternative_genelist.txt | sort | uniq > AB_prin_alt_mix_onegoldnoappris.txt
# Perfect.
'''
cut -f1 AB_prin_alt_mix_onegoldnoappris.txt | sort | uniq | wc -l
1659  --> genes have appris with multiple ccds

cut -f1 AB_nogold_onegoldnoappris_only_none_genelist.txt | sort | uniq | wc -l
108
 --> 65 genes have no info for appris with multiple ccds

'''
#filter these ones now without nones
filename='AB_prin_alt_mix_onegoldnoappris.txt'
head $filename
cat $filename | sort -k1,1 | awk 'NF==16' | awk '{ if ($16 > 0) print $1 }' | sort | uniq | while read -r fullgenename
do
echo $fullgenename
counts=$(awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | cut -f14 | sort | uniq -c | wc -l )
if [ "$counts" = "2" ]
then
    awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | sort | uniq >> AB_nogold_onegoldnoappris_Both_prin_alter_genelist.txt

else
    awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | sort | uniq >> AB_nogold_onegoldnoappris_PR_OR_ALT_genelist.txt

fi
done

cat AB_nogold_onegoldnoappris_PR_OR_ALT_genelist.txt | sort | uniq > AB_sorted_nogold_onegoldnoappris_PR_OR_ALT_genelist.txt

cat AB_nogold_onegoldnoappris_Both_prin_alter_genelist.txt | sort | uniq > AB_sorted_nogold_onegoldnoappris_Both_prin_alter_genelist.txt

sed '/ALTERNATIVE/d' AB_sorted_nogold_onegoldnoappris_Both_prin_alter_genelist.txt > AB_principle_only_onegoldnoappris_Both_prin_alter_genelist.txt

cat AB_principle_only_onegoldnoappris_Both_prin_alter_genelist.txt AB_sorted_nogold_onegoldnoappris_PR_OR_ALT_genelist.txt | sort | uniq  > AB_nogold_onegoldnoappris_only_one_option_genelist.txt

cut -f1 AB_nogold_onegoldnoappris_only_one_option_genelist.txt | sort | uniq | wc -l
1659


cut -f1 AB_nogold_onegoldnoappris_only_none_genelist.txt | sort | uniq | wc -l
108


## I will continue with these 2730 genes and select them with CCDS, APPRIS, TSL and lenght.
cut -f1,9 AB_nogold_onegoldnoappris_only_one_option_genelist.txt | sort | uniq -c | awk -v OFS="\t" '$1=$1' | cut -f2 | sort | uniq -c | grep -v '1 ' | wc -l
0 --> 0 genes have a mix of CCDS ID and NONE.

cat AB_nogold_onegoldnoappris_only_one_option_genelist.txt AB_nogold_onegoldnoappris_only_none_genelist.txt | sort | uniq > 1767_all_nogold_goldnoappris.txt
--> this is part 1 for appris selection.

# Now repeat the same appris only option for none ccds ones.

## Separate none CCDSs into different groups based on appris
filename='sorted_A_nogold_nogoldappris_none_CCDS.txt'
head $filename
cat $filename | sort -k1,1 | awk 'NF==16' | awk '{ if ($16 > 0) print $1 }' | sort | uniq | while read -r fullgenename
do
echo $fullgenename
counts=$(awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | cut -f14 | sort | uniq -c | wc -l )
if [ "$counts" = "3" ]
then
    awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | grep -E 'PRINCIPAL|ALTERNATIVE' | sort | uniq >> NAB_nogold_onegoldnoappris_Both_prin_alt_appris.txt

elif [ "$counts" = "2" ]
then
    awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | grep -E 'PRINCIPAL|ALTERNATIVE' | sort | uniq >> NAB_nogold_onegoldnoappris_either_prin_alt_appris.txt
else
    awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename  | sort | uniq >> NAB_nogold_onegoldnoappris_Single_either_genelist.txt

fi
done

'''
cut -f1 AB_nogold_onegoldnoappris_* | sort | uniq | wc -l
1767

'''

cat NAB_nogold_onegoldnoappris_Single_either_genelist.txt | awk '{ if ($14 == "NONE") print $0 }' | sort | uniq >> NAB_nogold_onegoldnoappris_only_none_genelist.txt

cat NAB_nogold_onegoldnoappris_Single_either_genelist.txt | awk '{ if ($14 == "PRINCIPAL") print $0 }' | sort | uniq >> NAB_nogold_onegoldnoappris_only_principal_genelist.txt

cat NAB_nogold_onegoldnoappris_Single_either_genelist.txt | awk '{ if ($14 == "ALTERNATIVE") print $0 }' | sort | uniq >> NAB_nogold_onegoldnoappris_only_alternative_genelist.txt

'''
cut -f1 NAB_nogold_onegoldnoappris_Single_either_genelist.txt | sort | uniq | wc -l
175
cut -f1 NAB_nogold_onegoldnoappris_only_* | sort | uniq | wc -l
175

'''

cat NAB_nogold_onegoldnoappris_Both_prin_alt_appris.txt NAB_nogold_onegoldnoappris_either_prin_alt_appris.txt  NAB_nogold_onegoldnoappris_only_principal_genelist.txt NAB_nogold_onegoldnoappris_only_alternative_genelist.txt | sort | uniq > NAB_prin_alt_mix_onegoldnoappris.txt
#Works!
'''
cut -f1 NAB_prin_alt_mix_onegoldnoappris.txt | sort | uniq | wc -l
242  --> genes have appris with NONE ccds
cut -f1 NAB_nogold_onegoldnoappris_only_none_genelist.txt | sort | uniq | wc -l
13 --> 13 genes have no info for appris with none ccds

'''
#filter these ones now without nones
filename='NAB_prin_alt_mix_onegoldnoappris.txt'
head $filename
cat $filename | sort -k1,1 | awk 'NF==16' | awk '{ if ($16 > 0) print $1 }' | sort | uniq | while read -r fullgenename
do
echo $fullgenename
counts=$(awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | cut -f14 | sort | uniq -c | wc -l )
if [ "$counts" = "2" ]
then
    awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | sort | uniq >> NAB_nogold_onegoldnoappris_Both_prin_alter_genelist.txt

else
    awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | sort | uniq >> NAB_nogold_onegoldnoappris_PR_OR_ALT_genelist.txt

fi
done

cat NAB_nogold_onegoldnoappris_PR_OR_ALT_genelist.txt | sort | uniq > NAB_sorted_nogold_onegoldnoappris_PR_OR_ALT_genelist.txt

cat NAB_nogold_onegoldnoappris_Both_prin_alter_genelist.txt | sort | uniq > NAB_sorted_nogold_onegoldnoappris_Both_prin_alter_genelist.txt

sed '/ALTERNATIVE/d' NAB_sorted_nogold_onegoldnoappris_Both_prin_alter_genelist.txt > NAB_principle_only_onegoldnoappris_Both_prin_alter_genelist.txt

cat NAB_principle_only_onegoldnoappris_Both_prin_alter_genelist.txt NAB_sorted_nogold_onegoldnoappris_PR_OR_ALT_genelist.txt | sort | uniq  > NAB_nogold_onegoldnoappris_only_one_option_genelist.txt

cut -f1 NAB_nogold_onegoldnoappris_only_one_option_genelist.txt | sort | uniq | wc -l
242


cut -f1 NAB_nogold_onegoldnoappris_only_none_genelist.txt | sort | uniq | wc -l
13

## I will continue with these 2730 genes and select them with CCDS, APPRIS, TSL and lenght.
cut -f1,9 NAB_nogold_onegoldnoappris_only_one_option_genelist.txt | sort | uniq -c | awk -v OFS="\t" '$1=$1' | cut -f2 | sort | uniq -c | grep -v '1 ' | wc -l
0 --> 0 genes have a mix of CCDS ID and NONE.

cat NAB_nogold_onegoldnoappris_only_one_option_genelist.txt NAB_nogold_onegoldnoappris_only_none_genelist.txt | sort | uniq > 255_all_nogold_goldnoappris.txt
--> this is part 2 for appris selection.

--> MERGE
cat 1767_all_nogold_goldnoappris.txt 255_all_nogold_goldnoappris.txt | sort | uniq > 2022_all_nogold_goldnoappris.txt
--> this will go into selection for ccds appris tsl lenght for no gold + 1 gold no appris. #####
'''
cut -f1 2022_all_nogold_goldnoappris.txt | sort | uniq | wc -l
2022
wc -l 2022_all_nogold_goldnoappris.txt
3644 2022_all_nogold_goldnoappris.txt --> number of TXs for these genes

'''
CCDS--> APPRIS --> TSL --> LENGHT
filename='2022_all_nogold_goldnoappris.txt'
head $filename
cat $filename | sort -k1,1 | awk 'NF==16' | awk '{ if ($16 > 0) print $1 }' | while read -r fullgenename
do
echo $fullgenename
counts=$(awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | cut -f9 | grep 'CCDS' | sort | wc -l )
echo $counts
if [ "$counts" == "1" ]
then
  echo "only one option for a gene"
  awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | sort | uniq >> ACB_nogold_nogoldappris_one_CCDS.txt
elif [ "$counts" != "1" ] && [ "$counts" != "0" ]
then
  echo "multiple CCDS exists for this gene, we have to look the appris"
  secondcounts=$(awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | grep 'CCDS' | sort -k15,15 | cut -f15 | grep -v 'NONE' | sort | uniq -c | wc -l)
  secondcountsunique=$(awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | grep 'CCDS' | sort -k15,15 | cut -f15 | grep -v 'NONE' | sort | uniq -c | awk -v OFS="\t" '$1=$1' | cut -f1)
  echo "$secondcounts" >> ACBapprisordercounter.txt
  if ([ "$secondcounts" != "1" ] && [ "$secondcounts" != "0" ]) || [ "$secondcountsunique" = "1" ]
  then
    echo "orders of options are different, we get the smallest one for appris"
    awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | grep 'CCDS' | sort -k15,15 -k16,16nr | head -1 >> ACB_nogold_nogoldappris_APPRIS_picked.txt
  elif [ "$secondcounts" = "1" ] || [ "$secondcounts" = "0" ]
  then
    echo "all options have the same order/none for appris,we pick with the TSL"
    thirdcounts=$(awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | grep 'CCDS' | sort -k13,13 | cut -f13 | grep -v 'NONE' | sort | uniq -c | wc -l)
    thidscountsunique=$(awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | grep 'CCDS' |  sort -k13,13 | cut -f13 | grep -v 'NONE' | sort | uniq -c | awk -v OFS="\t" '$1=$1' | cut -f1 | awk '{s+=$1} END {print s}')
    echo $thidscountsunique
    if ([ "$thirdcounts" != "1" ] && [ "$thirdcounts" != "0" ]) || [ "$thidscountsunique" = "1" ]
    then
      echo "orders of options are different, we get the smallest one for TSL"
      awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | grep 'CCDS' | sort -k13,13 -k16,16nr | head -1 >> ACB_nogold_nogoldappris_TSL_picked.txt
    elif [ "$thirdcounts" = "1" ]
    then
      echo "orders of options are the same, we get the longest TX"
      awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | grep 'CCDS' | sort -k16,16nr | head -1 >> ACB_nogold_nogoldappris_LONGEST_picked.txt
    elif [ "$thirdcounts" = "0" ]
    then
      echo "There is no TSL info, we get the longest TX"
      awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | grep 'CCDS' | sort -k16,16nr | head -1 >> ACB_nogold_nogoldappris_LONGEST_picked.txt
    else
      echo "This should never print"
    fi
  else
    echo "This should never print"
  fi
else
  echo "None CCDS exists for this gene, we have to look the appris"
  secondcountsD=$(awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | sort -k15,15 | cut -f15 | grep -v 'NONE' | sort | uniq -c | wc -l)
  secondcountsuniqueD=$(awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | sort -k15,15 | cut -f15 | grep -v 'NONE' | sort | uniq -c | awk -v OFS="\t" '$1=$1' | cut -f1)
  echo "$secondcountsD" >> ACDapprisordercounter.txt
  if ([ "$secondcountsD" != "1" ] && [ "$secondcountsD" != "0" ]) || [ "$secondcountsuniqueD" = "1" ]
  then
    echo "orders of options are different, we get the smallest one for appris"
    awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | sort -k15,15 -k16,16nr | head -1 >> ACD_nogold_nogoldappris_APPRIS_picked.txt
  elif [ "$secondcountsD" = "1" ] || [ "$secondcountsD" = "0" ]
  then
    echo "all options have the same order/none for appris,we pick with the TSL"
    thirdcountsD=$(awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | sort -k13,13 | cut -f13 | grep -v 'NONE' | sort | uniq -c | wc -l)
    thidscountsuniqueD=$(awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | sort -k13,13 | cut -f13 | grep -v 'NONE' | sort | uniq -c | awk -v OFS="\t" '$1=$1' | cut -f1 | awk '{s+=$1} END {print s}')
    echo $thidscountsuniqueD
    if ([ "$thirdcountsD" != "1" ] && [ "$thirdcountsD" != "0" ]) || [ "$thidscountsuniqueD" = "1" ]
    then
      echo "orders of options are different, we get the smallest one for TSL"
      awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | sort -k13,13 -k16,16nr | head -1 >> ACD_nogold_nogoldappris_TSL_picked.txt
    elif [ "$thirdcountsD" = "1" ]
    then
      echo "orders of options are the same, we get the longest TX"
      awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | sort -k16,16nr | head -1 >> ACD_nogold_nogoldappris_LONGEST_picked.txt
    elif [ "$thirdcountsD" = "0" ]
    then
      echo "There is no TSL info, we get the longest TX"
      awk '{ if ($1 == "'$fullgenename'") print $0 }' $filename | sort -k16,16nr | head -1 >> ACD_nogold_nogoldappris_LONGEST_picked.txt
    else
      echo "This should never print"
    fi
  else
    echo "This should never print"
  fi
fi
done

## It is perfect!!!
'''
cat ACD_nogold_nogoldappris_APPRIS_picked.txt  ACD_nogold_nogoldappris_LONGEST_picked.txt  ACD_nogold_nogoldappris_TSL_picked.txt ACB_nogold_nogoldappris_LONGEST_picked.txt  ACB_nogold_nogoldappris_one_CCDS.txt  ACB_nogold_nogoldappris_TSL_picked.txt | sort | uniq | cut -f1 | sort | uniq | wc -l
2022

cat ACD_nogold_nogoldappris_APPRIS_picked.txt  ACD_nogold_nogoldappris_LONGEST_picked.txt  ACD_nogold_nogoldappris_TSL_picked.txt ACB_nogold_nogoldappris_LONGEST_picked.txt  ACB_nogold_nogoldappris_one_CCDS.txt  ACB_nogold_nogoldappris_TSL_picked.txt | sort | uniq | cut -f2 | sort | uniq | wc -l
2022

cat ACD_nogold_nogoldappris_APPRIS_picked.txt  ACD_nogold_nogoldappris_LONGEST_picked.txt  ACD_nogold_nogoldappris_TSL_picked.txt ACB_nogold_nogoldappris_LONGEST_picked.txt  ACB_nogold_nogoldappris_one_CCDS.txt  ACB_nogold_nogoldappris_TSL_picked.txt | sort | uniq | wc -l
2022

'''

cat ACD_* ACB_* | sort | uniq > MergeD_2022_genes_multipleornone_CCDS.txt

'''
cat noneremoved_sorted_A_nogold_nogoldappris_one_CCDS.txt MergeD_2022_genes_multipleornone_CCDS.txt | cut -f1 | sort | uniq | wc -l
2927
'''

cat noneremoved_sorted_A_nogold_nogoldappris_one_CCDS.txt MergeD_2022_genes_multipleornone_CCDS.txt | sort | uniq > 2927_genes_nogold_onegoldwithoutappris.txt
### DONE! THIS FILE IS READY.


##############
##############
GET THEM ALL :
1) MULTIPLE GOLD : 4970_genes_multiplegold.txt
cut -f1,2,4 4970_genes_multiplegold.txt > geneID_TXID_genename_4970_multiplegold.txt

2) ONE GOLD WITHOUT APPRIS + NO GOLD (edit on 28th May 2020): + MULTI GOLD NO APPRIS: /2927_genes_nogold_onegoldwithoutappris.txt
cut -f1,2,4 2927_genes_nogold_onegoldwithoutappris.txt > geneID_TXID_genename_2927_nogoldORonegoldwithoutappris.txt


3) ONE GOLD WITH APPRIS : TRANSCRIPT_LEVEL/APPRIS_SINGLE_GOLD_11379_genes_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt
cut -f1,2,4 APPRIS_SINGLE_GOLD_11379_genes_ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.txt > geneID_TXID_genename_11379_onegoldwithappris.txt

cat geneID_TXID_genename_4970_multiplegold.txt /geneID_TXID_genename_2927_nogoldORonegoldwithoutappris.txt TRANSCRIPT_LEVEL/geneID_TXID_genename_11379_onegoldwithappris.txt | sort | uniq > TRANSCRIPT_LEVEL/19276_CLEAN/19276_PCPC_genes_CCDS_APPRIS_TSL_LENGTH_filtered.txt

##############
'''
cut -f1 19276_PCPC_genes_CCDS_APPRIS_TSL_LENGTH_filtered.txt | sort | uniq | wc -l
19276
cut -f2 19276_PCPC_genes_CCDS_APPRIS_TSL_LENGTH_filtered.txt | sort | uniq | wc -l
19276
'''
cd TRANSCRIPT_LEVEL/19276_CLEAN

cut -f2 TRANSCRIPT_LEVEL/19276_CLEAN/19276_PCPC_genes_CCDS_APPRIS_TSL_LENGTH_filtered.txt | sort | uniq > TRANSCRIPT_LEVEL/19276_CLEAN/list_of_selected_TXs.txt


LETS FILTER THE GTF:
cat TRANSCRIPT_LEVEL/19276_CLEAN/list_of_selected_TXs.txt | while read LINE; do echo $LINE; cat ProteinCoding_Homo_sapiens.GRCh38.V97_HUGO-filtered.gtf | grep -wi $LINE >> TRANSCRIPT_LEVEL/19276_CLEAN/filtered_CCDS_APPRIS_TSL_LENGTH_Homo_sapiens.GrcH38.V97.gtf;  done