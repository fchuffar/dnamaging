cd ~/projects/dnamaging/vignettes
rsync -auvP ~/projects/dnamaging/ cargo:~/projects/dnamaging/ --dry-run
rsync -auvP ~/projects/dnamaging/ cargo:~/projects/dnamaging/ --exclude="gsea_out*" --exclude="*.rds" --exclude="*.grp" --exclude="*.bed" --exclude="*.html" --exclude="*.rnk" --dry-run 

source ~/conda_config.sh
conda activate dnamaging_env
# under R 
# devtools::install_github("fchuffar/dnamaging")


# source config
# echo ${project}
# echo ${study}
# rsync -auvP ~/projects/${project}/results/${study}/ cargo:~/projects/${project}/results/${study}/

ln -s 00_build_idat_studies.py 00_custom_build_idat_studies.py 
source ~/conda_config.sh
# conda create -n idat2study_env
conda activate idat2study_env
# mamba install -c anaconda -c bioconda -c conda-forge -c r r-base libopenblas bioconductor-geoquery bioconductor-affy bioconductor-biobase r-seqinr r-rcpparmadillo r-devtools r-fastmap r-matrix r-kernsmooth r-catools r-gtools r-nortest r-survival r-beanplot r-gplots bioconductor-rnbeads r-doparallel bioconductor-rnbeads.hg19 ghostscript bioconductor-watermelon bioconductor-illuminahumanmethylation450kanno.ilmn12.hg19 bioconductor-illuminahumanmethylationepicanno.ilm10b4.hg19 bioconductor-illuminahumanmethylation27kanno.ilmn12.hg19 snakemake=7.32.4
# devtools::install_github("fchuffar/epimedtools")
snakemake --cores 1 -s 00_custom_build_idat_studies.py -pn 
snakemake -k -s 00_custom_build_idat_studies.py --jobs 50 --cluster "oarsub --project epimed -l /nodes=1,walltime=10:00:00"  --latency-wait 60 -pn


ln -s 00_studies_wf.py 00_custom_studies_wf.py
source ~/conda_config.sh
# conda create -n buildstudy_env
conda activate buildstudy_env
# mamba install -c anaconda -c bioconda -c conda-forge -c r r-base libopenblas bioconductor-geoquery bioconductor-affy bioconductor-biobase r-seqinr r-rcpparmadillo r-devtools r-fastmap r-matrix r-kernsmooth r-catools r-gtools r-nortest r-survival r-beanplot r-gplots r-sass jquery r-nlme r-bslib r-sourcetools r-fontawesome r-xtable r-httpuv r-dbi r-shiny bioconductor-illuminahumanmethylation450kanno.ilmn12.hg19 bioconductor-illuminahumanmethylationepicanno.ilm10b4.hg19 bioconductor-illuminahumanmethylation27kanno.ilmn12.hg19 bioconductor-epidish r-openxlsx snakemake=7.32.4
# devtools::install_github("fchuffar/epimedtools")
# gse='GSE41037'; rmarkdown::render('01_build_study_generic.Rmd', output_file=paste0('01_build_study_',gse,'.html'));
# gse='GSE119617'; rmarkdown::render('01_build_study_generic.Rmd', output_file=paste0('01_build_study_',gse,'.html'));
# gse='GSE40279'; rmarkdown::render('01_build_study_generic.Rmd', output_file=paste0('01_build_study_',gse,'.html'));
# gse='GSE42861'; rmarkdown::render('01_build_study_generic.Rmd', output_file=paste0('01_build_study_',gse,'.html'));
# dim(s$data) # problem with GSE42861 : only 374449 probes. not the case with R3.6.1 
snakemake -k --cores 1 -s 00_custom_studies_wf.py -pn 
snakemake -k -s 00_custom_studies_wf.py  --jobs 50 --cluster "oarsub --project epimed -l /nodes=1,walltime=10:00:00"  --latency-wait 60 -pn


