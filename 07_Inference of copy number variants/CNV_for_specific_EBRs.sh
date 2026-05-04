ml BEDTools/2.31.1-GCC-13.3.0

#CAT fissions
grep "N6" ../leptidea.breakpoints.BranchEBRs.V5.tsv | grep -v "AstM" | grep -v "Fusion" > LsinapisCat_specific_Fissions.v5.bed



#SWE fusions
awk '($14 == "AncLsinapis-AncLsinapisSwe" || $14 == "AncLsinapisSwe-LsinapisSweM" || $14 == "AncLsinapisSwe-LsinapisSweF") && $10 == "Fusion" && $12 != "translocation" && $13 != "reciprocal_translocation" ' leptidea.breakpoints.BranchEBRs.V5.tsv > LsinapisSWE_fusion_EBRs.bed





EBRdir="/crex/proj/uppstore2017185/b2014034_nobackup/Jesper/SegDup/odds_ratio/tracks"
EBRset="LsinapisSWE_fusion_EBRs"

CNVdir="/crex/proj/uppstore2017185/b2014034_nobackup/Jesper/SegDup/cf_SegDup/Results_10kb"
CNV="segDup.INOUTmales.inds_ratio"
pop="Leptidea_sinapis_SWE"

#EBR - CNV overlap
bedtools intersect -a <(awk '{print $1 "\t" $2-1 "\t" $2+9999 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8}' "$CNVdir/$CNV.txt") -b "$EBRdir/$EBRset.bed" -wa -wb > CNV.$EBRset.EBRs
