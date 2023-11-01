rule R02_stat_preproc: 
    input: 
      rmd = "{prefix}/02_stat_preproc.Rmd",   
      study  = "{prefix}/datashare/{gse}/study_{gse}.rds",  
    output:           
      html =       "{prefix}/02_stat_preproc_{gse}.html"  ,         
      info =       "{prefix}/info_desc_{gse}.rds"         ,           
      study_preproc  = "{prefix}/datashare/{gse}/study_preproc_{gse}.rds",  
    threads: 32
    shell:"""
export PATH="/summer/epistorage/opt/bin:$PATH"
export PATH="/summer/epistorage/miniconda3/envs/dnamaging_env/bin:$PATH"
export OMP_NUM_THREADS=1
cd {wildcards.prefix}

TMPDIR=/tmp/wd_{wildcards.gse}
rm -Rf $TMPDIR
mkdir -p $TMPDIR
cd $TMPDIR
ln -s {wildcards.prefix}/datashare 
cp {input.rmd} {wildcards.prefix}/common.R {wildcards.prefix}/params_default.R  {wildcards.prefix}/params_{wildcards.gse}.R . || :

RCODE="gse='{wildcards.gse}' ; rmarkdown::render('02_stat_preproc.Rmd',output_file=paste0('02_stat_preproc_',gse,'.html')) ;"
echo $RCODE | Rscript - 2>&1 > 02_stat_preproc_{wildcards.gse}.Rout

cp 02_stat_preproc_{wildcards.gse}.html 02_stat_preproc_{wildcards.gse}.Rout info_desc_{wildcards.gse}.rds {wildcards.prefix}/. 
cd {wildcards.prefix}
rm -Rf /tmp/wd_{wildcards.gse}
"""

rule R03_ewas_ewcpr:
    input:
      rmd = "{prefix}/03_ewas_ewcpr.Rmd",
      study  = "{prefix}/datashare/{gse}/study_preproc_{gse}.rds",
    output:
      html    = "{prefix}/03_ewas_ewcpr_{gse}_{modelcall}_meth~{model_formula}.html"    ,
      rout    = "{prefix}/03_ewas_ewcpr_{gse}_{modelcall}_meth~{model_formula}.Rout"    ,
      info    = "{prefix}/info_ewas_ewcpr_{gse}_{modelcall}_meth~{model_formula}.rds",
      bed_ewas = "{prefix}/ewas4combp_{gse}_{modelcall}_meth~{model_formula}.bed",
      rds_ewas = "{prefix}/ewas_{gse}_{modelcall}_meth~{model_formula}.rds"      ,
    threads: 32
    shell:"""
export PATH="/summer/epistorage/opt/bin:$PATH"
export PATH="/summer/epistorage/miniconda3/envs/dnamaging_env/bin:$PATH"
export OMP_NUM_THREADS=1
cd {wildcards.prefix}

TMPDIR=/tmp/wd_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}
rm -Rf $TMPDIR
mkdir -p $TMPDIR
cd $TMPDIR
ln -s {wildcards.prefix}/datashare
cp {input.rmd} {wildcards.prefix}/common.R {wildcards.prefix}/params_default.R  {wildcards.prefix}/params_{wildcards.gse}.R . || :

RCODE="gse='{wildcards.gse}'; model_func_name = '{wildcards.modelcall}' ; model_formula='meth~{wildcards.model_formula}' ; rmarkdown::render('03_ewas_ewcpr.Rmd', output_file=paste0('03_ewas_ewcpr_', gse, '_', model_func_name, '_', model_formula, '.html'))"
echo $RCODE | Rscript - 2>&1 > 03_ewas_ewcpr_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}.Rout

cp  03_ewas_ewcpr_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}.html  03_ewas_ewcpr_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}.Rout  ewas_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}.rds ewas4combp_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}.bed info_ewas_ewcpr_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}.rds {wildcards.prefix}/.
cd {wildcards.prefix}
rm -Rf /tmp/wd_{wildcards.gse}
"""





