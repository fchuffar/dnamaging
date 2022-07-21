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
      html = "{prefix}/00_fullpipeline1_{gse}.html"      ,           
    threads: 1
    shell:"""
# export PATH="/summer/epistorage/opt/bin:$PATH"
# export PATH="/summer/epistorage/miniconda3/bin:$PATH"
cd {wildcards.prefix}

rm -Rf /tmp/wd_{wildcards.gse}
mkdir -p /tmp/wd_{wildcards.gse}
cd /tmp/wd_{wildcards.gse}
ln -s {wildcards.prefix}/df_{wildcards.gse}.rds
ln -s {wildcards.prefix}/litterature_models.rds
cp {wildcards.prefix}/*.Rmd {wildcards.prefix}/*.R .
RCODE="MODESA=TRUE ; gse='{wildcards.gse}' ; source('sa_callpipeline.R')"
echo $RCODE 
echo $RCODE | Rscript - 2>&1 > outputs_{wildcards.gse}.txt
cp results_{wildcards.gse}.rds 00_fullpipeline1_{wildcards.gse}.html {wildcards.prefix}/.
cd {wildcards.prefix}
rm -Rf /tmp/wd_{wildcards.gse}
"""
