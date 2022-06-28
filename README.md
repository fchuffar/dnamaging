# dnamaging
A set of scripts and vignettes allowing to build and evaluate an epigenetic clock model.



# Prerequisists

## CRAN

``` 
glmnet
RColorBrewer
WriteXLS
```


## Bioconductor
    
```
beeswarm
impute
methylclock
methylclockData
IlluminaHumanMethylation27kanno.ilmn12.hg19
IlluminaHumanMethylation450kanno.ilmn12.hg19
IlluminaHumanMethylationEPICanno.ilm10b4.hg19  
```


  
## Github

```
https://github.com/fchuffar/epimedtools

```

# Development

```
devtools::document(); devtools::install(); devtools::check(build_args="--no-build-vignettes")
```


# Functionnal testing

Functionnal testing is performed by executing vignettes with many parameters values.

[MY-LINK](vignettes/ci.R)

```
devtools::document(); devtools::install();
source("ci_flash.R")
source("ci_fast.R")
```

