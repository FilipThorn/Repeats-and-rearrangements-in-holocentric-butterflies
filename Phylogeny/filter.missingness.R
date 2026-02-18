sum<-read.table("../Busco_phylo/summary_per_file.txt", header=T)

bot99<-sum[!sum$Missing_percent > quantile(sum$Missing_percent,prob=1-1/100),]

bot99_buscos_missing<-bot99$Alignment_name

write(bot99_buscos_missing, "../Busco_phylo/single_copy_busco_autosomes_top1percent_missing_removed.txt")
