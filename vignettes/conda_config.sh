# conda deactivate
# rm -Rf /summer/epistorage/miniconda3/*
# ~/Miniconda3-latest-Linux-x86_64.sh -u -p /summer/epistorage/miniconda3 -b
# conda update -n base -c defaults conda

<<<<<<< HEAD
conda install -c conda-forge -c bioconda r-glmnetutils r-writexls bioconductor-epidish bioconductor-annotatr snakemake bedtools bioconductor-limma

conda install -c bioconda bioconductor-illuminahumanmethylation27kanno.ilmn12.hg19 bioconductor-illuminahumanmethylation450kanno.ilmn12.hg19 bioconductor-illuminahumanmethylationepicanno.ilm10b4.hg19
                          
IlluminaHumanMethylation450kanno.ilmn12.hg19
IlluminaHumanMethylationEPICanno.ilm10b4.hg19




conda install -c bioconda bioconductor-impute
conda install -c "bioconda/label/cf201901" bioconductor-impute
conda install -c "bioconda/label/gcc7" bioconductor-impute 


# umap-learn r-umap r-caret r-randomforest
# conda install -c bioconda bioconductor-champ




# under R
devtools::install_github("fchuffar/dnamaging")
=======
__conda_setup="$('/summer/epistorage/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
   eval "$__conda_setup"
else
   if [ -f "/summer/epistorage/miniconda3/etc/profile.d/conda.sh" ]; then
       . "/summer/epistorage/miniconda3/etc/profile.d/conda.sh"
   else
       export PATH="/summer/epistorage/miniconda3/bin:$PATH"
   fi
fi
unset __conda_setup

>>>>>>> dfc37f3a53a3375f1a380abfd75cfd3439911288

# conda create --name R3.6.1_env
# conda activate R3.6.1_env

# conda install  -c anaconda libopenblas
#
# conda install -c r \
#   r-base=3.6.1     \
#   r-rmarkdown      \
#   r-devtools       \
#   r r-xml
#
#   install.package("https://cran.r-project.org/src/contrib/Archive/locfit/locfit_1.5-9.tar.gz")
#
#
# # conda install --no-update-deps -c r r-xml
#
# conda install -c bioconda \
#   bioconductor-Biobase    \
#   bioconductor-affy       \
#   bioconductor-GEOquery
#
# # conda install --no-update-deps -c bioconda            \
# #   bioconductor-illuminahumanmethylation27kanno.ilmn12.hg19    \
# #   bioconductor-illuminahumanmethylation450kanno.ilmn12.hg19   \
# #   bioconductor-illuminahumanmethylationepicanno.ilm10b4.hg19
#
#
# #conda install -c r r-locfit
#
#
#
#
# conda install -c bioconda bioconductor-rhdf5lib
# conda install -c bioconda bioconductor-rhdf5
# conda install -c bioconda bioconductor-hdf5array
#
#
# BiocManager::install("HDF5Array")
# BiocManager::install("minfi")
# BiocManager::install("IlluminaHumanMethylation27kanno.ilmn12.hg19")
# BiocManager::install("IlluminaHumanMethylation450kanno.ilmn12.hg19")
# BiocManager::install("IlluminaHumanMethylationEPICanno.ilm10b4.hg19")
# BiocManager::install("EpiDISH")
#
#
#
#
# # https://github.com/fchuffar/epimedtools
# Sys.setenv(TAR = "/bin/tar") ; devtools::install_github("fchuffar/epimedtools")
#
# install.packages("dbplyr")
# install.packages("tidyr")
# install.packages("memoise")
#
#
#
#
# # bioconductor-methylclockdata                                \
# # bioconductor-methylclock                                    \
#
#
#
#