rule R03_ewas_neighb: 
    input: 
      rmd      = "{prefix}/03_ewas_neighb.Rmd",     
      bed_ewas = "{prefix}/ewas4combp_{gse}_{modelcall}_meth~{model_formula}.bed",           
      rds_ewas = "{prefix}/ewas_{gse}_{modelcall}_meth~{model_formula}.rds"      ,           
      study    = "{prefix}/datashare/{gse}/study_preproc_{gse}.rds",
    output:           
      html      = "{prefix}/03_ewas_neighb_{gse}_{modelcall}_meth~{model_formula}_ewas{newas}_nn{neighb}.html"    ,       
      rout      = "{prefix}/03_ewas_neighb_{gse}_{modelcall}_meth~{model_formula}_ewas{newas}_nn{neighb}.Rout"    ,            
      info      = "{prefix}/info_ewas_neighb_{gse}_{modelcall}_meth~{model_formula}_ewas{newas}_nn{neighb}.rds",
      study_rds = "{prefix}/datashare/{gse}/study_preproc_{gse}_{modelcall}_meth~{model_formula}_ewas{newas}_nn{neighb}.rds",
      df_preproc = "{prefix}/datashare/{gse}/df_preproc_{gse}_{modelcall}_meth~{model_formula}_ewas{newas}_nn{neighb}.rds",
      df_preproc_r0 = "{prefix}/datashare/{gse}/df_preproc_r0_{gse}_{modelcall}_meth~{model_formula}_ewas{newas}_nn{neighb}.rds",
    threads: 32
    shell:"""
export PATH="/summer/epistorage/opt/bin:$PATH"
export PATH="/summer/epistorage/miniconda3/envs/dnamaging_env/bin:$PATH"
export OMP_NUM_THREADS=1
cd {wildcards.prefix}

TMPDIR=/tmp/wd_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}_ewas{wildcards.newas}_nn{wildcards.neighb} 
rm -Rf $TMPDIR
mkdir -p $TMPDIR
cd $TMPDIR
ln -s {wildcards.prefix}/datashare 
cp {input.rmd} {input.bed_ewas} {input.rds_ewas} {wildcards.prefix}/common.R {wildcards.prefix}/params_default.R  {wildcards.prefix}/params_{wildcards.gse}.R . || :

RCODE="gse='{wildcards.gse}' ; model_func_name='{wildcards.modelcall}' ; model_formula='meth~{wildcards.model_formula}' ; newas='{wildcards.newas}'; neighb='{wildcards.neighb}'; rmarkdown::render('03_ewas_neighb.Rmd', output_file=paste0('03_ewas_neighb_', gse, '_', model_func_name, '_', model_formula, '_ewas', newas, '_nn', neighb, '.html'))"
echo $RCODE | Rscript - 2>&1 > 03_ewas_neighb_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}_ewas{wildcards.newas}_nn{wildcards.neighb}.Rout

cp  03_ewas_neighb_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}_ewas{wildcards.newas}_nn{wildcards.neighb}.html  03_ewas_neighb_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}_ewas{wildcards.newas}_nn{wildcards.neighb}.Rout info_ewas_neighb_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}_ewas{wildcards.newas}_nn{wildcards.neighb}.rds {wildcards.prefix}/. 
cd {wildcards.prefix}
rm -Rf /tmp/wd_{wildcards.gse}
"""



