# VISUALIZING METHANOSAETA OLIGOTYPES IN THE TRANSECT
#TRANSECT PAPER - DADA2 NO PRIMERS OUTPUT

#load libraries and color palettes
library(phyloseq)
library(ggplot2)
library(vegan)
library(tidyr)
library(dplyr)

mod2_cols = c("#AF8DC3","#E7D4E8","#D9F0D3","#7FBF7B","#1B7837","#FFFFBF",
              "#FC8D59","#2166AC","#3288BD","#D73027","#053061","#D6604D",
              "#F4A582","#DA026C","#BBB000","#B98765","#DDD000",
              "#AAAAFF","#606060","#0000AA","#AACC00","#B99999","red","#F0027F")

mod1_cols = c("#E6AB02","#FFFF33","#A6761D","#FDBF6F","#386CB0","#B3B3B3","#A6D854","#BF5B17","#FCCDE5",
              "#FC8D62","#FBB4AE","#33A02C","#E7298A","#FDCDAC","#FFED6F","#D9D9D9","#F0027F","#66C2A5",
              "#A65628","#8DD3C7","#B3E2CD", "#000998")

modQ_cols2 = c("#8DD3D7","#D6601D","#414487ff","#AA4266","#54c568ff","#1f9bff",
               "#006400","#7393B3","#1287BD","purple","#B7D6F8",
               "#440154ff","#9FBF7B","#DA029C","#002100","#654321","#B26755","#FFFF33",
               "#AAAAFF","#808080","#00004A","#AACC00","#0000FF","orange","pink","#800000")


## LOAD IN DATA FILES
setwd("/Users/quincydowling/Library/CloudStorage/OneDrive-MarineBiologicalLaboratory/Bioinformatics/DOE-HOTSPOTS/Dada2_noprimers/TRANSECT-OLIGOTYPING/Methanothrix/Final_output/")
dat = read.table("Methanothrix-MATRIX-COUNT-phyloseq.txt", header = TRUE, row.names = 1, sep = '\t')
tdat = read.table("Methanothrix-final-NODE-HITS-WITH-TAX.txt", header = TRUE, row.names = 1, sep = '\t')
mdat = read.table("seqtab-MERGED-Av4v5-METADATA-Methanothrix.txt", header = TRUE, row.names = 1, sep = '\t')

## convert the occurrence table to a matrix
pfmat <- as.matrix(dat)
## convert the Mag metadata to a matrix
pftax <- as.matrix(tdat)

## convert the matrices to phyloseq input formats
OTU <- otu_table(pfmat, taxa_are_rows = TRUE)
TAX <- tax_table(pftax)
meta <- sample_data(mdat)


## Create the PHYLOSEQ OBJECT
physeq <- phyloseq(OTU, TAX, meta)

#subset data for just the transect samples
ps.transect <- subset_samples(physeq, experiment == "transect")


#transform data to % relative abundance and remove low abundance taxa
ps.per <- transform_sample_counts(ps.transect, function(OTU) OTU/sum(OTU)*100)
ps.abund <- filter_taxa(ps.per, function(x) sum(x) > 2, TRUE)

# order the boards correctly in the transect - or if you want to plot by distance, order the distance values
#sample_data(ps.abund)$distance = factor(sample_data(ps.abund)$distance, levels = c("0", "3", "6", "9", "18", "24", "30", "36", "42", "48", "54"))
sample_data(ps.abund)$name = factor(sample_data(ps.abund)$name, levels = c("board1", "board2", "board3", "board4", "board7","board9","board11", "board13","board15", "board17", "board19"))


# had to custom order the color palette to match the second barplot (percent of archaeal reads)
# colors are ordered based on the order of this plot's legend, but matching legend of the plot below which used the mod2_cols palette

pdf("/Users/quincydowling/Library/CloudStorage/OneDrive-MarineBiologicalLaboratory/Bioinformatics/DOE-HOTSPOTS/Dada2_noprimers/Transect-paper-figures/methanothrix_relabund_boardno.pdf")

plot_bar(ps.abund, x = "name",fill = "ASV.1")+
  scale_fill_manual(values = modQ_cols2)+
  theme_classic()+
  theme(axis.text.x = element_text(angle = 30, vjust = 0.5, hjust = 1))+
  scale_y_continuous(expand = c(0, 0))+
  xlab("Transect board number")+
  ylab("Relative Abundance")

dev.off()



# BAR PLOT - PERCENT OF ARCHAEAL READS


perc_seq_reads <- read.table("/Users/quincydowling/Library/CloudStorage/OneDrive-MarineBiologicalLaboratory/Bioinformatics/DOE-HOTSPOTS/Dada2_noprimers/FINAL-methanothrix-transect-percAv4v5reads_boardno.txt",sep = '\t',header = TRUE)

#melts the file according to two variables
perc_seq_reads_melted <- melt(perc_seq_reads, id=c("samples","distance"))

#orders the boards correctly for this dataframe
perc_seq_reads_melted$distance = factor(perc_seq_reads_melted$distance, levels = c("Board_1", "Board_2", "Board_3", "Board_4", "Board_7","Board_9","Board_11","Board_13","Board_15", "Board_17", "Board_19"))

#ordered to make the two plots match
modQ_cols_ordered = c("#7393B3","#1287BD","purple","#B7D6F8","#00004A","#006400","#8DD3D7","#440154ff","#D6601D","#9FBF7B",
               "#414487ff","#DA029C","#002100","#AA4266","#654321","#54c568ff","#B26755","#FFFF33","#1f9bff",
               "#AAAAFF","#808080")



#pdf and dev.off() commands export your figure to the provided directory

pdf("/Users/quincydowling/Library/CloudStorage/OneDrive-MarineBiologicalLaboratory/Bioinformatics/DOE-HOTSPOTS/Dada2_noprimers/Transect-paper-figures/Methanothrix_reads_boardno.pdf")

ggplot(perc_seq_reads_melted, aes(x=distance,y=value,fill=variable))+
  geom_bar(stat="identity", color="black")+
  theme_classic()+
  scale_fill_manual(values = modQ_cols_ordered)+
  theme(axis.text.x = element_text(angle = 30, vjust = 0.5, hjust = 1))+
  ylim(0, NA)+
  scale_y_continuous(expand = c(0, 0))+
  #scale_x_continuous(breaks = unique(perc_seq_reads_melted$distance))+
  xlab("Transect board number")+
  ylab("% Relative Abundance")


dev.off()



