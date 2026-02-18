#!/bin/bash
#SBATCH -J trimAL
#SBATCH -A uppmax-USER
#SBATCH -c 1
#SBATCH -t 01:00:00
#SBATCH --mem 12GB


module load trimAl/1.5.0-GCCcore-13.3.0

trimal -in $1 -out $2 -gt 0.2 -fasta
