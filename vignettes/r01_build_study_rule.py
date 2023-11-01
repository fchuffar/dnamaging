rule r00_create_empty_expgrpwrapper:
    input: 
    output: 
      r_expgrpwrapper="{prefix}/01_wrappers/01_expgrpwrapper_{gse}.R",
    threads: 1
    shell:"""
cd {wildcards.prefix}
touch {output.r_expgrpwrapper}
"""

rule r00_create_empty_datawrapper:
    input: 
    output: 
      r_datawrapper="{prefix}/01_wrappers/01_datawrapper_{gse}.R",
    threads: 1
    shell:"""
cd {wildcards.prefix}
touch {output.r_datawrapper}
"""        

rule r01_build_study:
    input: 
      rmd = "{prefix}/01_build_study_generic.Rmd",
      r_datawrapper   = "{prefix}/01_wrappers/01_datawrapper_{gse}.R",
      r_expgrpwrapper = "{prefix}/01_wrappers/01_expgrpwrapper_{gse}.R",
    output: 
      study_rds =   "{prefix}/datashare/{gse}/study_{gse}.rds",
      df_rds =      "{prefix}/datashare/{gse}/df_{gse}.rds"    ,           
      html =        "{prefix}/01_build_study_{gse}.html"      ,           
      info       =  "{prefix}/info_build_{gse}.rds"   ,
    threads: 32
    shell:"""
export PATH="/summer/epistorage/opt/bin:$PATH"
export PATH="/summer/epistorage/miniconda3/envs/R3.6.1_env/bin:$PATH"
export OMP_NUM_THREADS=1
cd {wildcards.prefix}

rm -Rf /tmp/wd_{wildcards.gse}
mkdir -p /tmp/wd_{wildcards.gse}
cd /tmp/wd_{wildcards.gse}
ln -s {wildcards.prefix}/datashare 
cp {input.rmd} .
mkdir 01_wrappers
cp {input.r_datawrapper} {input.r_expgrpwrapper} 01_wrappers/.

RCODE="gse='{wildcards.gse}'; rmarkdown::render('01_build_study_generic.Rmd', output_file=paste0('01_build_study_',gse,'.html'));"
echo $RCODE | Rscript - 2>&1 > 01_build_study_{wildcards.gse}.Rout

cp 01_build_study_{wildcards.gse}.Rout info_build_{wildcards.gse}.rds 01_build_study_{wildcards.gse}.html {wildcards.prefix}/.
cd {wildcards.prefix}
rm -Rf /tmp/wd_{wildcards.gse}
"""
