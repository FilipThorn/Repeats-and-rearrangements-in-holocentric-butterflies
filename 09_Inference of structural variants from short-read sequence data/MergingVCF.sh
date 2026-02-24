#!/bin/bash
## Merging per-sample vcf(jasmine) before global merge into a final VCF(Survivor)  

for d in Parliament2_run_*; do
    sample=$(basename "$d" | sed 's/^Parliament2_run_//' | sed 's/\.DToL\.dedup$//')
    for vcf in "$d"/filtered/*.vcf; do
        bcftools reheader -s <(echo -e "$(bcftools query -l "$vcf")\t${sample}") \
            "$vcf" -o "${vcf%.vcf}.reheader.vcf"
    done
done



for d in Parliament2_run_*; do
    sample=$(basename "$d" | sed 's/^Parliament2_run_//' | sed 's/\.DToL\.dedup$//')
    echo "Processing $sample"


    mkdir -p "$d/norm"

    # filtered, reheadered VCF.gz to uncompressed VCF for merging
    for vcf in "$d"/filtered/*.filtered.reheader.vcf; do
        out="$d/norm/$(basename "${vcf%.vcf}.norm.vcf")"
        bcftools view -Ov -o "$out" "$vcf"
    done

    ls "$d"/norm/*.norm.vcf > "$d"/norm/vcfs.list

    # Jasmine to merge per sample VCFs
    jasmine \
        --file_list="$d/norm/vcfs.list" \
        --out_file="$d/${sample}.consensus.vcf" \
        --max_dist=1000 \
        --min_support=3 \
        --pre_normalize
done

find Parliament2_run_* -name "*.consensus.vcf" | sort > all_consensus_vcfs.list

# SURVIVOR merge

SURVIVOR merge \
all_consensus_vcfs.list \
1000 \
1 \
1 \
0 \
0 \
50 \
cohort.merged.vcf
