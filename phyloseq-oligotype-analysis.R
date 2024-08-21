library(ggplot2)
library(phyloseq)
library(vegan)
library("viridis")    
library("randomForest")
library("dplyr")
library("knitr")
dat = read.table("~/Documents/DOE-HOT-TYPHA/TRANSECT-2023-16S/ZC_SWAB_Av4v5/VAMPS-Av4v5/FINAL-METHANOSARCINA-OLIGOTYPING/MATRIX-COUNT.txt", header = TRUE, row.names = 1, sep = '\t')
tdat = read.table("~/Documents/DOE-HOT-TYPHA/TRANSECT-2023-16S/ZC_SWAB_Av4v5/VAMPS-Av4v5/FINAL-METHANOSARCINA-OLIGOTYPING/NODE-HITS-with-taxa.txt", header = TRUE, row.names = 1, sep = '\t')
mdat = read.table("~/Documents/DOE-HOT-TYPHA/TRANSECT-2023-16S/samples-for-phyloseq.txt", header = TRUE, row.names = 1, sep = '\t')

## convert the occurrence table to a matrix
pfmat <- as.matrix(dat)
## convert the Mag metadata to a matrix
pftax <- as.matrix(tdat)

## convert the matrices to phyloseq input formats
OTU <- otu_table(pfmat, taxa_are_rows = TRUE)
TAX <- tax_table(pftax)
meta <- sample_data(mdat)

## Create the phyloseq object
physeq <- phyloseq(OTU, TAX, meta)

sample_data(physeq)$transect = factor(sample_data(physeq)$transect, levels = c("SED1","SED2","SED3","SED4", "SED5", "SED6", "SED7","SED12","SED8","SED11","SED10"))

physeq1 = transform_sample_counts(physeq, function(x) x/sum(x)*100)

library(RColorBrewer)
n <- 23
qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
pie(rep(1,n), col=sample(col_vector, n))
colors_for_plot <- sample(col_vector, n)

sample_data(physeq1)$transect = factor(sample_data(physeq1)$transect, levels = c("SED1","SED2","SED3","SED4", "SED5", "SED6", "SED7","SED12","SED8","SED11","SED10"))
plot_bar(physeq1, x = "transect",fill = "MED_NODE")+
  scale_fill_manual(values = colors_for_plot)

plot_bar(physeq, x = "transect",fill = "MED_NODE")+
  scale_fill_manual(values = colors_for_plot)
