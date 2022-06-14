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
#
# conda create --name dnamaning_env
# conda activate dnamaning_env
conda activate dnamaning_env
# conda install -c r r-base r-rmarkdown r-glmnet r-beeswarm r-rcolorbrewer 

# conda install -c bioconda                                     \
#   bioconductor-methylclock                                    \
#   bioconductor-Biobase                                        \
#   bioconductor-affy                                           \
#   bioconductor-GEOquery                                       \
#   bioconductor-methylclockdata                                \
#   bioconductor-illuminahumanmethylation27kanno.ilmn12.hg19    \
#   bioconductor-illuminahumanmethylation450kanno.ilmn12.hg19   \
#   bioconductor-illuminahumanmethylationepicanno.ilm10b4.hg19  \
#


# conda install -c bioconda/label/cf201901 bioconductor-impute 



# https://github.com/fchuffar/epimedtools
# devtools::install_github("fchuffar/epimedtools")

