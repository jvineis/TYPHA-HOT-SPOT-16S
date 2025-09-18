##Bubble plots for oligotyping
#dada2 no primers
#transect paper

#Bubble plots

#first have to pivot longer the data
library(phyloseq)
library(ggplot2)
library(vegan)
library(tidyr)
library(dplyr)


# STARTING WITH METHANOTHRIX

#read in csv of the matrix counts transformed as a percent of total archaeal reads for each sample
df <- read.csv("/Users/quincydowling/Library/CloudStorage/OneDrive-MarineBiologicalLaboratory/Bioinformatics/DOE-HOTSPOTS/Dada2_noprimers/methanothrix-transect-percAreads.csv")


#pivot longer 
long.data <- df %>%
  pivot_longer(cols = c(2:ncol(df)), #indexes column 2 through the last one
               names_to = "sample", #What to call your new categorical column 
               values_to = "rel.abundance") #What to call your new numerical column


#sort by sample - not needed
#long.data <- long.data[order(long.data$sample, decreasing = TRUE),]

#Save a csv file to your directory
write.csv(long.data, file = "/Users/quincydowling/Library/CloudStorage/OneDrive-MarineBiologicalLaboratory/Bioinformatics/DOE-HOTSPOTS/Dada2_noprimers/longer_Methanothrix_percreads.csv")

#read in the file
methanothrix.longer <- read.csv("/Users/quincydowling/Library/CloudStorage/OneDrive-MarineBiologicalLaboratory/Bioinformatics/DOE-HOTSPOTS/Dada2_noprimers/longer_Methanothrix_percreads.csv")

#subset to only the oligotypes that show up in the transect
transect.mthrix <- subset(methanothrix.longer, sample =="GGTTAGCTCT"| sample =="GGTCGGCGTC"| sample=="GGCCGGTGTC"| sample=="AGTTAGCTCT"| sample=="AGTTAGTTCT"| sample =="AGCTAGCTCT")

#using these colors to create scale_fill_manual in figure below
#modQ_cols_mini = c("#8DD3D7","#D6601D","#414487ff","#AA4266","#54c568ff","#1f9bff")
#"AGCTAGCTCT"="#8DD3D7","AGTTAGCTCT"="#D6601D","AGTTAGTTCT"="#414487ff","GGCCGGTGTC"="#AA4266","GGTCGGCGTC"="#54c568ff","GGTTAGCTCT"="#1f9bff"

#order the boards correctly
transect.mthrix$distance = factor(transect.mthrix$distance, levels = c("Board_1", "Board_2", "Board_3", "Board_4", "Board_7","Board_9","Board_11","Board_13","Board_15", "Board_17", "Board_19"))

pdf("/Users/quincydowling/Desktop/OneDriveMBL/Bioinformatics/DOE-HOTSPOTS/Dada2_noprimers/Transect-paper-figures/methanothrix-bubbleplot.pdf")

               
ggplot(transect.mthrix, aes(x=distance,y=sample,size =ifelse(rel.abundance==0,NA,rel.abundance), color = sample))+
  geom_point(aes(fill=sample),shape=21,color = "black")+
  theme_classic()+
  #scale_color_manual(values = modQ_cols_mini)+
  scale_fill_manual(values = c("AGCTAGCTCT"="#8DD3D7","AGTTAGCTCT"="#D6601D","AGTTAGTTCT"="#414487ff","GGCCGGTGTC"="#AA4266","GGTCGGCGTC"="#54c568ff","GGTTAGCTCT"="#1f9bff"))+
  scale_size(range = c(1,10))+
  theme(legend.position = "right")+
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_blank()
  )+
  xlab("Transect board number")+
  theme(axis.text.x = element_text(angle = 30, vjust = 0.5, hjust = 1))+
  #scale_x_continuous(breaks = unique(perc_seq_reads_melted$distance))+
  labs(
    y = expression(
      paste("Oligotypes in ",
            italic("Methanothrix "),
            "genus")))

dev.off()







# NOW METHANOSARCINA

