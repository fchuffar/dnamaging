import os 
import os.path

curdir = os.getcwd()

gses = [
  # "GSE20067",  best_model_bs   "incorrect number of dimensions" problem in selecting probes?
  # "GSE36278",
  
  "GSE41037",   # 27k
  "GSE42861",   # 450k
  
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
  
  # "GSE140686", # Do not work
  
  "GSE147740",
  
  # "GSE151732", problem y_key var is "age" but not numeric
  # "GSE152026",
  # "GSE154566",
  # "GSE156274",
  # "GSE169156",
  # "GSE185090"
  
  "GSE40279"
]



nbewasprobes=3000
runmax=2
info_models = [f"{curdir}/info_model_ewas3000_{foo}.rds" for foo in gses]
info_builds = [f"{curdir}/info_build_{gse}.rds" for gse in gses]
html_models =  [f"{curdir}/04_model_r{runmax}_ewas{nbewasprobes}_{gse}.html" for gse in gses]


localrules: target create_empty_expgrpwrapper create_empty_datawrapper info_gse

rule target:
    threads: 1
    message: "-- Rule target completed. --"
    input: 
      # info_builds,
      # info_models,
      html_models,
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

RCODE="gse='{wildcards.gse}'; rmarkdown::render('01_build_study_generic.Rmd', output_file=paste0('01_build_study_',gse,'.html'));"
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

rule run_ewas: 
    input: 
      rmd_ewas="{prefix}/03_ewas.Rmd",     
      df="{prefix}/df_preproc_{gse}.rds",
    output:           
      html    = "{prefix}/03_ewas{nbewasprobes}_{gse}.html"    ,       
      rout    = "{prefix}/03_ewas{nbewasprobes}_{gse}.Rout"      ,            
      df_ewas = "{prefix}/df_r0_ewas{nbewasprobes}_{gse}.rds"      ,            
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

RCODE="gse='{wildcards.gse}' ; nbewasprobes={wildcards.nbewasprobes}; rmarkdown::render('03_ewas.Rmd',output_file=paste0('03_ewas', nbewasprobes,'_',gse, '.html'));"
echo $RCODE | Rscript - 2>&1 > 03_ewas{wildcards.nbewasprobes}_{wildcards.gse}.Rout

cp 03_ewas{wildcards.nbewasprobes}_{wildcards.gse}.html 03_ewas{wildcards.nbewasprobes}_{wildcards.gse}.Rout df_r0_ewas{wildcards.nbewasprobes}_{wildcards.gse}.rds {wildcards.prefix}/. 
cd {wildcards.prefix}
rm -Rf /tmp/wd_{wildcards.gse}
"""

rule model:
    input: 
      rmd_model="{prefix}/04_model.Rmd",
      df="{prefix}/df_r0_ewas{nbewasprobes}_{gse}.rds",            
    output:           
      html =       "{prefix}/04_model_r{runmax}_ewas{nbewasprobes}_{gse}.html"      ,           
      # info_model = "{prefix}/info_model_ewas{nbewasprobes}_{gse}.rds"      , #delete nbewasprobes or make 2 nbewasprobes
    threads: 32
    shell:"""
export PATH="/summer/epistorage/opt/bin:$PATH"
export PATH="/summer/epistorage/miniconda3/envs/R3.6.1_env/bin:$PATH"
cd {wildcards.prefix}

rm -Rf /tmp/wd_{wildcards.gse}
mkdir -p /tmp/wd_{wildcards.gse}
cd /tmp/wd_{wildcards.gse}
ln -s {input.df}
ln -s {wildcards.prefix}/df_preproc_{wildcards.gse}.rds
ln -s {wildcards.prefix}/litterature_models.rds
cp {wildcards.prefix}/*.Rmd {wildcards.prefix}/*.R .

for RUN in `seq -w 0 {wildcards.runmax}`  
do 
  RCODE="gse='{wildcards.gse}' ; run=${{RUN}}; nbewasprobes={wildcards.nbewasprobes}; nb_core=6; rmarkdown::render('04_model.Rmd', output_file=paste0('04_model_r',run,'_ewas',nbewasprobes,'_',gse,'.html'));"
  echo $RCODE 
  echo $RCODE | Rscript - 2>&1 > 04_model_r${{RUN}}_ewas{wildcards.nbewasprobes}_{wildcards.gse}.Rout
done 

cp 04_model_r*_ewas{wildcards.nbewasprobes}_{wildcards.gse}.html 04_model_r*_ewas{wildcards.nbewasprobes}_{wildcards.gse}.Rout   info_model_r*_ewas{wildcards.nbewasprobes}_{wildcards.gse}.rds {wildcards.prefix}/. 

cd {wildcards.prefix}
rm -Rf /tmp/wd_{wildcards.gse}
"""
