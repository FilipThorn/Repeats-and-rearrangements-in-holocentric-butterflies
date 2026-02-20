#!/bin/bash -l


freecdir="cf/FREEC-master/src"

sampgroup="LEP_outgroups"

mkdir Results_10kb/$sampgroup


while IFS= read -r sample
do

#Use following if directly in directory
#awk -v sample=$sample -v sampgroup=$sampgroup '{if($1=="mateFile"){$3=$3 sample ".DToL.dedup.bam" } else if($1=="outputDir"){$3=$3 "/" sampgroup }; print $0}' config_template_10kb.txt > config_10kb/$sample.config.txt 

#Use following if using Aneu_reseq file structure
awk -v sample=$sample -v sampgroup=$sampgroup '{if($1=="mateFile"){$3=$3 sampgroup "/" sample ".DToL.dedup.bam" } else if($1=="outputDir"){$3=$3 "/" sampgroup }; print $0}' config_template_10kb.txt > config_10kb/$sample.config.txt 

#Rackham
#sbatch -J $sample.$sampgroup.cf -o slurm/$sample.$sampgroup.cf.10kb.output -e slurm/$sample.$sampgroup.cf.10kb.error  -A "project ID" -t 10:00:00 -p core -n 2 freeq.sh $sample $freecdir

#Pelle
sbatch -J $sample.$sampgroup.cf -o slurm/$sample.$sampgroup.cf.10kb.output -e slurm/$sample.$sampgroup.cf.10kb.error  -A "project ID" -t 10:00:00 -n 1 freeq.sh $sample $freecdir

sleep 1m
done < "LEP_outgroups.samples.list"
