awk -v OFS="\t" '
/^#CHROM/ {
    for (i=10;i<=NF;i++) sample[i]=$i
    next
}

/^#/ { next }

{
    chrom=$1
    pos=$2
    start1=pos-1
    end1=pos

    chr2=chrom
    end2=pos
    svtype="NA"
    suppvec=""

    n=split($8, info, ";")
    for (i=1;i<=n;i++) {
        if (info[i] ~ /^END=/) {
            split(info[i],a,"="); end1=a[2]
            end2=a[2]
        }
        if (info[i] ~ /^SVTYPE=/) {
            split(info[i],a,"="); svtype=a[2]
        }
        if (info[i] ~ /^SUPP_VEC=/) {
            split(info[i],a,"="); suppvec=a[2]
        }
        if (info[i] ~ /^CHR2=/) {
            split(info[i],a,"="); chr2=a[2]
        }
    }

    # insertion fallback
    if (end1==pos) end1=pos+1

    for (i=10;i<=NF;i++) {
        idx=i-9
        if (substr(suppvec,idx,1)=="1") {

            # same chromosome
            if (chr2==chrom) {
                print chrom,start1,end1,sample[i],svtype
            }
            else {
            print "Interchromosomal!" > "/dev/tty"
                # breakpoint 1
                print chrom,start1,start1+1,sample[i],svtype
                # breakpoint 2
                print chr2,end2-1,end2,sample[i],svtype
            }
        }
    }
}
'  <(zcat ParliamentMergedSVCalls.fixed.sorted.vcf.gz) > multi_sample.bed
