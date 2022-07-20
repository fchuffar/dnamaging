import os 

with open("ourgses.txt") as f:
    gses = f.read().splitlines() 

curdir = os.getcwd()
results = [f"{curdir}/wd_{gse}/results_{gse}.rds" for gse in gses]


    

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
      rds = "{prefix}/wd_{gse}/results_{gse}.rds"      ,           
      html = "{prefix}/wd_{gse}/00_fullpipeline1_{gse}.html"      ,           
    threads: 1
    shell:"""
# export PATH="/summer/epistorage/opt/bin:$PATH"
# export PATH="/summer/epistorage/miniconda3/bin:$PATH"
cd {wildcards.prefix}

mkdir -p wd_{wildcards.gse}
cd wd_{wildcards.gse}
rm -Rf df_{wildcards.gse}.rds
ln -s ../df_{wildcards.gse}.rds
RCODE="MODESA=TRUE ; gse='{wildcards.gse}' ; source('../sa_callpipeline.R')"
echo $RCODE 
echo $RCODE | Rscript -
"""
