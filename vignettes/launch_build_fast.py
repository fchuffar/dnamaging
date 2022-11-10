import os 
import os.path

with open("gse_build_fast.txt") as f:
    gses = f.read().splitlines() 

curdir = os.getcwd()
df = [f"{curdir}/../../datashare/{gse}/df_{gse}.rds" for gse in gses]
fpip = [f"{curdir}/00_fullpipeline1_{gse}.html" for gse in gses]

# for gse in gses:
#     dw_exists = os.path.exists(f"{curdir}/01_datawrapper_{gse}.R")
#     exp_exists = os.path.exists(f"{curdir}/01_expgrpwrapper_{gse}.R")
#     if not dw_exists:
#         fichier = open(f"{curdir}/01_datawrapper_{gse}.R", "x")
#         fichier.close()
#     if not exp_exists:
#         fichier = open(f"{curdir}/01_expgrpwrapper_{gse}.R", "x")
#         fichier.close()
        
localrules: target create_empty_wrapper

rule target:
    threads: 1
    message: "-- Rule target completed. --"
    input: 
      df,
      fpip,
    shell:"""
pwd
          """



rule create_empty_wrapper:
    input: 
      rmd_build="{prefix}/01_build_study_generic.Rmd",
    output: 
      r_datawrapper="{prefix}/01_datawrapper_{gse}.R",
      r_expgrpwrapper="{prefix}/01_expgrpwrapper_{gse}.R",
    threads: 1
    shell:"""
cd {wildcards.prefix}
touch {wildcards.r_datawrapper}
touch {wildcards.r_expgrpwrapper}
"""

        
        
        
rule build_gse:
    input: 
      rmd_build="{prefix}/01_build_study_generic.Rmd",
      r_dw="{prefix}/01_datawrapper_{gse}.R",
      r_exp="{prefix}/01_expgrpwrapper_{gse}.R",
    output: 
      study_rds = "{prefix}/../../datashare/{gse}/study_{gse}.rds",
      df_rds = "{prefix}/../../datashare/{gse}/df_{gse}.rds"    ,           
      html = "{prefix}/01_build_study_{gse}.html"      ,           
    threads: 8
    shell:"""
export PATH="/summer/epistorage/opt/bin:$PATH"
export PATH="/summer/epistorage/miniconda3/envs/R3.6.1_env/bin:$PATH"
cd {wildcards.prefix}

rm -Rf /tmp/wd_{wildcards.gse}
mkdir -p /tmp/wd_{wildcards.gse}
cd /tmp/wd_{wildcards.gse}
cp {wildcards.prefix}/01_build_study_generic.Rmd {wildcards.prefix}/01_datawrapper_{wildcards.gse}.R {wildcards.prefix}/01_expgrpwrapper_{wildcards.gse}.R .

RCODE="Sys.setenv('VROOM_CONNECTION_SIZE'=10000000);gse='{wildcards.gse}' ; print(paste0('#### ',gse,' ####')); rmarkdown::render('01_build_study_generic.Rmd',output_file=paste0('01_build_study_',gse,'.html')); print(paste0(gse,' constructed'));"
echo $RCODE | Rscript - 2>&1 > 01_build_study_{wildcards.gse}.Rout

cp 01_build_study_{wildcards.gse}.Rout 01_build_study_{wildcards.gse}.html {wildcards.prefix}/.
cd {wildcards.prefix}
rm -Rf /tmp/wd_{wildcards.gse}
"""

rule launch_pipeline:
    input: 
      df="{prefix}/../../datashare/{gse}/df_{gse}.rds",
      rmd_script="{prefix}/00_fullpipeline1.Rmd",      
      rmd_script_model="{prefix}/04_model.Rmd",      
    output:           
      html = "{prefix}/00_fullpipeline1_{gse}.html"      ,           
    threads: 32
    shell:"""
export PATH="/summer/epistorage/opt/bin:$PATH"
export PATH="/summer/epistorage/miniconda3/envs/R3.6.1_env/bin:$PATH"
cd {wildcards.prefix}

rm -Rf /tmp/wd_{wildcards.gse}
mkdir -p /tmp/wd_{wildcards.gse}
cd /tmp/wd_{wildcards.gse}
ln -s {wildcards.prefix}/df_{wildcards.gse}.rds
ln -s {wildcards.prefix}/litterature_models.rds
cp {wildcards.prefix}/*.Rmd {wildcards.prefix}/*.R .

RCODE="gse='{wildcards.gse}' ; nb_core=6; rmarkdown::render('00_fullpipeline1.Rmd',output_file=paste0('00_fullpipeline1_',gse,'.html'));print(paste0(gse,'launched'));"
echo $RCODE | Rscript - 2>&1 > 00_fullpipeline1_{wildcards.gse}.Rout

cp 00_fullpipeline1_{wildcards.gse}.html 00_fullpipeline1_{wildcards.gse}.Rout {wildcards.prefix}/.
cd {wildcards.prefix}
rm -Rf /tmp/wd_{wildcards.gse}
"""
