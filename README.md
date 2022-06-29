# dnamaging
A set of scripts and vignettes allowing to build and evaluate an epigenetic clock model.



# 5 seconds turorial

```
git clone git@github.com:fchuffar/dnamaging.git
mkdir dnamaging/data/
cd dnamaging/data/
wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/dnamaging/data/df_dnamaging.RData
wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/dnamaging/data/litterature_models.RData
cd ../vignettes
R
```

under R

```
devtools::document(); devtools::install();
rmarkdown::render("00_fullpipeline1.Rmd")
```

# Troubleshooting

## Prerequisists

CRAN

``` 
glmnet
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

```
devtools::document(); devtools::install(); devtools::check(build_args="--no-build-vignettes")
```



Functionnal testing is performed by executing vignettes with many parameters values.

[MY-LINK](vignettes/ci.R)

```
devtools::document(); devtools::install();
source("ci_flash.R")
source("ci_fast.R")
```

