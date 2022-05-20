y_key = "Age"
covariates = c("citynocms", "citycms")
sample_blacklist = c("GSM1007327")
nb_train = 482
if (file.exists(paste0("params_", gse, ".R"))) source(paste0("params_", gse, ".R")) 
