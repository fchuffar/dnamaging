dir.create(paste0("./datashare/", gse, "/"))
orig_study = readRDS(paste0("~/projects/datashare/GSE147740/study_preproc_GSE147740.rds"))
s$exp_grp = orig_study$exp_grp
