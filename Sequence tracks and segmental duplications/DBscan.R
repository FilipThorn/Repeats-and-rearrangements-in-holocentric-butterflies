#!/usr/bin/env Rscript

library(ggplot2)
library(dbscan)
args = commandArgs(trailingOnly = TRUE)

Chromosome=args[1]

sim.offset<-read.table(paste("sim.offset", Chromosome, "tsv", sep="."))
colnames(sim.offset)<-c("Start1", "Offset1", "Start2", "Offset2", "Off_diff")



# Try eps from plot
db <- dbscan(sim.offset[,c(1:4)], eps = 250000, minPts = 100)
sim.offset$cluster_dbscan <- factor(ifelse(db$cluster == 0, "noise", paste0("C", db$cluster)))



ggplot(sim.offset[sim.offset$cluster_dbscan != "noise",], aes(x=Start1, y=Offset1, color = cluster_dbscan)) +
  geom_point(size = 2) +
  coord_equal() +
  theme_minimal() +
  labs(title = "DBSCAN clustering")

ggsave(paste("../DB_plots/", Chromosome, ".png", sep=""))


write.table(sim.offset, file=paste("DBSCAN", Chromosome, "tsv", sep="."), col.names = F, quote = F, row.names = F)
