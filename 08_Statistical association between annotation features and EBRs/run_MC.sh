#!/bin/bash -l

Group1="" #Reference, evolutionary breakpoint regions
Group2="" #Group to be shuffled, annotation tracks here

faidx="../reference/Lsin_DToL.fasta.fai" #A fasta index file
dir="tracks"



while IFS= read -r Group1
do
while IFS= read -r Group2
do

sbatch -J MC.$Group1.$Group2 -o slurm/MC.$Group1.$Group2.output -e slurm/MC.$Group1.$Group2.error -A "project_ID" -t 10:00:00 -n 1 Monte_Carlo_overlap_general3.sh $Group1 $Group2 $faidx $dir


done < "tracks.list.SV"
done < "EBR_meta.list"
