#!/bin/bash
#SBATCH -J MAFFT
#SBATCH -A uppmax-USER
#SBATCH -c 2
#SBATCH -t 01:00:00
#SBATCH --mem 12GB


module load MAFFT/7.526-GCC-13.3.0-with-extensions

## mafft-linsi
mafft-linsi --reorder --adjustdirection --thread 2 $1 > $2
