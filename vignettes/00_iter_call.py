import os 
import os.path

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



prefix = os.getcwd()
# info_idat  = [f"{prefix}/01_idat2study_{gse}.html" for gse in gses]
html_target  = [f"{prefix}/04_model_r50_ewas{newas}_nn1000_GSE42861.html" for newas in ["1000", "2000", "3000", "5000", "10000", "20000", "30000", "50000", "100000", "200000", "300000"]]
# html_target  = [f"{prefix}/04_model_r50_ewas{newas}_nn1000_GSE42861.html" for newas in ["200"]]
# html_target  = [f"{prefix}/04_model_r2_ewas{newas}_nn1000_GSE42861.html" for newas in ["100"]]

localrules: target 

rule target:
    threads: 1
    message: "-- Rule target completed. --"
    input:
      html_target, 
      # info_idat,
    shell:"""
export PATH="/summer/epistorage/opt/bin:$PATH"
export PATH="/summer/epistorage/miniconda3/envs/dnamaging_env/bin:$PATH"
pwd
# RCODE="source('data_info.R')"
# echo $RCODE | Rscript - 2>&1 > data_info.Rout
          """
        
rule R01_itera_model_call:
    input: 
      lambda wildcards: expand("{prefix}/04_model_r{prevrunid}_ewas{newas}_nn{neight}_{gse}.html",
        newas =wildcards.newas ,
        neight=wildcards.neight,
        gse   =wildcards.gse   ,
        prefix=wildcards.prefix,
        prevrunid=run_prerequisits[wildcards.runid]),
      # df_rds = "{prefix}/df_r{runid}_ewas{newas}_nn{neight}_{gse}.rds",
      rmd = "{prefix}/04_model.Rmd",
    output: 
      html      = "{prefix}/04_model_r{runid}_ewas{newas}_nn{neight}_{gse}.html",  # "{prefix}/01_idat2study_{gse}.html"   ,
      rout      = "{prefix}/04_model_r{runid}_ewas{newas}_nn{neight}_{gse}.Rout",  # "{prefix}/01_idat2study_{gse}.html"   ,
    threads: 32
    shell:"""
export PATH="/summer/epistorage/opt/bin:$PATH"
export PATH="/summer/epistorage/miniconda3/envs/dnamaging_env/bin:$PATH"
export OMP_NUM_THREADS=1

RCODE="gse='{wildcards.gse}_modelcalllm_meth~age_ewas{wildcards.newas}_nn{wildcards.neight}' ; run={wildcards.runid} ; newas='{wildcards.newas}'; neight={wildcards.neight}; rmarkdown::render('04_model.Rmd', output_file='{output.html}');"
echo $RCODE | Rscript - 2>&1 > {output.rout}
"""
