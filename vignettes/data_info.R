# Use **strsplit** + **do.call(rbind,** to get a params in list of filenames
gses = do.call(rbind, strsplit(list.files(pattern="info_build"), "info_build_|\\.rds"))[,2]

# use lapply instead of for loop to build a data.frame
data_info = lapply(gses, function(gse) {
  # for each data.frame line, build a list of named values
  print(gse)
  # gse = "GSE42861"
  # gse = "GSE40279"
  # gse = "GSE43976"
  file_build = paste0("info_build_",gse,".rds") #platform
  file_desc = paste0("info_desc_",gse,".rds") #tissue,n,cofactors,distribs,
  file_model = paste0("info_model_r0_ewas3000_",gse,".rds") #RMSE,nb_pb
  if (file.exists(file_build)) {
    info_build = list(platform=readRDS(file_build))
  } else { 
    info_build = lits()
  }
  if (file.exists(file_desc)) {
    info_desc = as.list(readRDS(file_desc))
  } else { 
    info_desc = list()
  }
  if (file.exists(file_model)) {
    info_model = readRDS(file_model)
  } else { 
    info_model = list(Bootstrap=list())
  }
  ret = list(
    GSE        = gse,
    GPL        = info_build$platform ,
    tissue          = info_desc$tissue    ,
    n               = info_desc$n,    
    n_preproc       = info_desc$n_preproc ,
    cofactors       = info_desc$cofactors ,
    disease         = info_desc$disease   ,
    gender          = info_desc$gender    ,
    tobacco         = info_desc$tobacco   ,
    RMSE            = info_model$Bootstrap$RMSE           ,
    nb_probes       = info_model$Bootstrap$nb_probes_mod
  )
  ret
})
data_info = data.frame(do.call(rbind, data_info))
data_info
WriteXLS::WriteXLS(data_info, "data_info.xlsx", verbose=TRUE, row.names=FALSE, AdjWidth=TRUE, BoldHeaderRow=TRUE, FreezeRow=1, FreezeCol=1)
#      envir=          ExcelFileName=  perl=           Encoding=       col.names=      AutoFilter=     na=                   
