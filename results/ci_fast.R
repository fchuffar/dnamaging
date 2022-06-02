# rm(list = ls())
gse_eval = "GSE20067" # 27k Genome wide DNA methylation profiling of diabetic nephropathy in type 1 diabetes mellitus
gse_train = "GSE41037"
gse_given = paste0(gse_train, "given", gse_eval)
rmarkdown::render("01_rebuild_study_generic.Rmd", output_file=paste0("01_rebuild_study_", gse_given, ".html")) # export df_{gse_given}.rds
gse = gse_given ; rmarkdown::render("02_stats_desc.Rmd", output_file=paste0("02_stats_desc_", gse, ".html"))    
gse = gse_given ; rmarkdown::render("03_preproc.Rmd", output_file=paste0("03_preproc_", gse, ".html"))    
gse = gse_given ; rmarkdown::render("04_model.Rmd", output_file=paste0("04_model_", gse, ".html"))
gse = gse_eval ; rmarkdown::render("02_stats_desc.Rmd", output_file=paste0("02_stats_desc_", gse, ".html"))    
gse = gse_eval ; rmarkdown::render("03_preproc.Rmd", output_file=paste0("03_preproc_", gse, ".html"))    
gse_m = gse_given ; gse = gse_eval ; rmarkdown::render("05_eval.Rmd", output_file=paste0("05_eval_", gse, "_", gse_m, ".html"))
