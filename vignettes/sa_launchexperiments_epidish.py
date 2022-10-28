import os 

# with open("ourgses.txt") as f:
#     gses = f.read().splitlines()

curdir = os.getcwd()
label = "epidish"
# results = [f"{curdir}/results_{gse}.rds" for gse in gses]
# results = [f"{curdir}/04_model_{prefix}_GSE40279_{scenario}_{seed}.html" for seed in range(1, 10) for scenario in ["A", "B", "C", "D", "E", "F", "G"]]
# results = [f"{curdir}/04_model_{prefix}_GSE40279_{scenario}_{seed}.html" for seed in range(1, 3) for scenario in ["A", "B"]]
# results = [f"{curdir}/04_model_{gse}_scenario{scenario}_seed{seed}.html" for gse in ["GSE40279"] for seed in range(1, 30) for scenario in ["A", "B", "C", "D"]]
results = [f"{curdir}/04_model_{gse}_scenario{scenario}_seed{seed}.html" for gse in ["GSE87571"] for seed in range(1, 10) for scenario in ["A", "B", "C", "D"]]


localrules: target

rule target:
    threads: 1
    message: "-- Rule target completed. --"
    input: 
      results 
    shell:"""
export PATH="/summer/epistorage/opt/bin:$PATH"
export PATH="/summer/epistorage/miniconda3/envs/dnamaning_env/bin/:$PATH"
pwd
RCODE="rmarkdown::render('sa_plot_"""+label+""".Rmd')"
echo $RCODE 
echo $RCODE | Rscript - 

          """




rule sa_callpipeline:
    input: 
      df="{prefix}/df_preproc_{gse}.rds",
      r_caller="{prefix}/sa_callpipeline_"+label+".R",      
      rmd_script_model="{prefix}/04_model.Rmd",      
    output: 
      rds = "{prefix}/results_{gse}_scenario{scenario}_seed{seed}.rds"      ,           
      html = "{prefix}/04_model_{gse}_scenario{scenario}_seed{seed}.html"      ,           
    threads: 1
    shell:"""
export PATH="/summer/epistorage/opt/bin:$PATH"
export PATH="/summer/epistorage/miniconda3/envs/dnamaning_env/bin/:$PATH"
cd {wildcards.prefix}

rm -Rf /tmp/wd_{wildcards.gse}_scenario{wildcards.scenario}_seed{wildcards.seed}
mkdir -p /tmp/wd_{wildcards.gse}_scenario{wildcards.scenario}_seed{wildcards.seed}
cd /tmp/wd_{wildcards.gse}_scenario{wildcards.scenario}_seed{wildcards.seed}
ln -s {wildcards.prefix}/df_preproc_{wildcards.gse}.rds
ln -s {wildcards.prefix}/litterature_models.rds
cp {wildcards.prefix}/*.Rmd {wildcards.prefix}/*.R .
RCODE="gse = '{wildcards.gse}' ; scenario = '{wildcards.scenario}' ; seed = {wildcards.seed} ; source('{input.r_caller}')"
echo $RCODE 
echo $RCODE | Rscript - 2>&1 > Rout_{wildcards.gse}_scenario{wildcards.scenario}_seed{wildcards.seed}.txt
cp results_{wildcards.gse}_scenario{wildcards.scenario}_seed{wildcards.seed}.rds 04_model_{wildcards.gse}_scenario{wildcards.scenario}_seed{wildcards.seed}.html {wildcards.prefix}/.
cd {wildcards.prefix}
rm -Rf /tmp/wd_{wildcards.gse}_scenario{wildcards.scenario}_seed{wildcards.seed}
"""
