We downloaded StainedGlass from https://github.com/vollgerlab/StainedGlass/tree/main and followed their instructions for installation. 

The config.yaml we have provided is an example of the config file used to generate the stainedGlass output and plots. 

We ran the snakemake pipeline for each chromosome seperatly, changing the targeted chromosome between runs and executed the pipeline with:

CONDA_SUBDIR=osx-64 snakemake make_figures --cores all --use-conda
