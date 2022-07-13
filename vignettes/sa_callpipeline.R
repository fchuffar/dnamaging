exec_time = microbenchmark::microbenchmark(rmarkdown::render('00_fullpipeline1.Rmd', output_file=paste0('00_fullpipeline1_', gse, '.Rmd')), times=1, unit="s")$time
#  ; 
# be shure taht we get all required indicators
# meaning 
   # - temps d'execution
   # - précision de l'horloge (RMSE sur le test) (mod1, mod2, mod3, mod4)
   # - pval KW sur le genre (mod1, mod2, mod3, mod4)
   # - nombre de sondes de (mod1, mod2, mod3, mod4)
results = c(
  exec_time=exec_time ,
  rmsemod1_test=0     ,
  rmsemod2_test=0     ,
  rmsemod3_test=0     ,
  rmsemod4_test=0     ,
  pvkwamarmod1_test=0 ,
  pvkwamarmod2_test=0 ,
  pvkwamarmod3_test=0 ,
  pvkwamarmod4_test=0 ,
  pvkwrrmod1_test=0   ,
  pvkwrrmod2_test=0   ,
  pvkwrrmod3_test=0   ,
  pvkwrrmod4_test=0   ,
  nbmod1_probes=0     ,
  nbmod2_probes=0     ,
  nbmod3_probes=0     ,
  nbmod4_probes=0 
)   
saveRDS(results, "results_", gse, ".rds")
