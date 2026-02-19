#!/bin/bash -l

while IFS= read -r Chromosome
do

#bash SegDups_from_SG_and_DBscan.sh $Chromosome

sbatch -J sd.$Chromosome -o slurm/$Chromosome.sd.output -e slurm/$Chromosome.sd.error -A "project_ID" -t 01:00:00 -n 1 SegDups_from_SG_and_DBscan.sh $Chromosome

done < "scaffolds.list.rest"
