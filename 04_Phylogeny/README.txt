#Copy filtered set of buscos. no sex chromosomes present on all
#example code provided for one species but repeated for all

for i in `cat single_copy_busco_autosomes.txt`; do echo $i; cp PATH/busco_LjuvernicaSweF/run_lepidoptera_odb10/busco_sequences/single_copy_busco_sequences/${i}.faa 01.single_copy_buscos_alignments/LjuvernicaSweF/LjuvernicaSweF.${i}.faa ; done

#Rename fasta headers to have matching headers to concatenate alignments on after alignment and trimming
sed -i 's/>.*/>LsinapisSweF/' *.faa
#example code provided for one species but repeated for all

#CONCAT busco genes to multi fastas for all individuals per busco gene

for i in `cat single_copy_busco_autosomes.txt`; do echo $i; cat 01.single_copy_buscos_alignments/L*/*.${i}.faa > 01.single_copy_buscos_alignments/01.CONCAT/concat.${i}.faa ; done
  *The file `single_copy_busco_autosomes.txt` is a list of all single copy buscos present in all species on the autosomes. 

#Submit MAFFT
for i in `cat ../single_copy_busco_autosomes.txt`; do echo $i; sbatch ../MAFFT.sh ../01.single_copy_buscos_alignments/01.CONCAT/concat.${i}.faa ../01.single_copy_buscos_alignments/02.MAFFT/MAFFT.${i}.faa ; sleep 1 ; done

#Submit trimal -gt 0.2
for i in `cat ../../single_copy_busco_autosomes.txt`; do echo $i; sbatch ../../trimAl.sh ../../01.single_copy_buscos_alignments/02.MAFFT/MAFFT.${i}.faa ../../01.single_copy_buscos_alignments/03.TRIMMING/TRIMAL.${i}.faa ; sleep .5 ; done

#submit AMAS for alignment summary
sbatch AMAS.sh

#R script to remove top 1 percent of poor alignments and writes list of buscos passing the filter.
filter.missingness.R

#Concatenate all trimmed alignments
sbatch concat.mafft.trim.sh

#Build phylogeny!
sbatch iqtree3.sh