# rule R03_ewas:
#     input:
#       rmd = "{prefix}/03_ewas.Rmd",
#       df  = "{prefix}/df_preproc_{gse}.rds",
#     output:
#       html    = "{prefix}/03_ewas{nbewasprobes}_{gse}.html"    ,
#       rout    = "{prefix}/03_ewas{nbewasprobes}_{gse}.Rout"    ,
#       df_ewas = "{prefix}/df_r0_ewas{nbewasprobes}_{gse}.rds"  ,
#       info    = "{prefix}/info_ewas{nbewasprobes}_{gse}.rds",
#     threads: 32
#     shell:"""
# export PATH="/summer/epistorage/opt/bin:$PATH"
# export PATH="/summer/epistorage/miniconda3/envs/dnamaging_env/bin:$PATH"
# export OMP_NUM_THREADS=1
# cd {wildcards.prefix}
#
# rm -Rf /tmp/wd_{wildcards.gse}
# mkdir -p /tmp/wd_{wildcards.gse}
# cd /tmp/wd_{wildcards.gse}
# ln -s {wildcards.prefix}/datashare
# ln -s {wildcards.prefix}/df_preproc_{wildcards.gse}.rds
# ln -s {wildcards.prefix}/litterature_models.rds
# cp {wildcards.prefix}/*.Rmd {wildcards.prefix}/*.R .
#
# RCODE="gse='{wildcards.gse}' ; nbewasprobes={wildcards.nbewasprobes}; rmarkdown::render('03_ewas.Rmd',output_file=paste0('03_ewas', nbewasprobes,'_',gse, '.html'));"
# echo $RCODE | Rscript - 2>&1 > 03_ewas{wildcards.nbewasprobes}_{wildcards.gse}.Rout
#
# cp 03_ewas{wildcards.nbewasprobes}_{wildcards.gse}.html 03_ewas{wildcards.nbewasprobes}_{wildcards.gse}.Rout df_r0_ewas{wildcards.nbewasprobes}_{wildcards.gse}.rds info_ewas{wildcards.nbewasprobes}_{wildcards.gse}.rds {wildcards.prefix}/.
# cd {wildcards.prefix}
# rm -Rf /tmp/wd_{wildcards.gse}
# """

# rule R04_model:
#     input:
#       rmd = "{prefix}/04_model.Rmd",
#       df  = "{prefix}/df_r0_ewas{nbewasprobes}_{gse}.rds",
#     output:
#       html = "{prefix}/04_model_r{runmax}_ewas{nbewasprobes}_{gse}.html"      ,
#       info = "{prefix}/info_model_r{runmax}_ewas{nbewasprobes}_{gse}.rds"     , #delete nbewasprobes or make 2 nbewasprobes
#     threads: 32
#     shell:"""
# export PATH="/summer/epistorage/opt/bin:$PATH"
# export PATH="/summer/epistorage/miniconda3/envs/dnamaging_env/bin:$PATH"
# export OMP_NUM_THREADS=1
# cd {wildcards.prefix}
#
# rm -Rf /tmp/wd_{wildcards.gse}
# mkdir -p /tmp/wd_{wildcards.gse}
# cd /tmp/wd_{wildcards.gse}
# ln -s {wildcards.prefix}/datashare
# ln -s {input.df}
# ln -s {wildcards.prefix}/df_preproc_{wildcards.gse}.rds
# ln -s {wildcards.prefix}/litterature_models.rds
# cp {wildcards.prefix}/*.Rmd {wildcards.prefix}/*.R .
#
# for RUN in `seq -w 0 {wildcards.runmax}`
# do
#   RCODE="gse='{wildcards.gse}' ; run=${{RUN}}; nbewasprobes={wildcards.nbewasprobes}; nb_core=6; rmarkdown::render('04_model.Rmd', output_file=paste0('04_model_r',run,'_ewas',nbewasprobes,'_',gse,'.html'));"
#   echo $RCODE
#   echo $RCODE | Rscript - 2>&1 > 04_model_r${{RUN}}_ewas{wildcards.nbewasprobes}_{wildcards.gse}.Rout
# done
#
# cp 04_model_r*_ewas{wildcards.nbewasprobes}_{wildcards.gse}.html 04_model_r*_ewas{wildcards.nbewasprobes}_{wildcards.gse}.Rout   info_model_r*_ewas{wildcards.nbewasprobes}_{wildcards.gse}.rds {wildcards.prefix}/.
#
# cd {wildcards.prefix}
# rm -Rf /tmp/wd_{wildcards.gse}
# """



