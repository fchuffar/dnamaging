# dnamaging
A set of scripts and vignettes allowing to build and evaluate an epigenetic clock model.



# 180 seconds turorial

```
# Clean previous clone of the dnamaging package (if needed)
rm -Rf dnamaging
# Clone dnamaging package
git clone git@github.com:fchuffar/dnamaging.git
# Get dnamaging package data (will be include in the packege later)
mkdir dnamaging/data/
cd dnamaging/data/
wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/dnamaging/data/df_dnamaging.RData
wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/dnamaging/data/litterature_models.RData
# Launch pipeline with default dataset
cd ../vignettes
echo "devtools::install();" | Rscript -
echo "rmarkdown::render('00_fullpipeline1.Rmd')" | Rscript -
```


# Fast tutorial

```
# Get GSEXXX data
wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/dnamaging/vignettes/df_GSE20067.rds
wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/dnamaging/vignettes/df_GSE41037.rds
echo "source('ci_fast.R')" | Rscript -
```

# Full tutorial

```
# Get GSEXXX data
wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/dnamaging/vignettes/df_GSE20067.rds
wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/dnamaging/vignettes/df_GSE40279.rds
wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/dnamaging/vignettes/df_GSE50660.rds
wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/dnamaging/vignettes/df_GSE43976.rds
wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/dnamaging/vignettes/df_GSE106648.rds
echo "source('ci_full.R')" | Rscript -
```


# Troubleshooting

## Prerequisists

CRAN

``` 
glmnet
glmnetUtils
RColorBrewer
WriteXLS
```


Bioconductor
    
```
beeswarm
impute
methylclock
methylclockData
IlluminaHumanMethylation27kanno.ilmn12.hg19
IlluminaHumanMethylation450kanno.ilmn12.hg19
IlluminaHumanMethylationEPICanno.ilm10b4.hg19  
```


  
Github

```
https://github.com/fchuffar/epimedtools

```

# Development

## Build package

```
devtools::document(); devtools::install(); devtools::check(build_args="--no-build-vignettes")
```

## CMD on cluster

```
# from dahu frontend, get (quickely) interactively a developemnt node for 30 minutes (ssh like)
oarsub --project epimed  -l nodes=1,walltime=:30:00 -t devel -I
# from dahu frontend, get  interactively with a fixed ratio walltime/nodes
oarsub --project epimed  -l nodes=1/core=1,walltime=48:00:00  -I
oarsub --project epimed  -l nodes=1/core=2,walltime=24:00:00  -I
oarsub --project epimed  -l nodes=1/core=4,walltime=12:00:00  -I
oarsub --project epimed  -l nodes=1/core=8,walltime=6:00:00  -I
# from dahu frontend, book a node and use it assynchronously
oarsub --project epimed  -l nodes=1,walltime=48:00:00  "sleep 2d"
oarstat -fu chuffarf
oarsh dahu129
screen # ... screen -r ; ctrl+a d
# to killa job
oarstat | grep chuffarf
oarstat | grep chuffarf | cut -d" " -f1 | xargs oardel
```

## Testing
Functionnal testing is performed by executing vignettes with many parameters values.

[MY-LINK](vignettes/ci.R)

```
devtools::install();
source("ci_flash.R")
source("ci_fast.R")
source("ci_full.R")
```


## Sensitvity analysis

```
cd ~/projects/dnamaging/vignettes/
echo "source('sa_preparedf.R')" | Rscript -
# snakemake --cores 8 -s sa_launchexperiments.py  --latency-wait 60 -pn
# on HPE nodes
snakemake -s sa_launchexperiments.py --cores 20 --cluster "oarsub --project epimed -l /nodes=1,walltime=6:00:00 -t hpe "  --latency-wait 60 -pn
# on classical dahu nodes
snakemake -s sa_launchexperiments.py --cores 50 --cluster "oarsub --project epimed -l /nodes=1,walltime=6:00:00 "  --latency-wait 60 -pn
```

