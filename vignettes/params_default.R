if (!exists("gse")) gse = "dnamaging"
if (!exists("nb_train")) nb_train = 482
if (!exists("nbewasprobes")) nbewasprobes = 200
if (!exists("y_key")) y_key = "age"
covariates = c("gender")
sample_blacklist = c("GSM1007327")
n_boot = 500
FILTER_EWAS_FOR_DMR_CANDIDATE = FALSE
FILTER_SEXUAL_CHR = TRUE

custom_params_filename = paste0("params_", strsplit(gse, "given|_")[[1]][1], ".R")
custom_params_filename
if (file.exists(custom_params_filename)) source(custom_params_filename)
  
