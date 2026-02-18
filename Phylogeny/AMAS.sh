#!/bin/bash
#SBATCH -J AMAS
#SBATCH -A uppmax-USER
#SBATCH -c 2
#SBATCH -t 02:00:00
#SBATCH --mem 12GB

#Summary of missingness
python3 path/AMAS.py summary -i 01.single_copy_buscos_alignments/03.TRIMMING_run2/TRIMAL.*.faa -d aa -f fasta
