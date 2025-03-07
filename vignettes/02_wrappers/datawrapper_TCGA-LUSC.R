tcga_study = readRDS(paste0("~/projects/tcga_studies/study_", gse, "_meth.rds"))
bar = apply(is.na(tcga_study$data), 2, sum)
tcga_study$data = tcga_study$data[,bar<300000]
dim(tcga_study$data)
foo = apply(is.na(tcga_study$data), 1, sum) / ncol(tcga_study$data)
tcga_study$data = tcga_study$data[foo<.5,]
s$data = tcga_study$data
s$platform_name = "GPL13534"
idx_samples = intersect(colnames(s$data), rownames(s$exp_grp))
s$exp_grp = s$exp_grp[idx_samples,]
s$data = s$data[, idx_samples]






