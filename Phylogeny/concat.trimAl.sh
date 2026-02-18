#!/bin/bash -l
#SBATCH -J concat_mafft
#SBATCH -A uppmax-USER
#SBATCH -c 4
#SBATCH -t 03:00:00
#SBATCH --mem 48GB

OUT=/PATH/Leptidea.mafft.0.2_trimal.concat.top1percentremoved.faa

#Top 1 percent missingness removed
FILES=$(cat ./top1percent.list)

#perl script for concatenating https://github.com/burki-lab/ptMAGs/blob/main/src/cat_fasta.pl
perl cat_fasta.pl -n $OUT -f ${FILES}
