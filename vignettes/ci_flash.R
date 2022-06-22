rmarkdown::render("02_statdesc.Rmd", output_file=paste0("02_statdesc_", "default", ".html"))    
rmarkdown::render("03_preproc.Rmd" , output_file=paste0("03_preproc_",  "default", ".html"))    
rmarkdown::render("04_model.Rmd"   , output_file=paste0("04_model_",    "default", ".html"))
rmarkdown::render("05_eval.Rmd"    , output_file=paste0("05_eval_",     "default", ".html"))
