results_file = paste0("results_", gse, ".rds")
if (!file.exists(results_file)) {
  exec_time = microbenchmark::microbenchmark(rmarkdown::render('00_fullpipeline1.Rmd', output_file=paste0('00_fullpipeline1_', gse, '.Rmd')), times=1, unit='s')$time/(10^9)
  # meaning 
     # - temps d'execution
     # - précision de l'horloge (RMSE sur le test) (mod1, mod2, mod3, mod4)
     # - pval KW sur le genre (mod1, mod2, mod3, mod4)
     # - nombre de sondes de (mod1, mod2, mod3, mod4)
  results = c(
            exec_time=as.numeric(exec_time) ,
            rmsemod1_test=info_g$ElasticNet$RMSE,
            rmsemod2_test=info_g$Bootstrap$RMSE,
            rmsemod3_test=info_g$Hannum$RMSE,
            rmsemod4_test=info_g$Horvath$RMSE,
            pvkwamarmod1_test=info_g$ElasticNet$pvalAMAR ,
            pvkwamarmod2_test=info_g$Bootstrap$pvalAMAR ,
            pvkwamarmod3_test=info_g$Hannum$pvalAMAR ,
            pvkwamarmod4_test=info_g$Horvath$pvalAMAR ,
            pvkwrrmod1_test=info_g$ElasticNet$pvalRR,
            pvkwrrmod2_test=info_g$Bootstrap$pvalRR   ,
            pvkwrrmod3_test=info_g$Hannum$pvalRR   ,
            pvkwrrmod4_test=info_g$Horvath$pvalRR   ,
            nbmod1_probes=info_g$ElasticNet$nb_probes_mod     ,
            nbmod2_probes=info_g$Bootstrap$nb_probes_mod     ,
            nbmod3_probes=info_g$Hannum$nb_probes_mod     ,
            nbmod4_probes=info_g$Horvath$nb_probes_mod 

          )   
  saveRDS(results, paste0("results_", gse, ".rds"))  
}


