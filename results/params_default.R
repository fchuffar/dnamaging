if (!exists("gse")) gse = "GSE41037"
if (!exists("y_key")) y_key = "age"
if (!exists("covariates")) covariates = c("gender")
if (!exists("sample_blacklist")) sample_blacklist = c("GSM1007327")
if (!exists("nb_train")) nb_train = 482
if (file.exists(paste0("params_", gse, ".R"))) source(paste0("params_", gse, ".R")) 
