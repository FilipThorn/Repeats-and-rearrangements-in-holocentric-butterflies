library(ggplot2)

setwd("~/Downloads")

cnv.cf.df.out<-read.table("segDup.all_plus_out.inds_ratio.txt")
colnames(cnv.cf.df.out)<-c("Chromosome", "Start", "Ratio", "Median_ratio", "Dosage", "ID", "Sampgroup", "Sampgroup2")
cnv.cf.df.out$Comb_ID_MSG <- paste(cnv.cf.df.out$Sampgroup2, cnv.cf.df.out$Sampgroup, cnv.cf.df.out$ID, sep="_")


cnv.cf.df.out$Chr_num <- as.numeric(gsub("Chr_", "", cnv.cf.df.out$Chromosome))

for(i in 1:48){
  ggplot(cnv.cf.df.out[cnv.cf.df.out$Chr_num==i & cnv.cf.df.out$Dosage != 2 & !grepl("duponcheli", cnv.cf.df.out$Comb_ID_MSG) ,],
         aes(y=Comb_ID_MSG, col=Dosage))+
    scale_color_gradientn(colors=colorRampPalette(c("white", "orange", "red", "brown"))(20),
                          limits = c(0, 10),   # cap scale at 10
                          oob = scales::squish)+  # values above 10 get "squished" to 10's color
    #coord_cartesian(xlim=c(8.5e6, 9.5e6))+
    theme_dark()+
    ggtitle(paste("Chromosome", i, sep="_"))+
    theme(axis.text.y = element_text(size=5))+
    geom_segment(aes(x = Start, xend = Start+9999, y = Comb_ID_MSG, yend = Comb_ID_MSG), size = 1.2)
  
  ggsave(paste(i, "cnv.cf.pdf", sep="."))
}


i=12
cnv.cf.df.out$Comb_ID_MSG<-ifelse(grepl("morsei", cnv.cf.df.out$Comb_ID_MSG) ==T, paste("a", cnv.cf.df.out$Comb_ID_MSG, sep="_"), cnv.cf.df.out$Comb_ID_MSG)
cnv.cf.df.out$Comb_ID_MSG<-ifelse(grepl("amurensis", cnv.cf.df.out$Comb_ID_MSG) ==T, paste("b", cnv.cf.df.out$Comb_ID_MSG, sep="_"), cnv.cf.df.out$Comb_ID_MSG)
cnv.cf.df.out$Comb_ID_MSG<-ifelse(grepl("lactea", cnv.cf.df.out$Comb_ID_MSG) ==T, paste("c", cnv.cf.df.out$Comb_ID_MSG, sep="_"), cnv.cf.df.out$Comb_ID_MSG)


ggplot(cnv.cf.df.out[cnv.cf.df.out$Chr_num==i & cnv.cf.df.out$Dosage != 2 & !grepl("duponcheli", cnv.cf.df.out$Comb_ID_MSG) ,],
       aes(y=Comb_ID_MSG, col=Dosage))+
  scale_color_gradientn(colors=colorRampPalette(c("white", "orange", "red", "brown"))(20),
                        limits = c(0, 10),   # cap scale at 10
                        oob = scales::squish)+  # values above 10 get "squished" to 10's color
  coord_cartesian(xlim=c(7.5e6, 9e6))+
  theme_dark()+
  ggtitle(paste("Chromosome", i, sep="_"))+
  theme(axis.text.y = element_text(size=5))+
  geom_segment(aes(x = Start, xend = Start+9999, y = Comb_ID_MSG, yend = Comb_ID_MSG), size = 1.2)
