source("common.R")


all_probes = NULL
for (gse in c("GSE50660", "GSE40279", "GSE41037")) {
  print(gse)
  source("params_default.R")
  df_filename = paste0("df_", gse, ".rds")
  df = mreadRDS(df_filename)
  idx_samples = rownames(df)
  markers_start = grep("cg",colnames(df))[1]
  idx_clinicals = colnames(df)[1:(markers_start-1)]
  idx_cpg = colnames(df)[markers_start:ncol(df)]
  if (is.null(all_probes)) {
    all_probes = idx_cpg
  } else {
    all_probes = intersect(all_probes, idx_cpg)
  }
}

length(all_probes)


for (gse in c("GSE50660", "GSE40279", "GSE41037")) {
  print(gse)
  source("params_default.R")
  df_filename = paste0("df_", gse, ".rds")
  df = mreadRDS(df_filename)
  set.seed(1)
  idx_test = sample(rownames(df), 100)
  colnames(df)[1:10]
  colnames(df)[which(colnames(df)==y_key)] = "age"
  colnames(df)[1:10]
  for (n in c(100, 200, 300, 350)) {
    set.seed(1)
    idx_train = sample(setdiff(rownames(df), idx_test), n)
    nb_train = n 
    for (seed in 1:3) {
      for (p in c(1000, 2000, 3000, 5000)) {
        set.seed(seed)
        idx_probes = sample(all_probes, p)
        ourgse = paste0("gse", gse, "n", n, "seed", seed, "p", p)
        ourdf_filename = paste0("df_", ourgse, ".rds")
        our_df = df[c(idx_test, idx_train),c("age", "gender", idx_probes)]           
        saveRDS(our_df, ourdf_filename)
        gse = ourgse
        exec_time = microbenchmark::microbenchmark(rmarkdown::render("00_fullpipeline1.Rmd"), times=1, unit="s")$time
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
        saveRDS(results, "results_", ourgse, ".rds")
      }
    }
  }
}



