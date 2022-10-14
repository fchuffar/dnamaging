source("common.R")
source("sa_params.R")
options(scipen=999)

all_probes = NULL
 for (gse in gses) {
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


 print(paste0(length(all_probes), " common probes."))

#ourgses = c()
 #for (gse in gses) {
 # print(gse)
 # source("params_default.R")
 # df_filename = paste0("df_", gse, ".rds")
 # df = mreadRDS(df_filename)
 # set.seed(1)
 # idx_test = sample(rownames(df), 100)
 # colnames(df)[1:10]
 # colnames(df)[which(colnames(df)==y_key)] = "age"
 # colnames(df)[1:10]
 # for (n in ns) {
 #   set.seed(1)
 #   idx_train = sample(setdiff(rownames(df), idx_test), n)
 #   nb_train = n
 #   for (seed in seeds) {
 #     for (p in ps) {
 #       print(p)
 #       set.seed(seed)
 #       idx_probes = sample(all_probes, p)
 #       ourgse = paste0("gse", gse, "n", n, "seed", seed, "p", p)
 #       ourgses = c(ourgses, ourgse)
 #       ourdf_filename = paste0("df_", ourgse, ".rds")
 #       our_df = df[c(idx_test, idx_train),c("age", "gender", idx_probes)]
 #       saveRDS(our_df, ourdf_filename)
 #     }
 #    }
 # }
 #}


ourgses = c()
for (gse in gses) {
  for (n in ns) {
    for (seed in seeds) {
      for (p in ps) {
        ourgse = paste0("gse", gse, "n", n, "seed", seed, "p", p)
        print(ourgse)
        ourgses = c(ourgses, ourgse)
      }
    }
  }
}

write.table(sample(ourgses), "ourgses.txt", quote=FALSE, col.names=FALSE, row.names=FALSE)

