#!/bin/bash
while getopts b:g:o: flag 
do
case "${flag}" in
                b) BAM=${OPTARG}
                    	;;
                g) GEN=${OPTARG}
                    	;;
                o) outdir=${OPTARG}
                    	;;
                *) echo "Invalid option: -$flag" 
                	;;
        esac
done

cp $BAM $SNIC_TMP
cp $BAM.bai $SNIC_TMP 
genfiles="${GEN%.*}" 
cp $genfiles* $SNIC_TMP

cd $SNIC_TMP
bam=$(basename "$BAM")
ml bioinfo-tools
ml samtools
samtools index $bam 

gen=$(basename "$GEN")

export PYTHONNOUSERSITE=True
export LC_ALL=C
ls $SNIC_TMP

singularity run -B $SNIC_TMP/:/home/dnanexus/in -B $SNIC_TMP/:/home/dnanexus/out /sw/bioinfo/parliament2/v0.1.11/rackham/bin/parliament2-v0.1.11-0.sif \
 --bam /home/dnanexus/in/$bam \
 -r  /home/dnanexus/in/$gen \
 --prefix=${bam%.bam} \
 --breakdancer \
 --manta \
 --cnvnator \
 --lumpy \
 --delly_deletion \
 --delly_inversion \
 --delly_duplication \
 --genotype 

mkdir -p $outdir
mv sv_caller_results Parliament2_run_${bam%.bam}
cp -r Parliament2_run_${bam%.bam} $outdir
