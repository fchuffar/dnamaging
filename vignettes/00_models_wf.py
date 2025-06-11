import os 
import os.path

gses_descs = []
gses_ewas = []
gses_model = []

gses = [
  # Epigentic clocks
  # "GSE40279" , # 450k, n=656  # Genome-wide Methylation Profiles Reveal Quantitative Views of Human Aging Rates
  # "GSE42861" , # 450k, n=689  # Differential DNA methylation in Rheumatoid arthritis
  # "GSE87571" , # 450k, n=750  # Continuous Aging of the Human DNA Methylome Throughout the Human Lifespan
  "GSE147740", # Epic, n=1129 # DNA methylation analysis of human peripheral blood mononuclear cell collected in the AIRWAVE study
  "CustGSE147740rr",
  # "GSE152026", # Epic, n=934 # Blood DNA methylation profiles from first episode psychosis patients and controls I
  # # 27k
  # "GSE41037"   # **************27k*************** Aging effects on DNA methylation modules in blood tissue
]


prefix = os.getcwd()
neighb = 1000

runmax=99
info_combp = [f"{prefix}/info_combp_{gse}_modelcalllm_meth~age_{pval_tresh}.rds"  for gse in gses for pval_tresh in ["1e-30", "1e-20", "1e-10", "1e-5"]]

# runmax=2
info_model = [f"{prefix}/info_model_r{runmax}_{gse}_modelcalllm_meth~age_ewas{newas}_nn{neighb}.rds"  for gse in gses for newas in ["1000000"]]
# info_model = [f"{prefix}/info_model_r{runmax}_{gse}_modelcalllm_meth~age_ewas{newas}_nn{neighb}.rds"  for gse in ["GSE42861"] for newas in ["1000"]]


localrules: target, R00_create_empty_expgrpwrapper, R00_create_empty_datawrapper

rule target:
    threads: 1
    message: "-- Rule target completed. --"
    input: 
      # info_combp,
      info_model,
    shell:"""
export PATH="/summer/epistorage/opt/bin:$PATH"
export PATH="/summer/epistorage/miniconda3/envs/dnamaging_env/bin:$PATH"
pwd
RCODE="source('data_info.R')"
echo $RCODE | Rscript - 2>&1 > data_info.Rout
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
export PATH="/summer/epistorage/miniconda3/envs/model_env/bin:$PATH"
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
export PATH="/summer/epistorage/miniconda3/envs/model_env/bin:$PATH"
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
# export PATH="/summer/epistorage/miniconda3/envs/model_env/bin:$PATH"
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
# export PATH="/summer/epistorage/miniconda3/envs/model_env/bin:$PATH"
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
  "51": ["50"],
  "52": ["51"],
  "53": ["52"],
  "54": ["53"],
  "55": ["54"],
  "56": ["55"],
  "57": ["56"],
  "58": ["57"],
  "59": ["58"],
  "60": ["59"],
  "61": ["60"],
  "62": ["61"],
  "63": ["62"],
  "64": ["63"],
  "65": ["64"],
  "66": ["65"],
  "67": ["66"],
  "68": ["67"],
  "69": ["68"],
  "70": ["69"],
  "71": ["70"],
  "72": ["71"],
  "73": ["72"],
  "74": ["73"],
  "75": ["74"],
  "76": ["75"],
  "77": ["76"],
  "78": ["77"],
  "79": ["78"],
  "80": ["79"],
  "81": ["80"],
  "82": ["81"],
  "83": ["82"],
  "84": ["83"],
  "85": ["84"],
  "86": ["85"],
  "87": ["86"],
  "88": ["87"],
  "89": ["88"],
  "90": ["89"],
  "91": ["90"],
  "92": ["91"],
  "93": ["92"],
  "94": ["93"],
  "95": ["94"],
  "96": ["95"],
  "97": ["96"],
  "98": ["97"],
  "99": ["98"],
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
export PATH="/summer/epistorage/miniconda3/envs/model_env/bin:$PATH"
export OMP_NUM_THREADS=1
cd {wildcards.prefix}

TMPDIR=/tmp/wd_r{wildcards.runid}_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}_ewas{wildcards.newas}_nn{wildcards.neighb} 
rm -Rf $TMPDIR
mkdir -p $TMPDIR
cd $TMPDIR
ln -s {wildcards.prefix}/datashare 
cp {input.rmd} {wildcards.prefix}/common.R {wildcards.prefix}/params_default.R  {wildcards.prefix}/params_{wildcards.gse}.R {wildcards.prefix}/litterature_models.rds . || :

RCODE="gse='{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}_ewas{wildcards.newas}_nn{wildcards.neighb}' ;  nb_core=10 ;run={wildcards.runid} ; rmarkdown::render('04_model.Rmd', output_file=paste0('04_model_r', run, '_', gse, '.html'));"
echo $RCODE | Rscript - 2>&1 > 04_model_r{wildcards.runid}_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}_ewas{wildcards.newas}_nn{wildcards.neighb}.Rout

cp  04_model_r{wildcards.runid}_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}_ewas{wildcards.newas}_nn{wildcards.neighb}.html  04_model_r{wildcards.runid}_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}_ewas{wildcards.newas}_nn{wildcards.neighb}.Rout info_model_r{wildcards.runid}_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}_ewas{wildcards.newas}_nn{wildcards.neighb}.rds models_r{wildcards.runid}_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}_ewas{wildcards.newas}_nn{wildcards.neighb}.rds {wildcards.prefix}/. 
cd {wildcards.prefix}
rm -Rf /tmp/wd_{wildcards.gse}
"""





