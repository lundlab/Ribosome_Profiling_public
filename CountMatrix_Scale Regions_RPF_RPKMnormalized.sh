######### SCALE REGIONS : ALL

RPKM_nooffset_KO="mean_nooffset_RPKM_KO_RP.bigWig"
RPKM_nooffset_WT="mean_nooffset_RPKM_WT_RP.bigWig"

## ALL / UP / DOWN / NS
computeMatrix scale-regions --scoreFileName $RPKM_nooffset_KO $RPKM_nooffset_WT --regionsFileName $gtf_path TL_"$regulation".gtf --beforeRegionStartLength 100 --afterRegionStartLength 100 --regionBodyLength 100 --binSize 1 -o "$filename".gz --smartLabels --numberOfProcessors 10 --metagene --exonID CDS --verbose

plotProfile --matrixFile "$filename".gz --outFileName "$filename".pdf --plotType lines --colors red green --plotTitle "RPKM CDS" --perGroup --legendLocation best  --plotFileFormat pdf  --verbose

# FOOTNOTE: For the first time, there is one TX having minus counts in the CDS ( count_exon < count_utrs by 5). The TX was ENST00000242505.
# I deleted it for further analyses.
