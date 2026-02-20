library(gtools)
library(wesanderson)
setwd("~/Downloads")

bp.df<-read.table(file=file.choose(), header=T)

bp.df$Chromosome <- factor(bp.df$Chromosome, levels=rev(mixedsort(unique(bp.df$Chromosome))))
  
faidx<-read.table(file="Lsin_DToL.fasta.fai")
faidx<-faidx[,1:2]
colnames(faidx)<-c("Chromosome", "End")
faidx$Start <- 1
faidx$Chromosome <- factor(faidx$Chromosome, levels=rev(mixedsort(unique(faidx$Chromosome))))

odds_col <- wes_palette("Cavalcanti1")

ggplot(bp.df)+
  theme_bw()+
  geom_segment(data=faidx, aes(x = Start, xend = End, y = Chromosome, yend = Chromosome), size = 3, alpha=0.2 )+
  geom_segment(aes(x = Start, xend = End, y = Chromosome, yend = Chromosome, col=Rearrangement_type), alpha=0.8, size = 5)+
  scale_color_manual(name="EBR_type", values = c(odds_col[5], odds_col[1], odds_col[4]) ) +
  xlab("Position")+
  facet_wrap(~Rearrangement_type, ncol = 3, scales = "free_x")+
  theme(strip.text=element_blank(), legend.position = "right", plot.title = element_text(face = "bold", hjust = 0.5), axis.text=element_text(size=14, colour="black"), axis.title=element_text(size=16), legend.text=element_text(size=14),  legend.title=element_text(size=16))

