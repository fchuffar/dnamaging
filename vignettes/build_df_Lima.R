gse = "exp5300_meth_blood_convoluted"
df_filename = paste0("study_", gse, ".rds")
Lima = readRDS(df_filename)
Lima = cbind(Lima$exp_grp, t(Lima$data))
saveRDS(Lima,"df_Lima.rds")
