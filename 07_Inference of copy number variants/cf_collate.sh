#All inds ratio

sgs=("Lars_10X" "CATrea" "FD_CAT" "FD_SWE" "SWE96" "LEP_outgroups")

for sampgroup in ${sgs[@]}; 
do
while IFS= read -r ind
do

if [[ "$sampgroup" ==  "Lars_10X" ]]; then
	if [[ "$ind" -eq 103 || "$ind" -eq 104 ]]; then sampgroup2="Leptidea_sinapis_SWE"; fi
	if [[ "$ind" -eq 105 || "$ind" -eq 106 ]]; then sampgroup2="Leptidea_sinapis_CAT"; fi
	if [[ "$ind" -eq 111 || "$ind" -eq 112 ]]; then sampgroup2="Leptidea_juvernica_SWE"; fi
	if [[ "$ind" -eq 115 || "$ind" -eq 116 ]]; then sampgroup2="Leptidea_reali_CAT"; fi
fi

if [[ "$sampgroup" ==  "LEP_outgroups" ]]; then
	if [[ "$ind" -eq 101 || "$ind" -eq 102 ]]; then sampgroup2="Leptidea_amurensis_MON"; fi
	if [[ "$ind" -eq 103 ]]; then sampgroup2="Leptidea_duponcheli_FRA"; fi
	if [[ "$ind" -eq 104 ]]; then sampgroup2="Leptidea_duponcheli_GRE"; fi
	if [[ "$ind" -eq 105 || "$ind" -eq 106 ]]; then sampgroup2="Leptidea_lactea_CHI"; fi
	if [[ "$ind" -eq 107 || "$ind" -eq 108 ]]; then sampgroup2="Leptidea_morsei_CHI"; fi
fi

if [[ "$sampgroup" ==  "CATrea" ]]; then sampgroup2="Leptidea_reali_CAT"; fi
if [[ "$sampgroup" ==  "FD_CAT" ]]; then sampgroup2="Leptidea_sinapis_CAT"; fi
if [[ "$sampgroup" ==  "FD_SWE" ]]; then sampgroup2="Leptidea_sinapis_SWE"; fi

if [[ "$sampgroup" == "SWE96" ]]; then
    if grep -qxF "$ind" lep96_12juv.txt; then
        sampgroup2="Leptidea_juvernica_SWE"
    else
        sampgroup2="Leptidea_sinapis_SWE"
    fi
fi

awk -v ind=$ind -v sampgroup=$sampgroup -v sampgroup2=$sampgroup2 'NR>1{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" ind "\t" sampgroup "\t" sampgroup2}' Results_10kb/$sampgroup/$ind.DToL.dedup.bam_ratio.txt >> Results_10kb/segDup.all_plus_out.inds_ratio.txt

done < "$sampgroup.samples.list"
done


#https://boevalab.inf.ethz.ch/FREEC/tutorial.html
#Columns
#chromosome #start position #ratio #median ratio for the whole fragment resulted from segmentation #predicted copy number

#Remove ingroup females
awk '{if(($7 == "SWE96" && ($6 == 124 || $6 == 181 )) || ($7 == "Lars_10X" && ( $6 % 2 == 0))){next} else{print $0}}' segDup.all_plus_out.inds_ratio.txt > segDup.malesINbothOUT.inds_ratio.txt

#Remove outgroup females
awk '{if($8 == "Leptidea_duponcheli_FRA" || ($8 == "Leptidea_morsei_CHI" && $6 == 107)){next; }else{print $0}}' segDup.malesINbothOUT.inds_ratio.txt > segDup.INOUTmales.inds_ratio.txt

