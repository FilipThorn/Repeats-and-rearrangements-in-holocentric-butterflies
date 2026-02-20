#!/bin/bash -l



Chromosome=$1
table="SG_output/${Chromosome}.2000.10000.full.tbl.gz"
dir="raw_output"

MIN_ID=90
MIN_DIST=10000

awk -v minID=$MIN_ID -v minD=$MIN_DIST '
function abs(x){return ((x < 0.0) ? -x : x)}
BEGIN{OFS="\t"}
{
    qmid = ($2 + $3) / 2
    rmid = ($6 + $7) / 2

    if ($10 >= minID && abs(qmid - rmid) > minD ){
    	print $1, $2, $3, $6, $17
    }
        
}
' <(zcat "$table") > $dir/filtered.${Chromosome}.tsv

sort -k2,2n -k5,5n $dir/filtered.${Chromosome}.tsv > $dir/filtered.sorted.${Chromosome}.tsv

awk '
function abs(x){return ((x < 0.0) ? -x : x)}
{OFS="\t";
    offset = abs($4 - $2)
    bin = int(offset / 2000) * 2000
    print $1, $2, $3, $4, $5, bin, $4 - $2
}
' $dir/filtered.sorted.${Chromosome}.tsv > $dir/offset.${Chromosome}.tsv

awk '
{
    key = $2
    val = $6

    # first line: initialize prev_vals
    if (NR == 1) {
        prev_key = key
    }

    # group boundary
    if (key != prev_key) {
        # compare previous group with current group
        for (i in prev_vals)
            for (j in curr_vals)
                print prev_key, i, key, j, j - i

        # move current group to previous
        delete prev_vals
        for (j in curr_vals)
            prev_vals[j]

        delete curr_vals
        prev_key = key
    }

    # store values
    curr_vals[val] = val

    # seed prev_vals during first group
    if (NR == 1)
        prev_vals[val] = val
}' $dir/offset.${Chromosome}.tsv | awk 'function abs(x){return ((x < 0.0) ? -x : x)} {if(abs($5) < 3000){print $0}}' > $dir/sim.offset.${Chromosome}.tsv

#R module for DBSCAN
module load R-bundle-CRAN/2024.11-foss-2024a

cd $dir
Rscript ../DBscan.R "$Chromosome"
cd ..
#


awk -v chr="$Chromosome" '$6!="noise"{print chr "\t" $1 "\t" $1+2000 "\t" $6}' $dir/DBSCAN.${Chromosome}.tsv > $dir/DBSCAN.${Chromosome}.bed


module load BEDTools/2.31.1-GCC-13.3.0

bedtools merge -d 20000 -i $dir/DBSCAN.${Chromosome}.bed > merged_beds/DBSCAN.${Chromosome}.merged.bed


rm $dir/filtered.${Chromosome}.tsv
rm $dir/filtered.sorted.${Chromosome}.tsv
