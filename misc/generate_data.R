source("../R/functions.R")
df_filename = paste0("../misc/df_", "GSE41037", ".rds")
df = mreadRDS(df_filename)

idx_samples = rownames(df)
markers_start = grep("cg",colnames(df))[1]
idx_clinicals = colnames(df)[1:(markers_start-1)]
idx_cpg = colnames(df)[markers_start:ncol(df)]


set.seed(1)
df_dnamaging = df[, c("gender", "age", sample(idx_cpg, 3000))]
save(df_dnamaging, file='~/projects/dnamaging/data/df_dnamaging.RData' , compress='xz')
# DEPRECATED, see `r gse = 'GSE40279' ; rmarkdown::render("04_model.Rmd")`


litterature_models = mreadRDS("../vignettes/litterature_models.rds")
save(litterature_models, file='~/projects/dnamaging/data/litterature_models.RData' , compress='xz')
