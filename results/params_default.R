if (!exists("gse")) gse = "GSE41037"
y_key = "age"
covariates = c("gender")
sample_blacklist = c("GSM1007327")
nb_train = 482
custom_params_filename = paste0("params_", strsplit(gse, "given")[[1]][1], ".R")
custom_params_filename
if (file.exists(custom_params_filename)) source(custom_params_filename)
  