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

cp 00_build_idat_studies.py 00_custom_build_idat_studies.py 
source ~/conda_config.sh
# mamba install -c anaconda -c bioconda -c conda-forge -c r r-base libopenblas bioconductor-geoquery bioconductor-affy bioconductor-biobase r-seqinr r-rcpparmadillo r-devtools r-fastmap r-matrix r-kernsmooth r-catools r-gtools r-nortest r-survival r-beanplot r-gplots bioconductor-rnbeads r-doparallel bioconductor-rnbeads.hg19 ghostscript bioconductor-watermelon
conda activate idat2study_env
snakemake --cores 1 -s 00_custom_build_idat_studies.py -pn 
conda activate dnamaging_env
snakemake -k -s 00_custom_build_idat_studies.py --jobs 50 --cluster "oarsub --project epimed -l /nodes=1,walltime=10:00:00"  --latency-wait 60 -pn


# launch custom pipelines
source ~/conda_config.sh
# mamba install -c anaconda -c bioconda -c conda-forge -c r r-base libopenblas bioconductor-geoquery bioconductor-affy bioconductor-biobase r-seqinr r-rcpparmadillo r-devtools r-fastmap r-matrix r-kernsmooth r-catools r-gtools r-nortest r-survival r-beanplot r-gplots bioconductor-rnbeads r-doparallel bioconductor-rnbeads.hg19 ghostscript bioconductor-watermelon
conda activate idat2study_env
cp 00_launch_epiclock_pipeline.py 00_custom_wf.py
cp 00_preproc.sh 00_custom_preproc.sh
cp 00_rules.py 00_custom_rules.py
cp config 00_custom_config

cp 00_preproc_wf.py 00_custom_preproc_wf.py
cp 00_models_wf.py 00_custom_models_wf.py

snakemake -k --cores 1 -s 00_build_studies_wf.py  -pn 
rm -Rf info_build_*.rds
snakemake -k -s 00_build_studies_wf.py  --jobs 50 --cluster "oarsub --project epimed -l /nodes=1,walltime=10:00:00"  --latency-wait 60 -pn

snakemake -k --cores 1 -s 00_preproc_wf.py -pn 
rm -Rf info_desc_*.rds
snakemake -k -s 00_preproc_wf.py --jobs 50 --cluster "oarsub --project epimed -l /nodes=1,walltime=10:00:00"  --latency-wait 60 -pn

snakemake -k --cores 1 -s 00_models_wf.py -pn 
snakemake -k -s 00_models_wf.py --jobs 50 --cluster "oarsub --project epimed -l /nodes=1,walltime=10:00:00"  --latency-wait 60 -pn



snakemake -k --cores 1 -s 00_custom_wf.py -pn 
snakemake -k -s 00_custom_wf.py --jobs 50 --cluster "oarsub --project epimed -l /nodes=1,walltime=10:00:00"  --latency-wait 60 -pn



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

