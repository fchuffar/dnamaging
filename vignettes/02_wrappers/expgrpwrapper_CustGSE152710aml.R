dir.create(paste0("./datashare/", gse, "/"))
tcga_study = readRDS(paste0("~/projects/datashare/GSE152710/study_preproc_GSE152710.rds"))
s$exp_grp = tcga_study$exp_grp
table(s$exp_grp$disease)
idx_samples =rownames(s$exp_grp)[s$exp_grp$disease!="MDS"]
s$exp_grp = s$exp_grp[idx_samples,]

table(s$exp_grp$disease)
s$exp_grp$disease = factor(s$exp_grp$disease, levels=c("CTR", "AML"))
table(s$exp_grp$disease)