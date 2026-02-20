#!/bin/bash -l

#Rackham
#ml bioinfo-tools samtools/1.20 BEDTools/2.31.1

#Pelle
ml SAMtools/1.22-GCC-13.3.0 BEDTools/2.31.1-GCC-13.3.0

sample=$1
freecdir=$2


$freecdir/freec -conf config_10kb/$sample.config.txt 
