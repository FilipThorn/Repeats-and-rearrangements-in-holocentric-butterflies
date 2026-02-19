#!/bin/bash -l
#SBATCH -J barrnap.Ljuv_SweM
#SBATCH -o slurm/barrnap.Ljuv_SweM.output
#SBATCH -e slurm/barrnap.Ljuv_SweM.error
#SBATCH -t 00-10:00:00
#SBATCH -A "Project ID"
#SBATCH -n 20

ml barrnap/0.9-GCC-13.3.0

#assembly="/crex/proj/uppstore2017185/b2014034_nobackup/Jesper/qtl/reference/Lsin_DToL.fasta"
dir="assemblies_tmp"
assembly="$dir/LjuvernicaM_chr.fasta"

barrnap --threads 20 --kingdom "euk" $assembly


#  --help            This help
#  --version         Print version and exit
#  --citation        Print citation for referencing barrnap
#  --kingdom [X]     Kingdom: arc mito euk bac (default 'bac')
#  --quiet           No screen output (default OFF)
#  --threads [N]     Number of threads/cores/CPUs to use (default '1')
# --lencutoff [n.n] Proportional length threshold to label as partial (default '0.8')
#  --reject [n.n]    Proportional length threshold to reject prediction (default '0.25')
#  --evalue [n.n]    Similarity e-value cut-off (default '1e-06')
#  --incseq          Include FASTA _input_ sequences in GFF3 output (default OFF)
 # --outseq [X]      Save rRNA hit seqs to this FASTA file (default '')