#read in csv of the percent of archaeal reads transformed data
df <- read.csv("/Users/quincydowling/Library/CloudStorage/OneDrive-MarineBiologicalLaboratory/Bioinformatics/DOE-HOTSPOTS/Dada2_noprimers/Methanosarcina_transect_percreads.csv")

#pivot longer 
long.data <- df %>%
  pivot_longer(cols = c(2:ncol(df)), #indexes column 2 through the last one
               names_to = "sample", #What to call your new categorical column 
               values_to = "rel.abundance") #What to call your new numerical column


#sort by sample - not needed
#long.data <- long.data[order(long.data$sample, decreasing = TRUE),]

#Save a csv file
write.csv(long.data, file = "/Users/quincydowling/Library/CloudStorage/OneDrive-MarineBiologicalLaboratory/Bioinformatics/DOE-HOTSPOTS/Dada2_noprimers/longer_Methanosarcina_percreads.csv")

#read in the file
Msarcina.longer <- read.csv("/Users/quincydowling/Library/CloudStorage/OneDrive-MarineBiologicalLaboratory/Bioinformatics/DOE-HOTSPOTS/Dada2_noprimers/longer_Methanosarcina_percreads.csv")

#subset because some of the oligotypes don't appear in the transect, only in temporal samples, so we don't need those in this figure
transect.msarcina <- subset(Msarcina.longer, sample =="CCGACAGG"| sample =="CCGGCAGG"| sample=="CTGACAGA"| sample=="CTGACAGG"| sample=="CTGGCGGG"| sample =="CTGGTGGG" |sample =="TCAACAGG"| sample =="TCAGCAAG"| sample=="TCAGCAGG"| sample=="TCAGCGGG"| sample=="TTAGCGGG")

#order the boards correctly
transect.msarcina$distance = factor(transect.msarcina$distance, levels = c("Board_1", "Board_2", "Board_3", "Board_4", "Board_7","Board_9","Board_11","Board_13","Board_15", "Board_17", "Board_19"))


#used these colors in this order to make the scale_fill_manual setting in the graph below
#mod3_cols_mini = c("#053061","#FFFFBF","#FC8D59","#1B7837","#AF8DC3","#2166AC","#7FBF7B","#D73027","#E7D4E8","#3288BD","#D9F0D3","#D6604D","#F4A582")
#"CCGACAGG"="#053061","CCGGCAGG"="#FFFFBF","CTGACAGA"="#FC8D59","CTGACAGG"="#1B7837","CTGGCGGG"="#AF8DC3","CTGGTGGG"="#2166AC","TCAACAGG"="#7FBF7B","TCAGCAAG"="#D73027","TCAGCAGG"="#E7D4E8","TCAGCGGG"="#3288BD","TTAGCGGG"="#D9F0D3")



pdf("/Users/quincydowling/Desktop/OneDriveMBL/Bioinformatics/DOE-HOTSPOTS/Dada2_noprimers/Transect-paper-figures/methanosarcina-bubbleplot.pdf")

ggplot(transect.msarcina, aes(x=distance,y=sample,size =ifelse(rel.abundance==0,NA,rel.abundance), color = sample))+
  geom_point(aes(fill=sample),shape=21,color = "black")+
  theme_classic()+
  #scale_color_manual(values = mod3_cols_mini)+
  scale_fill_manual(values = c("CCGACAGG"="#053061","CCGGCAGG"="#FFFFBF","CTGACAGA"="#FC8D59","CTGACAGG"="#1B7837","CTGGCGGG"="#AF8DC3","CTGGTGGG"="#2166AC","TCAACAGG"="#7FBF7B","TCAGCAAG"="#D73027","TCAGCAGG"="#E7D4E8","TCAGCGGG"="#3288BD","TTAGCGGG"="#D9F0D3"))+
  scale_size(range = c(1,10))+
  theme(legend.position = "right")+
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_blank()
  )+
  xlab("Transect board number")+
  theme(axis.text.x = element_text(angle = 30, vjust = 0.5, hjust = 1))+
  #scale_x_continuous(breaks = unique(perc_seq_reads_melted$distance))+
  labs(
    y = expression(
      paste("Oligotypes in ",
            italic("Methanosarcina "),
            "genus")))

dev.off()







