if(!file.exists("data_info.xlsx")){
	data_info_gen = as.data.frame(setNames(replicate(9,numeric(0), simplify = F),c("name_gse","platform","tissue","n","cofactors","disease_distrib","gender_distrib","tobacco_distrib","RMSE") ))
	openxlsx::write.xlsx(data_info_gen,"data_info.xlsx")
}

info_model = readRDS(paste0("info_model_",gse,".rds"))
info_desc = readRDS(paste0("info_desc_",gse,".rds"))

info = c(info_desc,RMSE = info_model$Bootstrap$RMSE)
info_gen = openxlsx::read.xlsx("data_info.xlsx")

if (gse %in% info_gen$name_gse){
	info_gen[info_gen$name_gse==gse,] = info
} else { info_gen[nrow(info_gen)+1,] = info }

openxlsx::write.xlsx(info_gen,"data_info.xlsx")
