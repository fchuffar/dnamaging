import os 
import os.path

curdir = os.getcwd()

gses = [
  
  "GSE40279", 
  "GSE20067", 
  "GSE87571", 
  "GSE151732", 
  "GSE136296", 
  "GSE147740", 
  
  # "GSE40279",
  # "GSE41037",
  # "GSE20067",
  # "GSE50660",
  # "GSE43976",
  # "GSE106648",
  # "GSE42861",
  # "GSE72680",
  # "GSE55763",
  # "GSE87571",
  # "GSE85210",
  # "GSE87648",
  # "GSE89353",
  # "GSE97362",
  # "GSE169156",
  # "GSE154566",
  # "GSE151732",
  # "GSE124413",
  # "GSE136296",
  # "GSE147740",
  # "GSE152026",
  # "GSE56105",
  # "GSE185090",
  # "GSE156274",
  # "GSE140686",
  # "GSE50923",
  # "GSE48461",
  # "GSE104293",
  # "GSE68838",
  # "GSE36278",
  # "GSE60753",
  # "GSE49393",
  
  "GSE41037"  ,
  "GSE136296" ,
  "GSE97362"  ,
  "GSE42861"
]

info_models = [f"{curdir}/info_model_{gse}.rds" for gse in gses]
info_builds = [f"{curdir}/info_build_{gse}.rds" for gse in gses]

localrules: target create_empty_expgrpwrapper create_empty_datawrapper info_gse

rule target:
    threads: 1
    message: "-- Rule target completed. --"
    input: 
      info_builds,
      info_models,
    shell:"""
pwd
RCODE="source('data_info.R')"
echo $RCODE | Rscript - 2>&1 > data_info.Rout
          """



rule create_empty_expgrpwrapper:
    input: 
    output: 
      r_expgrpwrapper="{prefix}/01_expgrpwrapper_{gse}.R",
    threads: 1
    shell:"""
cd {wildcards.prefix}
touch {output.r_expgrpwrapper}
"""

rule create_empty_datawrapper:
    input: 
    output: 
      r_datawrapper="{prefix}/01_datawrapper_{gse}.R",
    threads: 1
    shell:"""
cd {wildcards.prefix}
touch {output.r_datawrapper}
"""        
        
rule build_gse:
    input: 
      rmd_build="{prefix}/01_build_study_generic.Rmd",
      r_datawrapper="{prefix}/01_datawrapper_{gse}.R",
      r_expgrpwrapper="{prefix}/01_expgrpwrapper_{gse}.R",
    output: 
      study_rds =   "{prefix}/datashare/{gse}/study_{gse}.rds",
      df_rds =      "{prefix}/datashare/{gse}/df_{gse}.rds"    ,           
      html =        "{prefix}/01_build_study_{gse}.html"      ,           
      info_build =  "{prefix}/info_build_{gse}.rds"   ,
    threads: 8
    shell:"""
export PATH="/summer/epistorage/opt/bin:$PATH"
export PATH="/summer/epistorage/miniconda3/envs/R3.6.1_env/bin:$PATH"
cd {wildcards.prefix}

rm -Rf /tmp/wd_{wildcards.gse}
mkdir -p /tmp/wd_{wildcards.gse}
cd /tmp/wd_{wildcards.gse}
cp {input.rmd_build} {input.r_datawrapper} {input.r_expgrpwrapper} .

RCODE="gse='{wildcards.gse}' ; print(paste0('#### ',gse,' ####')); rmarkdown::render('01_build_study_generic.Rmd',output_file=paste0('01_build_study_',gse,'.html')); print(paste0(gse,' constructed'));"
echo $RCODE | Rscript - 2>&1 > 01_build_study_{wildcards.gse}.Rout

cp 01_build_study_{wildcards.gse}.Rout info_build_{wildcards.gse}.rds 01_build_study_{wildcards.gse}.html {wildcards.prefix}/.
cd {wildcards.prefix}
rm -Rf /tmp/wd_{wildcards.gse}
"""

rule launch_pipeline:
    input: 
      df="{prefix}/datashare/{gse}/df_{gse}.rds",
      rmd_script="{prefix}/00_fullpipeline1.Rmd",      
      rmd_script_model="{prefix}/04_model.Rmd",      
    output:           
      html =       "{prefix}/00_fullpipeline1_{gse}.html"      ,           
      info_desc  = "{prefix}/info_desc_{gse}.rds"      ,           
      info_model = "{prefix}/info_model_{gse}.rds"      ,           
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

cp 00_fullpipeline1_{wildcards.gse}.html 00_fullpipeline1_{wildcards.gse}.Rout info_desc_{wildcards.gse}.rds info_model_{wildcards.gse}.rds {wildcards.prefix}/. 
cd {wildcards.prefix}
rm -Rf /tmp/wd_{wildcards.gse}
"""
