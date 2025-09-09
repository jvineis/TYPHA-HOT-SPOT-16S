# ENV FIT MODELS
# swab v core 5-10 cm July 2024
# Transect Paper

#Environmental fit model is used to determine what factors are significant predictors for archaeal community
#composition in samples taken from 5-10cm at the same site, two replicate cores, in July 2024.
# This test compares two sampling methods - swabbing versus taking a subsection of a sediment core.
# Parallel samples at the same depth are compared between the two methods.

# load necessary packages
library(phyloseq)
library(ggplot2)
library(vegan)

#set directory and load in otu table, taxonomy and metadata
setwd("/Users/quincydowling/Library/CloudStorage/OneDrive-MarineBiologicalLaboratory/Bioinformatics/DOE-HOTSPOTS/Dada2_noprimers")
mdat <- read.table("seqtab-MERGED-Av4v5-METADATA.txt", header = TRUE, row.names = 1, sep = '\t')
TAX <- tax_table(readRDS("seqtab-MERGED-Av4v5-tax_final.rds"))
OTU <- otu_table(readRDS("seqtab-MERGED-Av4v5-final.rds"), taxa_are_rows = FALSE)
pmeta <- sample_data(mdat)

#create phyloseq object
ps <- phyloseq(OTU,pmeta, TAX)

#subset phyloseq object for only swab v core samples 5-10cm from July 24 using column titled "experiment_2" where the flag = "yes"
swabps <- subset_samples(ps, experiment_2 == "yes")

#filtering low abundance asvs out of dataset if abund isn't greater than 5 in 10% of samples
ps.per <- transform_sample_counts(swabps, function(OTU) OTU/sum(OTU)*100)
ps.per.glom <- tax_glom(ps.per, taxrank = "Class")
ps.abund <- filter_taxa(ps.per.glom, function(x) sum(x) > 2, TRUE)

#convert phyloseq object to a matrix
veganotu = function(physeq) {
  require("vegan")
  OTU = otu_table(physeq)
  if (taxa_are_rows(OTU)) {
    OTU = t(OTU)
  }
  return(as(OTU, "matrix"))
}

#creating asv matrix
asvs = veganotu(ps.abund)

#computing distance among samples based on asv abundance
asvs_dist = vegdist(asvs, dist = "robust.aitchinson")

#running non-metric multidimensional scaling on our matrix
asv_mds = metaMDS(asvs_dist)

#create subset of metadata that matches swab v core subset phyloseq object
swabmdat <- subset(mdat, experiment_2 == "yes")


#multivariate analysis - effect of swab v core sampling method
env_mod = envfit(asv_mds~experiment + DNA_cDNA, swabmdat, na.rm=TRUE)
env_mod

env_mod1 = env_mod <- envfit(asv_mds, swabmdat[, c("experiment", "depth", "DNA_cDNA")], na.rm = TRUE)
env_mod1

env_mod2 = envfit(asv_mds~DNA_cDNA*experiment, swabmdat, na.rm=TRUE)
env_mod2




