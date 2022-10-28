options(scipen=999)

# gse = 'GSE40279' ; nbewasprobes = 50000; rmarkdown::render("04_model.Rmd", output_file=paste0("04_model_nbewasprobes", nbewasprobes, ".html"))


prefix = paste0("_", gse, "_nbewasprobes", nbewasprobes, "_seed", seed)
results_file = paste0("results", prefix, ".rds")
# if (!file.exists(results_file)) {
  exec_time = microbenchmark::microbenchmark(rmarkdown::render(paste0("04_model.Rmd")   , output_file=paste0("04_model", prefix, ".html")), times=1, unit="s")$time/(10^9)
  results = c(
    exec_time         = as.numeric(exec_time)           ,
    rmsemod1_test     = info_g$ElasticNet$RMSE          ,
    rmsemod2_test     = info_g$Bootstrap$RMSE           ,
    rmsemod3_test     = info_g$Hannum$RMSE              ,
    rmsemod4_test     = info_g$Horvath$RMSE             ,
    pvkwamarmod1_test = info_g$ElasticNet$pvalAMAR      ,
    pvkwamarmod2_test = info_g$Bootstrap$pvalAMAR       ,
    pvkwamarmod3_test = info_g$Hannum$pvalAMAR          ,
    pvkwamarmod4_test = info_g$Horvath$pvalAMAR         ,
    pvkwrrmod1_test   = info_g$ElasticNet$pvalRR        ,
    pvkwrrmod2_test   = info_g$Bootstrap$pvalRR         ,
    pvkwrrmod3_test   = info_g$Hannum$pvalRR            ,
    pvkwrrmod4_test   = info_g$Horvath$pvalRR           ,
    nbmod1_lambda     = info_g$ElasticNet$lambda        ,
    nbmod1_alpha      = info_g$ElasticNet$alpha         ,
    nbmod1_probes     = info_g$ElasticNet$nb_probes_mod ,
    nbmod2_probes     = info_g$Bootstrap$nb_probes_mod  ,
    nbmod3_probes     = info_g$Hannum$nb_probes_mod     ,
    nbmod4_probes     = info_g$Horvath$nb_probes_mod 
  )   
  saveRDS(results, results_file)
# }


