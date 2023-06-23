install.packages("data.table")
library(data.table) ## one of the best packages ever! I strongly recommend.
RNA.Pri <- data.table(read.table("/FEATURECOUNTS/EXON/cleaned_NOPRIMARY_EXON_COUNTS_H9_RNASEQ_TX_LEVEL_rsemconverted.txt", header = TRUE))
RPF.3utr.Pri <- data.table(read.table("/FEATURECOUNTS/3UTR/cleaned_NOPRIMARY_3UTR_COUNTS_H9_RPF_TX_LEVEL_rsemconverted.txt", header = TRUE))
RPF.5utr.Pri <- data.table(read.table("/FEATURECOUNTS/5UTR/cleaned_NOPRIMARY_5UTR_COUNTS_H9_RPF_TX_LEVEL_rsemconverted.txt", header = TRUE))
RPF.Pri <- data.table(read.table("/FEATURECOUNTS/EXON/cleaned_NOPRIMARY_EXON_COUNTS_H9_RPF_TX_LEVEL_rsemconverted.txt", header = TRUE))
head(RNA.Pri)
head(RPF.5utr.Pri)
head(RPF.3utr.Pri)
head(RPF.Pri)
RPF.Pri <- RPF.Pri[ ,c(1,5,6,7,2,3,4)]
RPF.3utr.Pri <- RPF.3utr.Pri[ ,c(1,5,6,7,2,3,4)]
RPF.5utr.Pri <- RPF.5utr.Pri[ ,c(1,5,6,7,2,3,4)]
RNA.Pri <- RNA.Pri[ ,c(1,5,6,7,2,3,4)]
head(RPF.Pri)
head(RNA.Pri)
head(RPF.3utr.Pri)
head(RPF.5utr.Pri)
matchingCols <- c("Transcript_id")
mergingCols <- names(RPF.Pri)[2:7]
mergingCols
RPF.exon.sub3utr <-
RPF.Pri[
  RPF.3utr.Pri,
  on=matchingCols, 
  lapply(
    setNames(mergingCols, mergingCols),
    function(x) get(x) - get(paste0("i.", x))
  ),
  nomatch=0L,
  by=.EACHI
]
head(RPF.exon.sub3utr)
dim(RPF.exon.sub3utr)
tail(RPF.exon.sub3utr)
tail(RPF.Pri)
tail(RPF.3utr.Pri)

RPF.exon.sub3utr5utr <-
RPF.exon.sub3utr[
  RPF.5utr.Pri,
  on=matchingCols, 
  lapply(
    setNames(mergingCols, mergingCols),
    function(x) get(x) - get(paste0("i.", x))
  ),
  nomatch=0L,
  by=.EACHI
]
dim(RPF.exon.sub3utr5utr)
head(RPF.exon.sub3utr5utr)
head(RPF.exon.sub3utr)
colnames(RPF.exon.sub3utr5utr)
mergedTable.integer.PC <- merge(RNA.Pri, RPF.exon.sub3utr5utr, by = "Transcript_id")
dim(mergedTable.integer.PC)
head(mergedTable.integer.PC)
head(RPF.exon.sub3utr5utr)
head(RNA.Pri,)
head(mergedTable.integer.PC)
keep <- rowMeans(mergedTable.integer.PC[ ,2: 4, drop = FALSE]) > 3 & rowMeans(mergedTable.integer.PC[ ,5: 7, drop = FALSE]) > 3 & rowMeans(mergedTable.integer.PC[ ,8: 10, drop = FALSE]) > 3 & rowMeans(mergedTable.integer.PC[ ,11: 13, drop = FALSE]) > 3
mergedTable.integer.PC.filtered <- mergedTable.integer.PC[keep,]
dim(mergedTable.integer.PC.filtered)
write.table(mergedTable.integer.PC.filtered, file = "mergedTable_EXON-CDS-sub3UTR-sub5utr.txt", sep = "\t",row.names = FALSE, col.names = TRUE)
savehistory("RNASEQ-EXON_RPF-EXON-UTRS-TXTOGENOME.R")
