if (!exists("gse")) {gse = "exp5300_meth_saliva_convoluted"}
if (!exists("y_key")) {y_key = "Age"}
if (!exists("covariates")) {covariates = c("Sexe", "cmslimapuno")}
if (!exists("AMAR_covariates")) {AMAR_covariates = "cmslimapuno"}
if (!exists("Lima")){ 
  df_filename = paste0("study_", gse, ".rds")
  Lima <- readRDS(df_filename)
  Lima = cbind(Lima$exp_grp, t(Lima$data))
}