ln -s 00_preproc_wf.py 00_custom_preproc_wf.py
source ~/conda_config.sh
# conda create -n preproc_env
conda activate preproc_env
# mamba install -c anaconda -c bioconda -c conda-forge -c r r-base libopenblas bioconductor-geoquery bioconductor-affy bioconductor-biobase r-seqinr r-rcpparmadillo r-devtools r-fastmap r-matrix r-kernsmooth r-catools r-gtools r-nortest r-survival r-beanplot r-gplots r-dbi r-iterators r-codetools r-rcppeigen r-shape r-foreach r-glmnet r-writexls r-glmnetutils bioconductor-epidish bioconductor-impute snakemake=7.32.4 python=3.9
# devtools::install_github("fchuffar/epimedtools")
# devtools::install_github("fchuffar/dnamaging")
# gse='GSE41037' ; rmarkdown::render('02_stat_preproc.Rmd',output_file=paste0('02_stat_preproc_',gse,'.html')) ;
# gse='GSE119617'; rmarkdown::render('02_stat_preproc.Rmd',output_file=paste0('02_stat_preproc_',gse,'.html')) ;
snakemake -k --cores 1 -s 00_custom_preproc_wf.py -pn 
snakemake -k -s 00_custom_preproc_wf.py --jobs 50 --cluster "oarsub --project epimed -l /nodes=1,walltime=10:00:00"  --latency-wait 60 -pn


ln -s 00_models_wf.py 00_custom_models_wf.py
source ~/conda_config.sh
# conda create -n model_env
conda activate model_env
# mamba install -c anaconda -c bioconda -c conda-forge -c r r-base libopenblas bioconductor-geoquery bioconductor-affy bioconductor-biobase r-seqinr r-rcpparmadillo r-devtools r-fastmap r-matrix r-kernsmooth r-catools r-gtools r-nortest r-survival r-beanplot r-gplots r-dbi r-iterators r-codetools r-rcppeigen r-shape r-foreach r-glmnet r-writexls r-glmnetutils bioconductor-epidish snakemake=7.32.4 python=3.9
# devtools::install_github("fchuffar/epimedtools")
# devtools::install_github("fchuffar/dnamaging")
# gse='GSE41037_modelcalllm_meth~age_ewas1000000_nn1000' ; run=0 ; rmarkdown::render('04_model.Rmd', output_file=paste0('04_model_r', run, '_', gse, '.html'));
# gse='GSE40279_modelcalllm_meth~age_ewas1000000_nn1000' ; run=0 ; rmarkdown::render('04_model.Rmd', output_file=paste0('04_model_r', run, '_', gse, '.html'));
snakemake -k --cores 1 -s 00_custom_models_wf.py -pn 
snakemake -k -s 00_custom_models_wf.py --jobs 50 --cluster "oarsub --project epimed -l /nodes=1,walltime=10:00:00 -t fat "  --latency-wait 60 -pn










ls -lha ~/projects/datashare/GSE40279
ls -lha ~/projects/datashare/GSE42861
ls -lha ~/projects/datashare/GSE87571




# snakemake -k -s 00_iter_call.py --cores 1 -pn
# snakemake -k -s 00_iter_call.py --jobs 50 --cluster "oarsub --project epimed -l /nodes=1,walltime=10:00:00"  --latency-wait 60 -pn


source ~/conda_config.sh 
cd ~/projects/breast/results/04.2_dnamaging/vignettes
echo $PYTHONPATH
# PYTHONPATH="${PYTHONPATH}:/summer/epistorage/opt/combined-pvalues/
Sys.setenv(PYTHONPATH = "/summer/epistorage/opt/combined-pvalues/")
/summer/epistorage/opt/combined-pvalues/cpv/comb-p pipeline -c 5 --seed 1e-30 --dist 1000 -p dmr_study_TCGA-BRCA.rds_modelcalllm_meth~gec_1e-30 --region-filter-p 0.05 --region-filter-n 2 ewas4combp_study_TCGA-BRCA.rds_modelcalllm_meth~gec.bed


export PYTHONPATH="/summer/epistorage/opt/combined-pvalues/"
pip install toolshed interlap




s = readRDS("study_r0_ewas2000_nn1000_GSE42861.rds")
idx = readRDS("df_r0_ewas2000_nn1000_GSE42861.rds")
colnames(idx)
s$data = s$data[rownames(s$data)%in%colnames(idx),]
s$platform = s$platform[rownames(s$data),]
saveRDS(s, "study_r0_ewas2000_nn1000_GSE42861.rds")

