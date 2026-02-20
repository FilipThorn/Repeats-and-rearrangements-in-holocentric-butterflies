setwd("~/Downloads")
library(scales)
library(wesanderson)
library(ggplot2)

odds.df<-read.table("All.stats_EBRs.v5.tsv")

colnames(odds.df)<-c("Group2_fraction_of_genome", "Group1_fraction_of_genome", "Overlap_bp", "Odds_ratio", "Pval", "Comparison")

odds.df$Group1 <- sapply(strsplit(odds.df$Comparison, "\\.v\\."), `[`, 1)
odds.df$Group2 <- sapply(strsplit(odds.df$Comparison, "\\.v\\."), `[`, 2)

odds_col <- wes_palette("Cavalcanti1")

odds.df$Bonferroni_p <- odds.df$Pval*13

odds.df$Significance <- ifelse(odds.df$Bonferroni_p < 0.05, "Y", "N")
odds.df[odds.df$Comparison == "EBRs_Fis.v5.v.rDNA.all",]$Odds_ratio<-0.1

odds.df$FDR_p <- NA
odds.df[odds.df$Group1 == "EBRs_Fis.v5",]$FDR_p <- p.adjust(odds.df[odds.df$Group1 == "EBRs_Fis.v5",]$Pval,  method="BH")
odds.df[odds.df$Group1 == "EBRs_Fus.v5",]$FDR_p <- p.adjust(odds.df[odds.df$Group1 == "EBRs_Fus.v5",]$Pval,  method="BH")
odds.df[odds.df$Group1 == "EBRs_Tra.v5",]$FDR_p <- p.adjust(odds.df[odds.df$Group1 == "EBRs_Tra.v5",]$Pval,  method="BH")
odds.df$Significance <- ifelse(odds.df$FDR_p < 0.05, "Y", "N")


#Renaming
odds.df$Annotation_short <- odds.df$Group2
odds.df$Annotation_short <- gsub("rDNA.all", "rDNA", odds.df$Annotation_short)
odds.df$Annotation_short <- gsub("satellites", "Satellites", odds.df$Annotation_short)
odds.df$Annotation_short <- gsub("allChrs.largeSD.lessThan50percentSats", "Segmental duplications", odds.df$Annotation_short)
odds.df$Annotation_short <- gsub("Telomere_5mer", "Telomere 5mer", odds.df$Annotation_short)
odds.df$Annotation_short <- gsub("fixedDiff200bp", "Fixed differences", odds.df$Annotation_short)
odds.df$Annotation_short <- gsub("Unknown_repeats", "Unknown repeats", odds.df$Annotation_short)
odds.df$Annotation_short <- gsub("DNA_transposons", "DNA transposons", odds.df$Annotation_short)
odds.df$Annotation_short <- gsub("Low_complexity", "Low complexity", odds.df$Annotation_short)
odds.df$Annotation_short <- gsub("protein_coding_genes", "Protein-coding genes", odds.df$Annotation_short)
odds.df$Annotation_short <- gsub("simple_repeats", "Simple repeats", odds.df$Annotation_short)

odds.df$EBR_type <- odds.df$Group1
odds.df$EBR_type <- gsub("EBRs_Fis.v5", "Fissions", odds.df$EBR_type)
odds.df$EBR_type <- gsub("EBRs_Fus.v5", "Fusions", odds.df$EBR_type)
odds.df$EBR_type <- gsub("EBRs_Tra.v5", "Translocations", odds.df$EBR_type)


ggplot(odds.df[!grepl("CNV", odds.df$Group2),], aes(x = log10(Odds_ratio), y = reorder(Annotation_short, Odds_ratio), col=EBR_type, shape=Significance)) + 
  geom_vline(aes(xintercept = 0), size = .25, linetype = "dashed") + 
  scale_shape_manual(values=c(4,16))+
  scale_color_manual(name="EBR type", values = c(odds_col[5], odds_col[1], odds_col[4]) ) +
  geom_point(size=3.5) +
  scale_x_continuous(breaks = log10(seq(0, 10, 1)), labels = seq(0, 10, 1),
                     limits = log10(c(0.1,10))) +
  theme_bw()+
  scale_alpha(range = c(0.8, 0))+
  scale_size(range = c(5, 1))+
  theme(panel.grid.minor = element_blank()) +
  ylab("") +
  xlab("Odds ratio")+
  #facet_wrap(~Group1, nrow=3, ncol=1)+
  theme(legend.position="right", strip.background = element_blank(), strip.text.x = element_text(size=14), plot.title = element_text(face = "bold", hjust = 0.5),  panel.border = element_rect(colour = "black", fill=NA, size=1), axis.text=element_text(size=12, colour="black"), axis.title=element_text(size=14), legend.text=element_text(size=12),  legend.title=element_text(size=14))
