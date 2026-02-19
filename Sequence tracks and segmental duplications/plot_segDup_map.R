setwd("~/Downloads")
library(ggplot2)
library(gtools)


filtered.SDs.df<-read.table("allChrs.largeSD.lessThan50percentSats.bed")
colnames(filtered.SDs.df)<-c("Chromosome", "Start", "End", "Number_of_sat_overlaps", "A_bases_overlapping", "A_len", "Fraction_of_A_with_cov_from_B" )

filtered.SDs.df$Chromosome <- factor(filtered.SDs.df$Chromosome, levels=rev(mixedsort(unique(filtered.SDs.df$Chromosome))))

faidx<-read.table(file="Lsin_DToL.fasta.fai")
faidx<-faidx[,1:2]
colnames(faidx)<-c("Chromosome", "End")
faidx$Start <- 1
faidx$Chromosome <- factor(faidx$Chromosome, levels=rev(mixedsort(unique(faidx$Chromosome))))


ggplot(filtered.SDs.df)+
  theme_classic()+
  xlab("Position")+
  geom_segment(data=faidx, aes(x = Start, xend = End, y = Chromosome, yend = Chromosome), size = 3, alpha=0.2 )+
  geom_segment(aes(x = Start, xend = End, y = Chromosome, yend = Chromosome), size = 5)+
  
  theme( legend.position = "right", plot.title = element_text(face = "bold", hjust = 0.5), axis.text=element_text(size=14, colour="black"), axis.title=element_text(size=16), legend.text=element_text(size=14),  legend.title=element_text(size=16))

