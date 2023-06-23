## LOGIC: HUGO website has HUGO IDs and gene names and ensembl IDs. 

'''
We get these HUGO approved gene list from their website, and :
# HGNC ID Approved symbol Status  Ensembl gene ID

cut -f3 HUGO-custom-without-synm.txt | sort | uniq -c 
  41972 Approved
      1 Status
      
tail -n +2 HUGO-custom-without-synm.txt | cut -f4 | sort | uniq | wc -l
36049 --> number of ensembl IDs

cat HUGO-custom-without-synm.txt | sort | uniq | wc -l
41973 --> all approved genes ( 1 is the title so it is 41972 genes )

## CONTROL
tail -n +2 HUGO-custom-without-synm.txt | cut -f2,4 | awk 'NF==1'  > onecol.txt
cat onecol.txt | sort | uniq > 5924_onecol.txt
cat all_gene_names_hugo.txt | sort | uniq > 82083_twocol.txt

 awk 'NR==FNR{a[$1]++;next} a[$1] ' 5924_onecol.txt 82083_twocol.txt | wc -l
5924 --> SHARED : all of the gene names from HUGO-custom-without-synm.txt
 wc -l HUGO-custom-download.txt 
41973 HUGO-custom-download.txt
 awk 'NR==FNR{a[$1]++;next} !a[$1] ' 5924_onecol.txt 82083_twocol.txt | wc -l
76159 --> SYNONYMS : all of the synonyms from HUGO-custom-download.txt

# We used HUGO-custom-download.txt for gene names and synonyms : so it is all good!

cat HUGO-custom-download.txt | cut -f2,4 | tail -n +2  | sed 's/, /\n/g' | sed 's/\t/\n/g' | sed '/^$/d' | sort | uniq > all_gene_names_hugo.txt

We searched for these gene IDs and synonyms in the ensembl GTF file.
 cut -f1 tab_geneID_name_info_Ensembl97.txt | sort | uniq | wc -l
60617 --> number of genes in ensembl gtf original form

When we searched for the HUGO approved genes genename and synonyms, It resulted in :
 wc -l EnsV97_ALL_gene_names_app_and_syn_ensemblID_extraction.txt 
37370 EnsV97_ALL_gene_names_app_and_syn_ensemblID_extraction.txt
 cut -f1 EnsV97_ALL_gene_names_app_and_syn_ensemblID_extraction.txt | sort | uniq | wc -l
37370

#3730 ensembl IDs which have gene names or synonyms shared in HUGO APPROVED list.
## Everything is gene name / synonym based until now. ensembl file has been filtered by those.

## Then we enter the second phase and look for the ensembl IDs:
Then, we go back to HUGO custom download, and get the ensembl IDs
tail -n +2 HUGO-custom-without-synm.txt | cut -f2,4 | awk 'NF==2' | cut -f2 | sort | uniq > ensemblIDs_of_hugogenes.txt



'''

https://www.genenames.org/cgi-bin/download/custom?col=gd_hgnc_id&col=gd_app_sym&col=gd_status&col=gd_aliases&col=gd_pub_ensembl_id&status=Approved&hgnc_dbtag=on&order_by=gd_app_name&format=text&submit=submit

tail -n +2 HUGO-custom-download.txt | cut -f5 | sort | uniq -c | awk -v OFS="\t" '$1=$1' | cut -f1 | sort | uniq -c
#  36048 1
#      1 5924
'''
 tail -n +2 HUGO-custom-download.txt | cut -f5 | sort | uniq -c | awk -v OFS="\t" '$1=$1' | cut -f1 | sort | uniq -c
  36048 1
      1 5924

'''
https://www.genenames.org/cgi-bin/download/custom?col=gd_hgnc_id&col=gd_app_sym&col=gd_status&col=gd_pub_ensembl_id&status=Approved&hgnc_dbtag=on&order_by=gd_app_sym_sort&format=text&submit=submit


tail -n +2 HUGO-custom-without-synm.txt | cut -f2,4 | awk 'NF==1' | sort | uniq > gene_names_withoutensemblIDs.txt

#wc -l gene_names_withoutensemblIDs.txt 
# 5924 gene_names_withoutensemblIDs.txt
# I will search these gene names in the original GTF file to get their ensembl IDs as HUGO didnt have them in their website..

cat HUGO-custom-download.txt | cut -f2,4 | tail -n +2  | sed 's/, /\n/g' | sed 's/\t/\n/g' | sed '/^$/d' | sort | uniq > /all_gene_names_hugo.txt
'''

## I need to gather the ENSEMBL IDs or gene names having HUGO IDs

### Make a HUGO filtered gtf
cat Homo_sapiens.GRCh38.97.gtf | awk 'BEGIN{FS="\t"}{split($9,a,";"); if($3~"gene") print a[1]"\t"a[3]"\t"$1":"$4"-"$5"\t"a[5]"\t"$7}' | sed 's/gene_id "//' | sed 's/gene_biotype "//' |  sed 's/gene_name "//' | sed 's/"//g' | sed 's/ //g' > geneID_name_info_Ensembl97.txt


'''
 wc -l geneID_name_info_Ensembl97.txt 
