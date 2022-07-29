start_ci = Sys.time()
# Only train
gses = c( 
  "GSE40279", # 450k Hannum 2013
  # "GSE41037", # 27k Genome wide DNA methylation profiling of whole blood in schizophrenia patients and healthy subjects.
  "GSE50660", # smoking status and age 
  # "27kLima",
  # "cancair",
  NULL
)
for (gse in gses) {
  rm(list = ls()[-which(ls()%in%c("gse", "gses"))])
  rmarkdown::render("00_fullpipeline1.Rmd", output_file=paste0("00_fullpipeline1_", gse, ".html"))
}



# train on GSE40279 and predict on a new dataset
gses = c( 
  "GSE43976", # smoking status and age
  "GSE106648", # smoking status and age
  "GSE20067", # 27k Genome wide DNA methylation profiling of diabetic nephropathy in type 1 diabetes mellitus
  # "GSE41037", # 27k Genome wide DNA methylation profiling of whole blood in schizophrenia patients and healthy subjects.
  # "GSE50660", # smoking status and age
  # "Lima",
  # "27kGSE40279", # Hannum 2013 27k version
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
  n_boot = 500
  gse_learn = "GSE40279"
  gse_given = paste0(gse_learn, "given", gse_eval)
  rmarkdown::render("01_rebuild_study_generic.Rmd", output_file=paste0("01_rebuild_study_", gse_given, ".html")) # export df_{gse_given}.rds
  gse = gse_given ; rmarkdown::render("00_fullpipeline1.Rmd", output_file=paste0("00_fullpipeline1_", gse, ".html"))
  gse = gse_eval ; rmarkdown::render("02_statdesc.Rmd", output_file=paste0("02_statdesc_", gse, ".html"))    
  gse = gse_eval ; rmarkdown::render("03_preproc.Rmd", output_file=paste0("03_preproc_", gse, ".html"))    
  gse_m = gse_given ; gse = gse_eval ; rmarkdown::render("05_eval.Rmd", output_file=paste0("05_eval_", gse, "_", gse_m, ".html"))
}

exec_time_ci = Sys.time() - start_ci



print(paste0("Execution time for CI: ", exec_time_ci))
