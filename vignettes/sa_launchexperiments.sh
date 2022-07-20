import os 

with open("ourgses.txt") as f:
    gses = f.read().splitlines() 

curdir = os.getcwd()
results = [f"{curdir}/results_{gse}.rds" for gse in gses]


    

localrules: target

rule target:
    threads: 1
    message: "-- Rule target completed. --"
    input: 
      results
    shell:"""
pwd
          """




rule sa_callpipeline:
    input: 
      df="{prefix}/df_{gse}.rds",
      rmd_script="{prefix}/sa_callpipeline.R",      
      rmd_script_model="{prefix}/04_model.Rmd",      
    output: 
      rds = "{prefix}/results_{gse}.rds"      ,           
    threads: 1
    shell:"""
# export PATH="/summer/epistorage/opt/bin:$PATH"
# export PATH="/summer/epistorage/miniconda3/bin:$PATH"
cd {wildcards.prefix}

RCODE="MODESA=TRUE ; gse='{wildcards.gse}' ; source('sa_callpipeline.R')"
echo $RCODE 
echo $RCODE | Rscript -
"""