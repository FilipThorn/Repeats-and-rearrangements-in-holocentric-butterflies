#!/bin/bash -l


while IFS= read -r sample
do

id="DToL"
ref="../reference/Lsin_DToL.fasta"
fqdir="../../01_Trimming/sample_group_directory/trimmed_files"

#Map using BWA
sbatch -J $sample -o slurm/$sample.$id.output -e slurm/$sample.$id.error -A "project ID" -t 72:00:00 -p node -n 20 map_bwa.sh $sample $id $ref $fqdir


done < "samples.list"
