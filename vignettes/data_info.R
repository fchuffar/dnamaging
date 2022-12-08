if(!file.exists("data_info.xlsx")){
	data_info_gen = as.data.frame(setNames(replicate(9,numeric(0), simplify = F),c("name_gse","platform","tissue","n","n_preproc","cofactors","disease_distrib","gender_distrib","tobacco_distrib","RMSE","nb_probes") ))
	openxlsx::write.xlsx(data_info_gen,"data_info.xlsx")
}

info_gen = openxlsx::read.xlsx("data_info.xlsx")
gses=stringr::str_sub(list.files(pattern="info_"),end=-5)
gses=unlist(stringr::str_split(gses,pattern="_"))
gses=unique(gses[grep(pattern="GSE",gses)])

for (gse in gses){
  file_build = paste0("info_build_",gse,".rds") #platform
  file_desc = paste0("info_desc_",gse,".rds") #tissue,n,cofactors,distribs,
  file_model = paste0("info_model_",gse,".rds") #RMSE,nb_pb
  info=gse
  if(file.exists(file_build)){
    info_build=readRDS(file_build)
    info=c(info,info_build)
  } else { info = c(info,"NA") }
  if(file.exists(file_desc)){
    info_desc=readRDS(file_desc)
    info=c(info,info_desc)
  } else { info = c(info,rep("NA",7)) }
  if(file.exists(file_model)){
    info_model=readRDS(file_model)
    info=c(info,info_model$Bootstrap$RMSE,info_model$Bootstrap$nb_probes)
  } else { info =c(info,rep("NA",2)) }
  
  if (gse %in% info_gen$name_gse){
    info_gen[info_gen$name_gse==gse,] = info
  } else { info_gen[nrow(info_gen)+1,] = info }
}

openxlsx::write.xlsx(info_gen,"data_info.xlsx")
