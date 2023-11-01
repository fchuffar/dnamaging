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
info_ewas_neighb = [f"{prefix}/info_ewas_neighb_{gse}_modelcalllm_meth~age_ewas{newas}_nn{neighb}.rds"  for gse in gses for newas in ["1000", "2000"]]

localrules: target, R00_create_empty_expgrpwrapper, R00_create_empty_datawrapper

rule target:
    threads: 1
    message: "-- Rule target completed. --"
    input: 
      info_ewas_neighb,
    shell:"""
export PATH="/summer/epistorage/opt/bin:$PATH"
export PATH="/summer/epistorage/miniconda3/envs/dnamaging_env/bin:$PATH"
pwd
RCODE="source('data_info.R')"
echo $RCODE | Rscript - 2>&1 > data_info.Rout
          """

include: "rules.py"

