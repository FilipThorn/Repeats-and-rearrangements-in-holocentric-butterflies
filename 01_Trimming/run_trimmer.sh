#!/bin/bash -l


while IFS= read -r sample
do

sbatch -J $sample -o slurm/$sample.output -e slurm/$sample.error -A "project ID" -p core -t 0-48:00:00 -n 16 trimmer.sh $sample

done < "samples.list"