rule R04_combp_call:
    input: 
      bed_ewas = "{prefix}/ewas4combp_{gse}_{modelcall}_meth~{model_formula}.bed",
      rmd = "{prefix}/04_combp.Rmd",
    output: 
      html      = "{prefix}/04_combp_{gse}_{modelcall}_meth~{model_formula}_{pval_thresh}.html",  # "{prefix}/01_idat2study_{gse}.html"   ,
      rout      = "{prefix}/04_combp_{gse}_{modelcall}_meth~{model_formula}_{pval_thresh}.Rout",  # "{prefix}/01_idat2study_{gse}.html"   ,
      info      = "{prefix}/info_combp_{gse}_{modelcall}_meth~{model_formula}_{pval_thresh}.rds",
      dmr_reg   = "{prefix}/dmr_{gse}_{modelcall}_meth~{model_formula}_{pval_thresh}.regions-t.bed",
      dmr_pbs   = "{prefix}/dmr_{gse}_{modelcall}_meth~{model_formula}_{pval_thresh}.fdr.bed.gz",
    threads: 32
    shell:"""
export PATH="/summer/epistorage/opt/bin:$PATH"
export PATH="/summer/epistorage/miniconda3/envs/model_env/bin:$PATH"
export OMP_NUM_THREADS=1
cd {wildcards.prefix}

TMPDIR=/tmp/wd_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}_{wildcards.pval_thresh} 
rm -Rf $TMPDIR
mkdir -p $TMPDIR
cd $TMPDIR
ln -s {wildcards.prefix}/datashare 
cp {input.rmd} {input.bed_ewas} {wildcards.prefix}/common.R {wildcards.prefix}/params_default.R  {wildcards.prefix}/params_{wildcards.gse}.R {wildcards.prefix}/litterature_models.rds . || :

RCODE="gse='{wildcards.gse}' ; model_func_name='{wildcards.modelcall}' ; model_formula='meth~{wildcards.model_formula}' ; pval_thresh='{wildcards.pval_thresh}' ; rmarkdown::render('04_combp.Rmd', output_file=paste0('04_combp_', gse, '_', model_func_name, '_', model_formula, '_', pval_thresh, '.html'));"
echo $RCODE | Rscript - 2>&1 > 04_combp_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}_{wildcards.pval_thresh}.Rout

cp  04_combp_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}_{wildcards.pval_thresh}.html 04_combp_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}_{wildcards.pval_thresh}.Rout info_combp_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}_{wildcards.pval_thresh}.rds dmr_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}_{wildcards.pval_thresh}.regions-t.bed dmr_{wildcards.gse}_{wildcards.modelcall}_meth~{wildcards.model_formula}_{wildcards.pval_thresh}.fdr.bed.gz {wildcards.prefix}/. 
cd {wildcards.prefix}
rm -Rf /tmp/wd_{wildcards.gse}
"""



