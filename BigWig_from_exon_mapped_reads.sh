############ RPF ################
echo "This step will give exon counted bam files for RPF and RNASEQ which are required for Deeptools analyses"

grep 'Assigned' $basefilename.bam.featureCounts | cut -f1 | sort | uniq > exon_mapped_$basefilename.bam.featureCounts
python exctract_reads.py -b $mfile -n exon_mapped_$basefilename.bam.featureCounts -o exon_counted_$basefilename.bam

############ RPF ################
## calculate bamCoverage with and without offsets , with CPM, RPKM and REGULAR
samtools index sorted_$basefilename.bam
bamCoverage -p 12 --binSize 1 --normalizeUsing CPM -b sorted_$basefilename.bam -o noofset_CPM_$basefilename.bigWig
bamCoverage -p 12 --Offset 12 --binSize 1 --normalizeUsing CPM -b sorted_$basefilename.bam -o offset_12_CPM_$basefilename.bigWig
bamCoverage -p 12 --Offset 12 --binSize 1 --normalizeUsing RPKM -b sorted_$basefilename.bam -o offset_12_RPKM_$basefilename.bigWig
bamCoverage -p 12 --binSize 1 -b sorted_$basefilename.bam -o nooffset_REGULAR_$basefilename.bigWig
bamCoverage -p 12 --Offset 12 --binSize 1 -b sorted_$basefilename.bam -o offset_12_REGULAR_$basefilename.bigWig


## WIG TO BIGWIG conversion (requires genome.size folder)
cut -f1,2 Homo_sapiens.GRCh38.dna.primary_assembly.fa.fai > Genome.size
wigToBigWig $mfile Genome.size $basefilename.bigWig


############ RNASEQ ################
samtools index sorted_$basefilename.bam
bamCoverage -p 12 --binSize 1 --normalizeUsing CPM -b sorted_$basefilename.bam -o noofset_CPM_$basefilename.bigWig
bamCoverage -p 12 --binSize 1 --normalizeUsing RPKM -b sorted_$basefilename.bam -o nooffset_RPKM_$basefilename.bigWig
bamCoverage -p 12 --binSize 1 -b sorted_$basefilename.bam -o nooffset_REGULAR_$basefilename.bigWig


## Merge them
cd BIGWIGS
echo "nooffset REGULAR"
wiggletools write total.wig $firstfile.bigWig $secondfile.bigWig $thirdfile.bigWig

#wig to bigwig
wigToBigWig $mfile Genome.size total.wig 