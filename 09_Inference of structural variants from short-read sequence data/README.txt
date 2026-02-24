# Structural Variant Calling Pipeline

This branch repository contains the scripts used to identify, filter, and merge structural variants from short read WGS.
The workflow consists of three main steps:

Structural variants were detected using Parliament2 (v0.1.11), which runs multiple SV callers: i.e. BreakDancer, Manta, CNVnator, LUMPY, and DELLY.
Parliament2.sh -> Runs Parliament2 (here from a singularity image) for each sample to perform structural variant discovery. All integrated callers are executed, producing raw SV callsets for every sample.

Filtering.sh -> Applies per callers filters to reduce false positives. Only variants passing internal caller filters are retained. Additional thresholds are applied: Manta, DELLY, and LUMPY variants must have supporting reads corresponding to at least 25% of the sample sequencing depth, while BreakDancer and CNVnator variants are retained only if their absolute lengths exceed 1 kb and 5 kb, respectively. The output consists of vcfs of high-confidence cqlls for each sample.

Merging.sh -> Filtered variants are first merged at the sample level using Jasmine (v1.1.5), retaining variants of the same type located within 1 kb and supported by at least two callers to produce a consensus VCF per sample. All sample consensus VCFs are then merged into a final cohort-level dataset using SURVIVOR (v1.0.7), applying the same merging criteria (same SV type within 1 kb).
The final output is a cohort-level SV .vcf later on used for EBRs association analyses.
