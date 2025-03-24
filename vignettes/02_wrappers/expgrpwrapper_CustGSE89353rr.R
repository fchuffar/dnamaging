dir.create(paste0("./datashare/", gse, "/"))
orig_study = readRDS(paste0("~/projects/datashare/GSE89353/study_preproc_GSE89353.rds"))
s$exp_grp = orig_study$exp_grp
