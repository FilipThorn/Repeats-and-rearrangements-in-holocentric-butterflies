#!/bin/bash -l

date
echo "$1 has BEGUN"

module load bioinfo-tools
module load bwa/0.7.17
module load picard/2.23.4

id=$2

#Ref genome
ref=$3

#Alignment

fqdir=$4

#R1=$(grep -E "^P28119_${1}" <(ls $fqdir | grep ".fq.gz") | grep "R1")
#R2=$(grep -E "^P28119_${1}" <(ls $fqdir | grep ".fq.gz") | grep "R2")

R1=$(grep "$sample" <(ls $fqdir | grep ".fq.gz") | grep "R1")
R2=$(grep "$sample" <(ls $fqdir | grep ".fq.gz") | grep "R2")

bwa mem -t 19 $ref $fqdir/$R1 $fqdir/$R2 > $1.$id.sam

java -Xmx7g -jar $PICARD_ROOT/picard.jar AddOrReplaceReadGroups INPUT=$1.$id.sam OUTPUT=$1.$id.bam SORT_ORDER=coordinate RGID=$1-id RGLB=$1-lib RGPL=ILLUMINA RGPU=$1-01 RGSM=$1

java -Xmx7g -jar $PICARD_ROOT/picard.jar BuildBamIndex INPUT=$1.$id.bam

java -Xmx7g -jar $PICARD_ROOT/picard.jar MarkDuplicates \
  INPUT=$1.$id.bam \
  OUTPUT=$1.$id.dedup.bam \
  METRICS_FILE=$1.$id.dedup.bam.metrics\
  REMOVE_DUPLICATES=true\
  READ_NAME_REGEX=null

java -Xmx7g -jar $PICARD_ROOT/picard.jar BuildBamIndex INPUT=$1.$id.dedup.bam

date
echo "$1 is DONE"

rm $1.$id.sam
rm $1.$id.bam
rm $1.$id.bai
