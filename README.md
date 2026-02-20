# Repeats-and-rearrangements-in-holocentric-butterflies
Repeats and structural variants are associated with chromosomal rearangements in holocentric butterflies. 

This repository contains code and files associated with the manuscript `Determinants of chromosomal rearrangements in holocentric Leptidea butterflies`.

1) 01_Trimming
2) 02_Mapping
3) 03_rDNA
4) 04_Phylogeny
     - Directory contain scripts used to generate phylogenies from single copy busco genes. See READ.me in directory for order of operations
5) 05_Inference of chromosomal rearrangements and evolutionary breakpoint regions
6) 06_Sequence tracks and segmental duplications
7) 07_Inference of copy number variants
8) 08_Statistical association between annotation features and EBRs
9) 09_Inference of structural variants from short-read sequence data


## File structure
```bash
.
├── 01_Trimming
│   ├── README.md
│   ├── run_trimmer.sh
│   └── trimmer.sh
├── 02_Mapping
│   ├── map_bwa.sh
│   └── run_mapping.sh
├── 03_rDNA
│   ├── barrnap.sh
│   └── rDNA_plot.R
├── 04_Phylogeny
│   ├── AMAS.sh
│   ├── MAFFT.sh
│   ├── READ.me
│   ├── concat.trimAl.sh
│   ├── filter.missingness.R
│   ├── iqtree3.sh
│   └── trimAl.sh
├── 05_Inference of chromosomal rearrangements and evolutionary breakpoint regions
│   ├── Read.me
│   └── plot_breakpoint_map.R
├── 06_Sequence tracks and segmental duplications
│   ├── DBscan.R
│   ├── READ.me
│   ├── SegDups_from_SG_and_DBscan.sh
│   ├── plot_segDup_map.R
│   ├── run_SD_from_SG.sh
│   └── tracks_preprocess.sh
├── 07_Inference of copy number variants
│   ├── CNV_for_specific_EBRs.R
│   ├── CNV_for_specific_EBRs.sh
│   ├── READ.me
│   ├── cf_collate.sh
│   ├── config_template_10kb.txt
│   ├── freeq.sh
│   ├── plot_CNV.R
│   └── run_cf.sh
├── 08_Statistical association between annotation features and EBRs
│   ├── Monte_Carlo_overlap_general3.sh
│   ├── READ.me
│   ├── odds_ratio_plot.R
│   ├── region_shuffler2.awk
│   └── run_MC.sh
├── 09_Inference of structural variants from short-read sequence data
│   ├── READ.me
│   └── multi_sample_bed_from_SV-vcf.sh
├── LICENSE
└── README.md
```
