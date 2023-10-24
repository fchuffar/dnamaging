# conda deactivate
# rm -Rf /summer/epistorage/miniconda3/*
# ~/Miniconda3-latest-Linux-x86_64.sh -u -p /summer/epistorage/miniconda3 -b
# conda update -n base -c defaults conda

conda create --clone epimedtools_env -n dnamagingtest_env 
conda activate dnamagingtest_env


conda install -c conda-forge -c bioconda r-glmnetutils r-writexls bioconductor-epidish bioconductor-annotatr snakemake bedtools bioconductor-limma bioconductor-impute r-intervals


# conda install -c bioconda bioconductor-illuminahumanmethylation27kanno.ilmn12.hg19 bioconductor-illuminahumanmethylation450kanno.ilmn12.hg19 bioconductor-illuminahumanmethylationepicanno.ilm10b4.hg19
#
# IlluminaHumanMethylation450kanno.ilmn12.hg19
# IlluminaHumanMethylationEPICanno.ilm10b4.hg19



# umap-learn r-umap r-caret r-randomforest
# conda install -c bioconda bioconductor-champ


# under R
devtools::install_github("fchuffar/dnamaging")
