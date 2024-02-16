import os 
import os.path

gses_descs = []
gses_ewas = []
gses_model = []

gses = [
  "GSE40279" , # 450k, n=656  # Genome-wide Methylation Profiles Reveal Quantitative Views of Human Aging Rates
  "GSE42861" , # 450k, n=689  # Differential DNA methylation in Rheumatoid arthritis
  "GSE87571" , # 450k, n=750  # Continuous Aging of the Human DNA Methylome Throughout the Human Lifespan
]

prefix = os.getcwd()
neighb = 1000

runmax=50
info_combp = [f"{prefix}/info_combp_{gse}_modelcalllm_meth~age_{pval_tresh}.rds"  for gse in gses for pval_tresh in ["1e-30", "1e-20", "1e-10", "1e-5"]]

# runmax=2
# info_model = [f"{prefix}/info_model_r{runmax}_{gse}_modelcalllm_meth~age_ewas{newas}_nn{neighb}.rds"  for gse in gses for newas in ["1000", "2000", "3000"]]


localrules: target, R00_create_empty_expgrpwrapper, R00_create_empty_datawrapper

rule target:
    threads: 1
    message: "-- Rule target completed. --"
    input: 
      info_combp,
    shell:"""
export PATH="/summer/epistorage/opt/bin:$PATH"
export PATH="/summer/epistorage/miniconda3/envs/dnamaging_env/bin:$PATH"
pwd
RCODE="source('data_info.R')"
echo $RCODE | Rscript - 2>&1 > data_info.Rout
          """

include: "rules.py"

