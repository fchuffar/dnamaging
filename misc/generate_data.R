study_dnamaging = readRDS("~/projects/ewascombpr/vignettes/study_GSE42861_modelcalllm_meth~age_ewas2000_nn1000.rds")
study_dnamaging[names(study_dnamaging)[!names(study_dnamaging) %in% c("platform", "data", "exp_grp")]]=NULL
dim(study_dnamaging$platform)
head(study_dnamaging$platform[,1:6])
study_dnamaging$platform = study_dnamaging$platform[,1:2]
dim(study_dnamaging$data)
colnames(study_dnamaging$exp_grp)[1] = "tissue"
study_dnamaging$exp_grp$tissue = "blood"
dim(study_dnamaging$exp_grp)
head(study_dnamaging$exp_grp)
save(study_dnamaging, file='~/projects/dnamaging/data/study_dnamaging.RData' , compress='xz')

litterature_models = mreadRDS("../vignettes/litterature_models.rds")
save(litterature_models, file='~/projects/dnamaging/data/litterature_models.RData' , compress='xz')





