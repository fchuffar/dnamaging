# Only train

gses = c( 
  "GSE41037", # 27k Genome wide DNA methylation profiling of whole blood in schizophrenia patients and healthy subjects.
  "27kGSE40279", # Hannum 2013 27k version
  "GSE40279", # 450k Hannum 2013
  "cancair",
  NULL
)
for (gse in gses) {
  rm(list = ls()[-which(ls()%in%c("gse", "gses"))])
  n_boot = 500
  #n_boot = 50
  print(paste0("************ ", gse, " ************"))
  #rmarkdown::render("01_build_study_generic.Rmd", output_file=paste0("01_build_study_", gse, ".html"))
  rmarkdown::render("02_stats_desc.Rmd", output_file=paste0("02_stats_desc_", gse, ".html"))    
  rmarkdown::render("03_preproc.Rmd", output_file=paste0("03_preproc_", gse, ".html"))    
  rmarkdown::render("04_model.Rmd", output_file=paste0("04_model_", gse, ".html"))
  gse_m = gse ; rmarkdown::render("05_eval.Rmd", output_file=paste0("05_eval_", gse, ".html"))
}



# train on GSE40279 and predict on a new dataset
gses = c( 
  "GSE41037", # 27k Genome wide DNA methylation profiling of whole blood in schizophrenia patients and healthy subjects.
  "Lima",
  "GSE20067", # 27k Genome wide DNA methylation profiling of diabetic nephropathy in type 1 diabetes mellitus
  "27kGSE40279", # Hannum 2013 27k version
  "27kLima",
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
for (gse_eval in gses) {
  rm(list = ls()[-which(ls()%in%c("gse", "gses", "gse_eval"))])
  gse_train = "GSE40279"
  gse_given = paste0(gse_train, "given", gse_eval)
  rmarkdown::render("01_rebuild_study_generic.Rmd", output_file=paste0("01_rebuild_study_", gse_given, ".html")) # export df_{gse_given}.rds
  n_boot = 500
  gse = gse_given ; rmarkdown::render("02_stats_desc.Rmd", output_file=paste0("02_stats_desc_", gse, ".html"))    
  gse = gse_given ; rmarkdown::render("03_preproc.Rmd", output_file=paste0("03_preproc_", gse, ".html"))    
  gse = gse_given ; rmarkdown::render("04_model.Rmd", output_file=paste0("04_model_", gse, ".html"))
  gse_m = gse_given ; gse = gse_eval ; source(paste0("params_",gse_train,".R")) ; rmarkdown::render("05_eval.Rmd", output_file=paste0("05_eval_", gse, ".html"))
}
