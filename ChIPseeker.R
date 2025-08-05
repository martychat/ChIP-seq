
BiocManager::install(c("ChIPseeker", "GenomicFeatures", "txdbmaker"))

library(GenomicFeatures)
library(ChIPseeker)

#Converts gtf to TxDb object for Granges
txdb <- makeTxDbFromGFF("//workdir/Martik/ChIP/Msexta_babChIP/genomic.gff", format="gff3") 

# Load peaks
peak <- readPeakFile("//workdir/Martik/ChIP/Msexta_babChIP/Oct24/peakcalls_without_downsizing/IDR_with_Rep2_Rep3/Msexta_bab_rep2_rep3_idr_threshold05.bed")

# Annotate peaks
peakAnno <- annotatePeak(peak, TxDb=txdb, tssRegion=c(-3000,3000))

# Summary plots when using Rstudio
plotAnnoPie(peakAnno)                # Pie chart: promoter/intron/intergenic
plotAnnoBar(peakAnno)                # Bar plot
plotDistToTSS(peakAnno, title="Distance to TSS")

#Summary plots when using non-graphic R

# Assuming peakAnno object is ready

# 1. Pie chart
pdf("annotation_pie.pdf", width=6, height=6)
plotAnnoPie(peakAnno)
dev.off()

# 2. Bar chart
pdf("annotation_bar.pdf", width=6, height=6)
plotAnnoBar(peakAnno)
dev.off()

# 3. Distance to TSS plot
pdf("tss_distribution.pdf", width=7, height=6)
plotDistToTSS(peakAnno, title="Distribution of Peaks Relative to TSS")
dev.off()

# Save annotation table
anno_df <- as.data.frame(peakAnno)
write.csv(anno_df, "Msexta_IDR_peaks_annotation.csv", row.names=FALSE)


You already have all this information in the peakAnno object created by ChIPseeker. Here’s how to extract exactly what you need:

✅ 1. Convert peakAnno to a Data Frame
R
Copy
Edit
anno_df <- as.data.frame(peakAnno)
head(anno_df)
This table usually includes columns like:

seqnames → chromosome

start, end → peak positions

annotation → region type (Promoter, Intron, Exon, Intergenic, etc.)

geneId → gene IDs from your GFF

distanceToTSS → distance from peak to TSS

✅ 2. Find Peaks in Promoters
Filter for annotation containing “Promoter”:

R
Copy
Edit
promoter_peaks <- subset(anno_df, grepl("Promoter", annotation))
Count:

R
Copy
Edit
nrow(promoter_peaks)
✅ 3. Get Genes with Promoter Peaks
Extract unique gene IDs:

R
Copy
Edit
promoter_genes <- unique(promoter_peaks$geneId)
length(promoter_genes)  # How many genes have promoter peaks?
write.table(promoter_genes, "promoter_genes.txt", quote=FALSE, row.names=FALSE, col.names=FALSE)
✅ 4. Full Annotation Table
If you want all peaks with annotation and gene ID:

R
Copy
Edit
write.csv(anno_df, "IDR_peaks_full_annotation.csv", row.names=FALSE)
✅ 5. Summary by Genomic Feature
To see how many peaks fall in each feature type:

R
Copy
Edit
table(anno_df$annotation)
✅ Example Output for Promoter Genes:

scss
Copy
Edit
NC_051138.1   15651961 15652964  Promoter (<=3kb)  LOC12345  -1050
✅ Optional: Visualize
You can plot:

R
Copy
Edit
plotAnnoBar(peakAnno)   # Bar chart of peak distribution by feature
plotAnnoPie(peakAnno)   # Pie chart
👉 Do you want me to give you a complete R script that:

Extracts all peaks with annotations,

Filters promoter-associated peaks,

Outputs two files:

Full annotated peaks table,

Unique promoter gene list
and also creates a summary table of peaks by feature type?
