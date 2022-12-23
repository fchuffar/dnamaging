import os 
import os.path

curdir = os.getcwd()

gses = [
  # "GSE20067",   NO GO  best_model_bs   "incorrect number of dimensions" FCh: problem in selecting probes?
  "GSE36278",         # 450k, primary glioblastoma
  "GSE40279",         # Hannum
  "GSE42861",         # 450k 
  # "GSE43976",     # PROBLEM gse='GSE43976' ; run=1; nbewasprobes=3000; nb_core=6; rmarkdown::render('04_model.Rmd');       # 450k, PB, tobacco # error in
  # "GSE55763",   NO GO # need to write wrappers (exp_grp and data, boths) n=2711, blood 450k
  # "GSE48461",     # PROBLEM gse="GSE48461" ; r=2 ;rmarkdown::render("04_model.Rmd") ;  # 450k, glioma
  # "GSE49393",     # PROBLEM gse="GSE49393" ; run=1; nbewasprobes=3000; nb_core=6; rmarkdown::render('04_model.Rmd');               # Brain, Alcohol, n=48, 450k ; 50000 probes == NA
  "GSE50660",         # 450k, tobacco
  # "GSE50923",   NO GO, gse="GSE50923"; rmarkdown::render("02_stat_preproc.Rmd")#no age covariate          # 27k glioma  # GBM vs. normal brain # 
  # "GSE56105",   NO GO # 450k, n=600 # MZ and DZ twin pairs, their siblings and their parents. # could not directly load beta matrix from GEO API for GSE56105
  # "GSE60753",       # 450k # Alcohol # No age
  # "GSE68838",       # TCGA COAD
  # "GSE72680",   NO GO gse="GSE72680" ; source(knitr::purl("01_build_study_generic.Rmd"))   # 450k #Trauma, # n= 422 
                  
  "GSE97362",     
                  
  # "GSE85210",   NO GO gse="GSE85210" ; source(knitr::pu         rl("01_build_study_generic.Rmd"))    # 450k # n=250 # tobacco # no age  
  # "GSE87571",   NO GO gse="GSE87571" ; source(knitr::purl("01_build_study_generic.Rmd"))    # 450k # n=750 
  # "GSE87648",   NO GO gse="GSE87648" ; source(knitr::purl("01_build_study_generic.Rmd"))    # 450k # n=350 # Bowel Disease
  "GSE89353",         # n=600 # 450k # Epimutations as a novel cause of congenital disorders # Proband
  # "GSE104293",    # PROBLEM gse="GSE104293" ; r=2 ;rmarkdown::render("04_model.Rmd") ;    # Glioma # n=130 # 450k
  "GSE106648",        # 450k # n= 279 # Multiple Sclerosis
  # "GSE124413",  NO GO # gse="GSE124413" ; source(knitr::purl("01_build_study_generic.Rmd"))    # Epic # n=500 # childhood acute myeloid leukemia (AML)
  "GSE136296" ,       # Epic # Pan troglodytes # n=113
  # "GSE140686",  NO GO  mixed 450k & EPIC # n=1500  sarcoma samples  
  # "GSE147740",  NO GO gse="GSE147740"; rmarkdown::render("01_build_study_generic.Rmd")
  "GSE151732",        # Epic # n=250 # Right versus the Left Colon
  # "GSE152026",  NO GO #  could not directly load beta matrix from GEO API for GSE152026. # Epic, n=1000 # psychosis patients
  # "GSE154566",  NO GO  could not directly load beta matrix from GEO API for GSE154566 # n=1000 # monozygotic twin sample
  # "GSE156274",  NO GO  6 samples
  # "GSE156374",  NO GO # GES Epilepto # few probes on GEO
  # "GSE169156",  NO GO # could not directly load beta matrix from GEO API for GSE169156 # n=2000 # Childhood Cancer Survivors
  # "GSE185090"   NO GO # no cofactor on GEO
  
  "GSE41037"   # **************27k***************
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
      info_builds,
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
    threads: 32
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
