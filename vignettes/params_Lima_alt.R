if (!exists("gse")) {gse = "exp5300_meth_blood_convoluted_alt"}
if (!exists("y_key")) {y_key = "Age"}
if (!exists("covariates")) {covariates = c("Sexe", "alt")}
if (!exists("AMAR_covariates")) {AMAR_covariates = "alt"}
if (!exists("Lima")) { 
  Lima <- readRDS("df_Lima.rds")
  df = cbind(Lima$exp_grp, t(Lima$data))
  alt = c()
  for (i in 1:nrow(df)){
    if(df$cmslimapuno[i] != "Lima" && df$cmslimapuno[i] != "Puno" || is.na(df$cmslimapuno[i])){
      alt = c(alt,"High Alt")
    }else {
      alt = c(alt,as.character(df$cmslimapuno[i]))
    }
  }
  df = cbind.data.frame(alt,df)
}
