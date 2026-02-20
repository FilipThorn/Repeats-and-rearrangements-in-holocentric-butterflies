#!/bin/bash -l
#SBATCH -J iqtree3
#SBATCH -A uppmax-USER
#SBATCH -c 16
#SBATCH -t 1-00:00:00
#SBATCH --mem 250GB


module load IQ-TREE/3.0.1

IN=/PATHtoALIGNMENT/Leptidea.mafft.0.2_trimal.concat.top1percentremoved.faa
OUT=PATH/Leptidea.mafft.0.2_trimal.top1percentremoved

iqtree3 -s $IN --prefix $OUT -T 16 -B 1000 -bnni -mset LG,LG+C10,LG+C20,LG+C30,LG+C40,LG+C50,LG+C60 -mrate G4 -mfreq default --score-diff all
