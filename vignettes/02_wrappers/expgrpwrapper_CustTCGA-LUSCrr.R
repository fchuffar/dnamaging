gse_orig = substr(gse, 5, nchar(gse)-2)
dir.create(paste0("./datashare/", gse, "/"))
orig_study = readRDS(paste0("~/projects/datashare/",  gse_orig , "/study_preproc_",  gse_orig , ".rds"))
s$exp_grp = orig_study$exp_grp
