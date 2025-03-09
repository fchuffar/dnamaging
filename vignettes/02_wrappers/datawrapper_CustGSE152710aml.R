tcga_study = readRDS(paste0("~/projects/datashare/GSE152710/study_preproc_GSE152710.rds"))
s$data = tcga_study$data
s$platform_name = tcga_study$platform_name
idx_samples = intersect(colnames(s$data), rownames(s$exp_grp))
s$data = s$data[, idx_samples]