60617 geneID_name_info_Ensembl97.txt

cut -f1 geneID_name_info_Ensembl97.txt | sort | uniq | wc -l
60617 --> the number of ensembl IDs

cut -f2 geneID_name_info_Ensembl97.txt | sort | uniq | wc -l
59087 --> the number of gene symbols ( one gene having multiple ensembl IDs)

'''
cat geneID_name_info_Ensembl97.txt |  awk -v OFS="\t" '$1=$1'> tab_geneID_name_info_Ensembl97.txt
awk 'NR==FNR{ a[$1]=$1; next }{ s=SUBSEP; k=$2 }k in a{ print $0,a[k] }' all_gene_names_hugo.txt tab_geneID_name_info_Ensembl97.txt > EnsV97_ALL_gene_names_app_and_syn_ensemblID_extraction.txt

tail -n +2 HUGO-custom-without-synm.txt | cut -f2,4 | awk 'NF==2' | cut -f2 | sort | uniq > ensemblIDs_of_hugogenes.txt

## This is a genename based extraction until now
cut -f1 EnsV97_ALL_gene_names_app_and_syn_ensemblID_extraction.txt | sort | uniq > ensemblIDs_v97_HUGO_genenamebased.txt
'''

wc -l EnsV97_ALL_gene_names_app_and_syn_ensemblID_extraction.txt 
37370 EnsV97_ALL_gene_names_app_and_syn_ensemblID_extraction.txt
'''

# I will compare it with ensemblIDs_of_hugogenes.txt
comm -12 ensemblIDs_of_hugogenes.txt ensemblIDs_v97_HUGO_genenamebased.txt | wc -l
35264 --> shared
comm -23 ensemblIDs_of_hugogenes.txt ensemblIDs_v97_HUGO_genenamebased.txt | wc -l
784 --> unique to ensembl IDs of hugo genes
comm -23 ensemblIDs_v97_HUGO_genenamebased.txt ensemblIDs_of_hugogenes.txt | wc -l
2106 --> ensembl IDS fetched from gtf file because names matched and these do not exist as ensembliDs in hugo download
#comm -23 ensemblIDs_v97_HUGO_genenamebased.txt ensemblIDs_of_hugogenes.txt | wc -l
#2106 --> difference in between 97 and 96 genebased ensembl ID extractions


wc -l ensemblIDs_*
  36048 ensemblIDs_of_hugogenes.txt --> ensemblIDS gathered from hugo ensembl IDs ( provided within custom download )
  37370 ensemblIDs_v97_HUGO_genenamebased.txt --> ensembl IDs grabbed from ensembl V97 GTF with the hugo gene names (if gene names match in between hugo approved /synonym and ensembl GTF, we fetch ensembl ID)
  73418 total

'''
 comm -12 ensemblIDs_of_hugogenes.txt ensemblIDs_v97_HUGO_genenamebased.txt | wc -l
35264 --> shared

 comm -23 ensemblIDs_of_hugogenes.txt ensemblIDs_v97_HUGO_genenamebased.txt | wc -l
784 --> unique to ensembl IDs of hugo genes

 comm -23 ensemblIDs_v97_HUGO_genenamebased.txt ensemblIDs_of_hugogenes.txt | wc -l
2106 --> ensembl IDS fetched from gtf file because names matched and these do not exist as ensembliDs in hugo download (HUGO-custom-without-synm.txt)

 cat ensemblIDs_of_hugogenes.txt ensemblIDs_v97_HUGO_genenamebased.txt | sort | uniq | wc -l
38154


cat ensemblIDs_of_hugogenes.txt ensemblIDs_v97_HUGO_genenamebased.txt | sort | uniq > v97_MERGED_ensemblIDs_name_synonym_ensembl_HUGO.txt

'''
## Some genes have synonyms but not written in HUGO. SO some genes exist in GTF file with another synonym, and exist in the HUGO gene file too, but with their NCBI names ( such as GNG8) instead of ensembl ACXXXX.X nomenclature. 
## Therefore when we search for GNG8 in ensembl GTF, it does not show it to us. So these genes will not be used because of there are no consensus in their gene gene_names in between HUGO and ENSEMBL, therefore they get lost, and it is not possible to due it manually.
## Unfortunately, for the time being, I have to accept this as a nomenclature limitation.
'''

#example:
grep 'GNG8' HUGO-custom-without-synm.txt 
HGNC:19664      GNG8    Approved


grep 'GNG8' geneID_name_info_Ensembl97.txt
# no result

grep 'ENSG00000167414' geneID_name_info_Ensembl97.txt
ENSG00000167414 AC093503.1      19:46634076-46634685    protein_coding  -


## I will extract the GTF file to filter it with HUGO approved genes only

cat v97_MERGED_ensemblIDs_name_synonym_ensembl_HUGO.txt | while read LINE; do echo $LINE; grep -wi $LINE Homo_sapiens.GRCh38.97.gtf  >> HUGO/HUGO_V97_Homo_sapiens.GRCh38.97_HUGO-filtered.gtf;  done