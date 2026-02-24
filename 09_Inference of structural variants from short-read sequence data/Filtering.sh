#!/bin/bash
ROOTDIR=$(pwd)

for d in Parliament2_run_*.dedup; do
    echo "sample $d"
    cd "$d"

    mkdir -p filtered

    bam=$(ls *.bam | head -n1)

    echo "Estimating depth from $bam..."

    MEAN_DEPTH=$(samtools depth "$bam" | \
        awk '{sum+=$3} END {print int(sum/NR)}')

    MIN_SUPPORT=$(awk -v d="$MEAN_DEPTH" 'BEGIN{print int(d*0.2)}')

    echo "Mean depth = $MEAN_DEPTH"
    echo "Min support (20%) = $MIN_SUPPORT"

    if ls *.manta.diploidSV.vcf.gz 1> /dev/null 2>&1; then
        manta_vcf=$(ls *.manta.diploidSV.vcf.gz)

        bcftools view \
            -f PASS \
            -i 'GT="0/1" || GT="1/1"' \
            "$manta_vcf" \
            -Oz -o filtered/manta.filtered.vcf.gz

        tabix -p vcf filtered/manta.filtered.vcf.gz
    fi

    for svtype in deletion duplication inversion; do
        vcf=$(ls *.delly.${svtype}.vcf 2>/dev/null || true)
        if [[ -n "$vcf" ]]; then

            bcftools view \
                -f PASS \
                -i "(INFO/PE>=$MIN_SUPPORT || INFO/SR>=$MIN_SUPPORT) && (GT=\"0/1\" || GT=\"1/1\")" \
                "$vcf" \
                -Oz -o filtered/delly.${svtype}.filtered.vcf.gz

            tabix -p vcf filtered/delly.${svtype}.filtered.vcf.gz
        fi
    done

    if ls *.lumpy.vcf 1> /dev/null 2>&1; then
        lumpy_vcf=$(ls *.lumpy.vcf)

        bcftools view \
            -i "INFO/SU>=$MIN_SUPPORT && (INFO/PE>0 || INFO/SR>0)" \
            "$lumpy_vcf" \
            -Oz -o filtered/lumpy.filtered.vcf.gz

        tabix -p vcf filtered/lumpy.filtered.vcf.gz
    fi

    if ls *.breakdancer.vcf 1> /dev/null 2>&1; then
        bd_vcf=$(ls *.breakdancer.vcf)

        bcftools view \
            -i 'INFO/SVLEN>=1000' \
            "$bd_vcf" \
            -Oz -o filtered/breakdancer.filtered.vcf.gz

        tabix -p vcf filtered/breakdancer.filtered.vcf.gz
    fi

    if ls *.cnvnator.vcf 1> /dev/null 2>&1; then
        cnv_vcf=$(ls *.cnvnator.vcf)

        bcftools view \
            -f PASS \
            -i 'abs(INFO/SVLEN)>=5000' \
            "$cnv_vcf" \
            -Oz -o filtered/cnvnator.filtered.vcf.gz

        tabix -p vcf filtered/cnvnator.filtered.vcf.gz
    fi

    cd "$ROOTDIR"
done
