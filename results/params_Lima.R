if (!exists("gse")) {gse = "exp5300_meth_blood_convoluted"}
if (!exists("y_key")) {y_key = "Age"}
if (!exists("covariates")) {covariates = c("Sexe", "cmslimapuno")}
if (!exists("AMAR_covariates")) {AMAR_covariates = "cmslimapuno"}
if (!exists("Lima")) { 
    Lima <- readRDS("study_exp5300_meth_blood_convoluted.rds")
    df = cbind(Lima$exp_grp, t(Lima$data))
}