run_prerequisits = {
  "0": [],
  "1": ["0"],
  "2": ["1"],
  "3": ["2"],
  "4": ["3"],
  "5": ["4"],
  "6": ["5"],
  "7": ["6"],
  "8": ["7"],
  "9": ["8"],
  "10": ["9"],
  "11": ["10"],
  "12": ["11"],
  "13": ["12"],
  "14": ["13"],
  "15": ["14"],
  "16": ["15"],
  "17": ["16"],
  "18": ["17"],
  "19": ["18"],
  "20": ["19"],
  "21": ["20"],
  "22": ["21"],
  "23": ["22"],
  "24": ["23"],
  "25": ["24"],
  "26": ["25"],
  "27": ["26"],
  "28": ["27"],
  "29": ["28"],
  "30": ["29"],
  "31": ["30"],
  "32": ["31"],
  "33": ["32"],
  "34": ["33"],
  "35": ["34"],
  "36": ["35"],
  "37": ["36"],
  "38": ["37"],
  "39": ["38"],
  "40": ["39"],
  "41": ["40"],
  "42": ["41"],
  "43": ["42"],
  "44": ["43"],
  "45": ["44"],
  "46": ["45"],
  "47": ["46"],
  "48": ["47"],
  "49": ["48"],
  "50": ["49"],
}

rule R04_itera_model_call:
    input: 
      lambda wildcards: expand("{prefix}/04_model_r{prevrunid}_{gse}_{modelcall}_meth~{model_formula}_ewas{newas}_nn{neighb}.html",
        newas =wildcards.newas ,
        neighb=wildcards.neighb,
        gse   =wildcards.gse   ,
        prefix=wildcards.prefix,
        modelcall=wildcards.modelcall,
        model_formula=wildcards.model_formula,
        prevrunid=run_prerequisits[wildcards.runid]),
      df_preproc = "{prefix}/datashare/{gse}/df_preproc_{gse}_{modelcall}_meth~{model_formula}_ewas{newas}_nn{neighb}.rds",
      rmd = "{prefix}/04_model.Rmd",
    output: 
      html      = "{prefix}/04_model_r{runid}_{gse}_{modelcall}_meth~{model_formula}_ewas{newas}_nn{neighb}.html",  # "{prefix}/01_idat2study_{gse}.html"   ,
      rout      = "{prefix}/04_model_r{runid}_{gse}_{modelcall}_meth~{model_formula}_ewas{newas}_nn{neighb}.Rout",  # "{prefix}/01_idat2study_{gse}.html"   ,
      info      = "{prefix}/info_model_r{runid}_{gse}_{modelcall}_meth~{model_formula}_ewas{newas}_nn{neighb}.rds",
      model_rds = "{prefix}/models_r{runid}_{gse}_{modelcall}_meth~{model_formula}_ewas{newas}_nn{neighb}.rds",
    threads: 32
    shell:"""
export PATH="/summer/epistorage/opt/bin:$PATH"
export PATH="/summer/epistorage/miniconda3/envs/dnamaging_env/bin:$PATH"
export OMP_NUM_THREADS=1
cd {wildcards.prefix}

TMPDIR=/tmp/wd_r{wildcards.runid}_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}_ewas{wildcards.newas}_nn{wildcards.neighb} 
rm -Rf $TMPDIR
mkdir -p $TMPDIR
cd $TMPDIR
ln -s {wildcards.prefix}/datashare 
cp {input.rmd} {wildcards.prefix}/common.R {wildcards.prefix}/params_default.R  {wildcards.prefix}/params_{wildcards.gse}.R {wildcards.prefix}/litterature_models.rds . || :

RCODE="gse='{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}_ewas{wildcards.newas}_nn{wildcards.neighb}' ; run={wildcards.runid} ; rmarkdown::render('04_model.Rmd', output_file=paste0('04_model_r', run, '_', gse, '.html'));"
echo $RCODE | Rscript - 2>&1 > 04_model_r{wildcards.runid}_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}_ewas{wildcards.newas}_nn{wildcards.neighb}.Rout

cp  04_model_r{wildcards.runid}_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}_ewas{wildcards.newas}_nn{wildcards.neighb}.html  04_model_r{wildcards.runid}_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}_ewas{wildcards.newas}_nn{wildcards.neighb}.Rout info_model_r{wildcards.runid}_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}_ewas{wildcards.newas}_nn{wildcards.neighb}.rds models_r{wildcards.runid}_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}_ewas{wildcards.newas}_nn{wildcards.neighb}.rds {wildcards.prefix}/. 
cd {wildcards.prefix}
rm -Rf /tmp/wd_{wildcards.gse}
"""


