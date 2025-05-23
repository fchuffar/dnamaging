# Use **strsplit** + **do.call(rbind,** to get a params in list of filenames
gses = do.call(rbind, strsplit(list.files(pattern="info_build"), "info_build_|\\.rds"))[,2]

# use lapply instead of for loop to build a data.frame
data_info = lapply(gses, function(gse) {
  # for each data.frame line, build a list of named values
  print(gse)
  # gse = "GSE42861"
  # gse = "GSE40279"
  # gse = "GSE43976"
  file_idat2study = paste0("info_idat2study_",gse,".rds")
  file_build = paste0("info_build_",gse,".rds")
  file_desc  = paste0("info_desc_",gse,".rds")
  file_ewas  = paste0("info_ewas_ewcpr_",gse,"_modelcalllm_meth~age.rds")
  #  info_ewas_ewcpr_GSE147740_modelcalllm_meth~age.rds                            info_ewas_neighb_GSE147740_modelcalllm_meth~age_ewas1000000_nn1000.rds
  file_model = paste0("info_model_r0_",gse,"_modelcalllm_meth~age_ewas1000000_nn1000.rds")
  if (file.exists(file_idat2study)) {
      info_idat2study = readRDS(file_idat2study)
  } else { 
    info_idat2study = list()
  }
  if (file.exists(file_build)) {
      info_build = readRDS(file_build)
  } else { 
    info_build = list()
  }
  if (file.exists(file_desc)) {
    info_desc = as.list(readRDS(file_desc))
  } else { 
    info_desc = list()
  }
  if (file.exists(file_ewas)) {
    info_ewas = readRDS(file_ewas)
  } else { 
    info_ewas = list()
  }
  if (file.exists(file_model)) {
    info_model = readRDS(file_model)
  } else { 
    info_model = list()
  }
  
  if ("cofactors" %in% names(info_desc)) {
    cofactors = strsplit(info_desc$cofactors,"/")    
  }
  models = list("elasticnet","bootstrap","hannum","horvath")
  all_cofactors = list("gender","tobacco","disease","ethnicity")
  list = list()
  pval = lapply(all_cofactors, function(cof){ 
  	list_tmp = list()
  	pval_tmp = lapply(models, function(m){
  		list_tmp[[length(list_tmp)+1]] = eval(parse(text = paste0("info_model$",cof,".",m,".pvalRR")))
  	})
  	names(pval_tmp) = paste0(models,".pvalRR")
  	pval_tmp[sapply(pval_tmp, is.null)] <- NA
  	list[[length(list)+1]] = pval_tmp
  })
  names(pval) = all_cofactors
  pval = as.list(unlist(pval))
  ret = list(
    GSE        = gse,
    GPL        = info_build$GPL      ,
    orig       = info_build$orig     ,
    n          = info_build$n        ,
    p          = info_build$p        ,
    tissue     = info_build$tissue   ,
    age        = info_build$age      ,
    gender     = info_build$gender   ,
    tobacco    = info_build$tobacco  ,
    disease    = info_build$disease  ,
    bmi        = info_build$bmi      ,
    ethnicity  = info_build$ethnicity,
    exec_time_build  = info_build$exec_time,
    exec_time_idat2study  = info_idat2study$exec_time,

    # tissue    = info_desc$tissue    ,
    # n         = info_desc$n         ,
    n_preproc = info_desc$n_preproc ,
    # cofactors = info_desc$cofactors ,
    # disease   = info_desc$disease   ,
    # gender    = info_desc$gender    ,
    # tobacco   = info_desc$tobacco   ,
    exec_time_preproc = info_desc$exec_time ,

    exec_time_ewas  = info_ewas$exec_time,
    exec_time_model  = info_model$exec_time,
  
    # RMSE       = eval(parse(text = paste0("info_model$",cofactors[[1]][1],".bootstrap.RMSE"))),
    # nb_probes  = eval(parse(text = paste0("info_model$",cofactors[[1]][1],".bootstrap.nb_probes_mod"))),
  
    
    # ...

    exec_time_model = info_model$exec_time     
  )
  ret = c(ret,pval)
  ret
})
data_info = data.frame(do.call(rbind, data_info))
data_info = data_info[order(substr(unlist(data_info$tissue), 1, 5), unlist(data_info$p)),]
rownames(data_info) = data_info$GSE
data_info
WriteXLS::WriteXLS(data_info, "data_info.xlsx", verbose=TRUE, row.names=FALSE, AdjWidth=TRUE, BoldHeaderRow=TRUE, FreezeRow=1, FreezeCol=1)
#      envir=          ExcelFileName=  perl=           Encoding=       col.names=      AutoFilter=     na=                   
