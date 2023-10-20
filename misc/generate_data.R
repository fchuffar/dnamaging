study_dnamaging = readRDS("~/projects/ewascombpr/vignettes/study_GSE42861_modelcalllm_meth~age_ewas2000_nn1000.rds")
save(study_dnamaging, file='~/projects/dnamaging/data/study_dnamaging.RData' , compress='xz')

litterature_models = mreadRDS("../vignettes/litterature_models.rds")
save(litterature_models, file='~/projects/dnamaging/data/litterature_models.RData' , compress='xz')
