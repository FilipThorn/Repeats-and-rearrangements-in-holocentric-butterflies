
#SATELLITES
#Make .bed-files of Cavalcanti's satellite .gff-files

awk '$1!~/#/{split($1, a, "r"); if(a[2]~/^0/){split(a[2], b, "0"); Chromosome = "Chr_" b[2] } else if(a[2] == "Z"){ Chromosome = "Chr_48"} else{ Chromosome = "Chr_" a[2]} print Chromosome "\t" $4-1 "\t" $5 "\t" $3}' L-sinapis-Chrs-sat01.gff L-sinapis-Chrs-sat03.gff L-sinapis-Chrs-RestSatDNAs.gff > satellites.bed

#PROTEIN-CODING GENES
awk '$1!~/#/ && $3 == "gene" {print $1 "\t" $4-1 "\t" $5}' Lsin_DToL.2021_11-genes.modChrNames.Zfix.gff > protein_coding_genes.bed





#SEGMENTAL DUPLICATIONs from StainedGlass 2kb windows non non-masked genome postprocessing

#Concatenate all chromosome-specific beds

cat merged_beds/*bed > allChrs.largeSD.step1.bed

module load BEDTools/2.31.1-GCC-13.3.0

dir="../SegDups_from_SG"

bedtools coverage -a $dir/allChrs.largeSD.step1.bed -b satellites.bed > allChrs.largeSD.step1.sats.coverage.txt

awk '$NF <= 0.5' allChrs.largeSD.step1.sats.coverage.txt > allChrs.largeSD.lessThan50percentSats.bed


#REPEATMASKER OUTPUT
module load BEDTools/2.31.1-GCC-13.3.0
RMSKout="../01.genomes/LsinapisAstM/Lsin_DToL.fasta.out"

awk 'NR>3{print $5 "\t" $6-1 "\t" $7 "\t" $11}' "$RMSKout"  > RMSKout.bed

bedtools intersect -a RMSKout.bed -b satellites.bed -v > RMSKout.noSat.bed

#cut -f4 RMSKout.noSat.bed |sort -u

awk '$4 ~/^DNA/' RMSKout.noSat.bed > DNA_transposons.bed
awk '$4 ~/^SINE/' RMSKout.noSat.bed > SINEs.bed
awk '$4 ~/^LINE/' RMSKout.noSat.bed > LINEs.bed
awk '$4 ~/^LTR/' RMSKout.noSat.bed > LTRs.bed
awk '$4 ~/Helitron/' RMSKout.noSat.bed > Helitrons.bed

awk '$4 ~/Low_complexity/' RMSKout.noSat.bed > Low_complexity.bed
awk '$4 ~/^Simple_repeat/' RMSKout.noSat.bed > simple_repeats.bed
awk '$4 ~/^Satellite/' RMSKout.noSat.bed > RMSK_specific_satellites.bed
awk '$4 ~/^Unknown/' RMSKout.noSat.bed > Unknown_repeats.bed



#Telomeres from RepeatMasker
RMSKout="../01.genomes/LsinapisAstM/Lsin_DToL.fasta.out"

grep -Ew "TTAGG|AATCC|GGATT|CCTAA" "$RMSKout"  | awk '{print $5 "\t" $6-1 "\t" $7 "\t" $10}'  > Telomere_5mer.bed


#Ribosomal DNA

barrnap="../barrnap/slurm/barrnap.DToL.output"




#Structural variants

dir="../odds_ratio/tracks"

pop="Ljuvernica_SWE"
poplist="samples.list.SWEjuv"

awk 'NR==FNR{a[$1]} NR!=FNR{if($4 in a){print $0}}' $poplist multi_sample.bed |cut -f1-3 |sort -u > $dir/SV.$pop.bed

#EBRs
awk 'NR>1 && $10 == "Fission" && $12 != "translocation" && $13 != "reciprocal_translocation" {print $1 "\t" $2 "\t" $3}' ../leptidea.breakpoints.BranchEBRs.V5.tsv | sort -u > EBRs_Fis.v5.bed

awk 'NR>1 && $10 == "Fusion" && $12 != "translocation" && $13 != "reciprocal_translocation" {print $1 "\t" $2 "\t" $3}' ../leptidea.breakpoints.BranchEBRs.V5.tsv | sort -u > EBRs_Fus.v5.bed

awk 'NR>1 && $10 != "Unpolarisable" && ($12 == "translocation" || $13 == "reciprocal_translocation") {print $1 "\t" $2 "\t" $3}' ../leptidea.breakpoints.BranchEBRs.V5.tsv | sort -u > EBRs_Tra.v5.bed
