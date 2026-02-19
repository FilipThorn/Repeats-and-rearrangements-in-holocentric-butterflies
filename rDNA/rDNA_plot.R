library(ggplot2)

setwd("~/Downloads")

faidx<-read.table(file="Lsin_DToL.fasta.fai")
faidx<-faidx[,1:2]
colnames(faidx)<-c("Chromosome", "End")
faidx$Start <- 1
faidx$Chr_num <- gsub("Chr_", "", faidx$Chromosome)
faidx$Chr_num <- as.numeric(faidx$Chr_num)

rDNA.df<-read.table(file="barrnap.DToL.output", sep="\t")
colnames(rDNA.df)<-c("Chromosome", "Software", "Annotation", "Start", "End", "E-value", "Orientation", "Phase", "Comment")

rDNA.df$Chr_num <- gsub("Chr_", "", rDNA.df$Chromosome)
rDNA.df$Chr_num <- as.numeric(rDNA.df$Chr_num )

rDNA.df$Type <- gsub("Name=(.*rRNA);.*", "\\1", rDNA.df$Comment)
rDNA.df$Structure <- ifelse(grepl("partial", rDNA.df$Comment), "Partial", "Complete")


ggplot(rDNA.df, aes(y=Chr_num))+
  theme_classic()+
  ylab("Chromosome")+
  xlab("Position")+
  scale_color_manual(name="Type", values = c( "orange", "red","purple", "olivedrab3")) +
  geom_segment(data=faidx, aes(x = Start, xend = End, y = Chr_num, yend = Chr_num), size = 3, lineend="round", alpha=0.2 )+
  geom_segment(aes(x = Start, xend = End, y = Chr_num, yend = Chr_num, col=Type), size = 5)+
  theme(legend.position = "right", plot.title = element_text(face = "bold", hjust = 0.5), axis.text=element_text(size=12, colour="black"), axis.title=element_text(size=14), legend.text=element_text(size=12),  legend.title=element_text(size=14))
