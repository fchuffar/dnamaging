import os 
import os.path

curdir = os.getcwd()

gses = [
  # "GSE20067",  best_model_bs   "incorrect number of dimensions" problem in selecting probes?
  # "GSE36278",
  
  "GSE41037",
  "GSE42861",
  
  # "GSE43976",
  # "GSE50660",
  # "GSE55763",
  # "GSE48461",
  # "GSE49393",
  # "GSE50923",
  # "GSE56105",
  # "GSE60753",
  # "GSE68838",
  # "GSE72680",
  
  "GSE97362",
  
  # "GSE85210",
  # "GSE87571", 
  # "GSE87648",
  # "GSE89353",
  # "GSE104293",
  # "GSE106648",
  # "GSE124413",
  
  "GSE136296" ,
  
  # "GSE140686",
  
  "GSE147740", 
  
  # "GSE151732", problem y_key var is "age" but not numeric
  # "GSE152026",
  # "GSE154566",
  # "GSE156274",
  # "GSE169156",
  # "GSE185090"
  
  "GSE40279"
]

info_models = [f"{curdir}/info_model_{gse}.rds" for gse in gses]
info_builds = [f"{curdir}/info_build_{gse}.rds" for gse in gses]

nb_probes = 3000 

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

rule stat_preproc: 
    input: 
      rmd_stat_preproc="{prefix}/02_stat_preproc.Rmd",   
      df="{prefix}/datashare/{gse}/df_{gse}.rds",  
    output:           
      html =       "{prefix}/02_stat_preproc_{gse}.html"  ,         
      info_desc  = "{prefix}/info_desc_{gse}.rds"      ,           
      df_preproc = "{prefix}/df_preproc_{gse}.rds"      ,           
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

RCODE="gse='{wildcards.gse}' ; nb_core=6; rmarkdown::render('02_stat_preproc.Rmd',output_file=paste0('02_stat_preproc_',gse,'.html'));print(paste0(gse,'preprocessed'));"
echo $RCODE | Rscript - 2>&1 > 02_stat_preproc_{wildcards.gse}.Rout

cp 02_stat_preproc_{wildcards.gse}.html 02_stat_preproc_{wildcards.gse}.Rout info_desc_{wildcards.gse}.rds df_preproc_{wildcards.gse}.rds {wildcards.prefix}/. 
cd {wildcards.prefix}
rm -Rf /tmp/wd_{wildcards.gse}
"""

rule EWAS: 
    input: 
      rmd_EWAS="{prefix}/03_EWAS.Rmd",     
      df="{prefix}/df_preproc_{gse}.rds",
    output:           
      html =       "{prefix}/03_EWAS_{gse}_{nb_probes}.html"    ,       
      df_EWAS  = "{prefix}/df_{gse}_EWAS_{nb_probes}.rds"      ,            
    threads: 32
    shell:"""
export PATH="/summer/epistorage/opt/bin:$PATH"
export PATH="/summer/epistorage/miniconda3/envs/R3.6.1_env/bin:$PATH"
cd {wildcards.prefix}

rm -Rf /tmp/wd_{wildcards.gse}
mkdir -p /tmp/wd_{wildcards.gse}
cd /tmp/wd_{wildcards.gse}
ln -s {wildcards.prefix}/df_preproc_{wildcards.gse}.rds
ln -s {wildcards.prefix}/litterature_models.rds
cp {wildcards.prefix}/*.Rmd {wildcards.prefix}/*.R .

RCODE="gse='{wildcards.gse}' ; nbewasprobes = '{wildcards.nb_probes}'; nb_core=6; rmarkdown::render('03_EWAS.Rmd',output_file=paste0('03_EWAS_',gse,'_',nbewasprobes,'.html'));print(paste0(gse,'EWAS done'));"
echo $RCODE | Rscript - 2>&1 > 03_EWAS_{wildcards.gse}_{wildcards.nb_probes}.Rout

cp 03_EWAS_{wildcards.gse}_{wildcards.nb_probes}.html 03_EWAS_{wildcards.gse}_{wildcards.nb_probes}.Rout df_{wildcards.gse}_EWAS_{wildcards.nb_probes}.rds {wildcards.prefix}/. 
cd {wildcards.prefix}
rm -Rf /tmp/wd_{wildcards.gse}
"""

rule model:
    input: 
      rmd_model="{prefix}/04_model.Rmd",
      df="{prefix}/df_{gse}_EWAS_{nb_probes}.rds",            
    output:           
      html =       "{prefix}/04_model_{gse}_{nb_probes}.html"      ,           
      info_model = "{prefix}/info_model_{gse}_{nb_probes}.rds"      , #delete nb_probes or make 2 nb_probes           
    threads: 32
    shell:"""
export PATH="/summer/epistorage/opt/bin:$PATH"
export PATH="/summer/epistorage/miniconda3/envs/R3.6.1_env/bin:$PATH"
cd {wildcards.prefix}

rm -Rf /tmp/wd_{wildcards.gse}
mkdir -p /tmp/wd_{wildcards.gse}
cd /tmp/wd_{wildcards.gse}
ln -s {wildcards.prefix}/df_{wildcards.gse}_EWAS_{wildcards.nb_probes}.rds
ln -s {wildcards.prefix}/litterature_models.rds
cp {wildcards.prefix}/*.Rmd {wildcards.prefix}/*.R .

RCODE="gse='{wildcards.gse}' ; nbewasprobes = '{wildcards.nb_probes}'; nb_core=6; rmarkdown::render('04_model.Rmd',output_file=paste0('04_model_',gse,'_',nbewasprobes,'.html'));print(paste0(gse,'model done'));"
echo $RCODE | Rscript - 2>&1 > 04_model_{wildcards.gse}_{wildcards.nb_probes}.Rout

cp 04_model_{wildcards.gse}_{wildcards.nb_probes}.html 04_model_{wildcards.gse}_{wildcards.nb_probes}.Rout info_model_{wildcards.gse}_{wildcards.nb_probes}.rds {wildcards.prefix}/. 
cd {wildcards.prefix}
rm -Rf /tmp/wd_{wildcards.gse}
"""
