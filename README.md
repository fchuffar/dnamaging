# dnamaging
A set of scripts and vignettes allowing to build an epigentic clock model.



# Prerequisists

## CRAN

``` 
glmnet

```


## Bioconductor
    
```
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
rmarkdown::render("vignettes/01_build_study_generic.Rmd")
rmarkdown::render("vignettes/02_stats_desc.Rmd")
rmarkdown::render("vignettes/03_preproc.Rmd")
rmarkdown::render("vignettes/04_model.Rmd")
rmarkdown::render("vignettes/05_evaluation.Rmd")

```
