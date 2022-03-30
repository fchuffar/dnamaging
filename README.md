# dnamaging
A set of scripts and vignettes allowing to build and evaluate an epigenetic clock model.



# Prerequisists

## CRAN

``` 
glmnet

```


## Bioconductor
    
```
RColorBrewer
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

## Functionnal testing

Functionnal testing is performed by executing vignettes with defaults parameters values.

```
rmarkdown::render("01_build_study_generic.Rmd")
rmarkdown::render("02_stats_desc.Rmd")
rmarkdown::render("03_preproc.Rmd")
rmarkdown::render("04_model.Rmd")
rmarkdown::render("05_evaluation.Rmd")

```
