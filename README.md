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

# Functionnal testing

Functionnal testing is performed by executing vignettes with defaults parameters values.

```
gses = c( 
  "GSE20067", # 27k Genome wide DNA methylation profiling of diabetic nephropathy in type 1 diabetes mellitus
  "GSE41037", # 27k Genome wide DNA methylation profiling of whole blood in schizophrenia patients and healthy subjects.
  "GSE40279", # 450k Hannum 2013
  # "GSE41169",
  # "GSE20236",
  # "GSE19711",
  # "GSE19711",
  # "GSE42861", # ***
  # "GSE111223",
  # "GSE34035",
  # "GSE28746",
  # "GSE34035",
  # # "GSE120610",
  # "GSE159899",
  # "GSE145254"
  # "GSE179759"
  NULL
)
for (gse in gses) {
  rm(list = ls()[-which(ls()=="gse")])
  print(paste0("************ ", gse, " ************"))
  source(paste0("params_", gse, ".R"))
  rmarkdown::render("01_build_study_generic.Rmd", output_file=paste0("01_build_study_", gse, ".html"))    
  rmarkdown::render("02_stats_desc.Rmd", output_file=paste0("02_stats_desc_", gse, ".html"))    
  rmarkdown::render("03_preproc.Rmd", output_file=paste0("03_preproc_", gse, ".html"))    
  # rmarkdown::render("04_model.Rmd", output_file=paste0("04_model_", gse, ".html"))
  # rmarkdown::render("05_evaluation.Rmd", output_file=paste0("05_evaluation_", gse, ".html"))
}

```
