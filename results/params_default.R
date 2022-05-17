if (!exists("gse")) gse = "GSE41037"
y_key = "age"
covariates = c("gender", "diseasestatus")
sample_blacklist = c("GSM1007327")
if (file.exists(paste0("params_", gse, ".R"))) source(paste0("params_", gse, ".R")) 