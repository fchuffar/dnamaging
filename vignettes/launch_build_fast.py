import os 

with open("gse_build_fast.txt") as f:
    gses = f.read().splitlines() 

curdir = os.getcwd()
df = [f"{curdir}/../../datashare/{gse}/df_{gse}.rds" for gse in gses]
fpip = [f"{curdir}/00_fullpipeline1_{gse}.html" for gse in gses]

    

localrules: target

rule target:
    threads: 1
    message: "-- Rule target completed. --"
    input: 
      df,
      fpip,
    shell:"""
pwd
          """




rule build_gse:
    input: 
      rmd_build="{prefix}/01_build_study_generic.Rmd",
    output: 
      study_rds = "{prefix}/../../datashare/{gse}/study_{gse}.rds",
      df_rds = "{prefix}/../../datashare/{gse}/df_{gse}.rds"    ,           
      html = "{prefix}/01_build_study_{gse}.html"      ,           
    threads: 8
    shell:"""
export PATH="/summer/epistorage/opt/bin:$PATH"
export PATH="/summer/epistorage/miniconda3/envs/R3.6.1_env/bin:$PATH"
cd {wildcards.prefix}

RCODE="Sys.setenv('VROOM_CONNECTION_SIZE'=10000000);gse='{wildcards.gse}' ; print(paste0('#### ',gse,' ####')); rmarkdown::render('01_build_study_generic.Rmd',output_file=paste0('01_build_study_',gse,'.html')); print(paste0(gse,' constructed'));"
echo $RCODE | Rscript - 2>&1 > 01_build_study_{wildcards.gse}.Rout
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

RCODE="gse='{wildcards.gse}' ; rmarkdown::render('00_fullpipeline1.Rmd',output_file=paste0('00_fullpipeline1_',gse,'.html'));print(paste0(gse,'launched'));"
echo $RCODE | Rscript - 2>&1 > 00_fullpipeline1_{wildcards.gse}.Rout
"""
