#' Retrieve preprocess df of gse
#' 
#' This function retrieve the preprocess df of the GSE to assign df
#'
#' @param gse the gse of your data
#'
#' @return gse preprocess df 
#' @export
#'
#' @examples gse = "GSE41037" ; get_df_preproc(gse)

get_df_preproc = function(gse){
    df = readRDS(paste0("df_preproc_",gse,".rds"))
    return(df)
}



#' Return a matrix without cofactors (only cpg markers)
#'
#' This function permite to return a matrix with a selection of samples and cpg markers and remove cofactors
#' @param gse the gse of your data
#' @param idx_smp idx of samples from the data that you will keep in the return matrix 
#' @param idx_cpg idx of cpg from the data that you will keep in the return matrix
#'
#' @return matrix 
#' @export

get_full_cpg_matrix = function(gse, idx_smp=NULL, idx_cpg=NULL){
    df = mget_df_preproc(gse)
    if (is.null(idx_smp) & is.null(idx_cpg)) {
      # print("is.null(idx_smp) & is.null(idx_cpg)")
      markers_start = grep("^cg",colnames(df))[1]
      tmp_idx_cpg = colnames(df)[markers_start:ncol(df)]
      ret = as.matrix(df[, tmp_idx_cpg])      
    } else {
      if (is.null(idx_cpg)) {
        # here idx_smp is not null
        # print("is.null(idx_cpg)")
        ret = mget_full_cpg_matrix(gse)
        ret = ret[idx_smp,]
      } else {
        # here idx_smp could be null
        # print("!is.null(idx_cpg)")
        ret = mget_full_cpg_matrix(gse, idx_smp)
        ret = ret[, idx_cpg]
      }      
    }
    return(ret)
  }

# model_factory_glmnet, 

#' Return custom model from glmnet::glmnet function
#'
#' This function produces custom model object based on list by calling glmnet::glmnet function
#' 
#' @param idx_train vector of idx of samples use for the train
#' @param y_key character correspond to the name of the column of explicative variable
#' @param alpha numeric alpha parameter use for glmnet::glmnet
#' @param lambda numeric lambda parameter use for glmnet function
#' @param gse character gse of your data
#' @param idx_cpg vector of idx of cpg markers use to make glmnet regression
#'
#' @importFrom glmnet glmnet
#' @return list with intercept and coeff results on the glmnet regression
#' @export

model_factory_glmnet = function(idx_train, y_key, alpha, lambda, gse, idx_cpg=NULL) {
  x = mget_full_cpg_matrix(gse, idx_train, idx_cpg)
  y = mget_df_preproc(gse)[idx_train,y_key]
  m = glmnet::glmnet(x=x, y=y, alpha=alpha, lambda=lambda, standardize=TRUE)
  idx = rownames(m$beta)[m$beta@i+1]
  coeff = data.frame(probes=idx, beta=m$beta[idx,])
  rownames(coeff) = idx
  ret = list(Intercept=m$a0, coeff=coeff)
  ret$name = paste0("cvaglmnet (a=", signif(alpha,3), ", l=", signif(lambda,3), ")")
  # ret$glmmod = m
  return(ret)
}


#' 
#'
#' @param tmp_idx_train vector of idx use for the train
#' @param tmp_idx_test  vector of idx use for the test
#' @param y_key  character correspond to the name of the column of explicative variable
#' @param tmp_probes vector of probes
#' @param occ the occurence of the cross validation
#' @param fold the fold of the cross validation
#' @param sub_df df with only markers use for boostrapped models
#' @param alpha numeric alpha parameter use for glmnet::glmnet
#' @param lambda numeric lambda parameter use for glmnet function
#' 
#' @importFrom glmnet glmnet
#' @importFrom glmnet cv.glmnet
#' @importFrom stats predict
#' 
#' @export

call_glmnet_mod = function(tmp_idx_train, tmp_idx_test, y_key, tmp_probes, occ, fold, sub_df, alpha=0, lambda=NULL) {

  tmp_Xtrain = as.matrix(sub_df[tmp_idx_train, tmp_probes])
  tmp_Ytrain = sub_df[tmp_idx_train, y_key]
  tmp_Xtest = as.matrix(sub_df[tmp_idx_test, tmp_probes])
  tmp_Ytest = sub_df[tmp_idx_test, y_key]
  if (is.null(lambda)) {
    print("glmnet::cv.glmnet")
    m = glmnet::cv.glmnet(x=tmp_Xtrain, y=tmp_Ytrain, alpha=alpha, type.measure="mse", standardize=TRUE)      
  } else {
    print("glmnet::glmnet")
    m = glmnet::glmnet(x=tmp_Xtrain, y=tmp_Ytrain, alpha=alpha, lambda=lambda, standardize=TRUE) 
  }

  train_pred = predict(m, tmp_Xtrain, type="response")
  train_truth = tmp_Ytrain
  train_err = RMSE(train_truth, train_pred)
  test_pred = predict(m, tmp_Xtest, type="response")
  test_truth = tmp_Ytest
  test_err = RMSE(test_truth, test_pred)

  # print(paste0("nb_probes:", length(tmp_probes), ", train_err: ", signif(train_err, 3), ", test_err: ", signif(test_err, 3)))
  ret = data.frame(
    occurence=occ, 
    nb_probes=length(tmp_probes), 
    train_err=train_err, 
    test_err=test_err,
    fold=fold
  )
}
  

#' models results on CV glmnet 
#'
#' This function returns models from cross validation glmnet using glmnetUtils::cva.glmnet
#' 
#' @param idx_train vector of idx use for the train
#' @param y_key character correspond to the name of the column of explicative variable
#' @param gse character gse of your data
#' @param idx_cpg vector of idx of cpg markers use to make cva.glmnet regression
#' @param alpha vector of alphas use for cva.glmnet 
#' 
#' @importFrom glmnetUtils cva.glmnet
#' 
#' @return Results of cva.glmnet function
#' @export

cvaglmnet = function(idx_train, y_key, gse, idx_cpg=NULL, alpha=seq(0, 1, len = 11)^3) {
  x = mget_full_cpg_matrix(gse, idx_train, idx_cpg)
  y = mget_df_preproc(gse)[idx_train, y_key] # service. Design Patterns, Gamma et al. 
  modelcva = glmnetUtils::cva.glmnet(x=x, y=y, type.measure="mse", standardize=TRUE,  alpha=alpha)
  return(modelcva)  
}
# Use parallel::makeCluster is not compatible with memoisation.
# cl.cva = parallel::makeCluster(nb_cores,  type="FORK")
# modelcva = glmnetUtils::cva.glmnet(x=x, y=y, type.measure="mse", standardize=TRUE, outerParallel=cl.cva)
# parallel::stopCluster(cl.cva)


#' Plotting models results for evalutation
#'
#' This function make differents plots to evaluate differents models. We have the regression plot for train and test set to prevent overfitting,
#' the AMAR plot and the residual plot for each covariable on the test set to see the difference between factors of each covariable.
#' 
#' @param m list of models to evaluate
#' @param df data frame of your data
#' @param covariate vector of different covariates to evaluate models
#' @param Xtrain matrix of train set
#' @param Xtest matrix of test set 
#' @param Ytrain vector of explicative variable train set
#' @param Ytest vector of explicative variable test set
#'
#' @importFrom stats kruskal.test 
#' @importFrom stats density
#' 
#' @export

plot_model_eval = function(m, df, covariate, Xtrain, Xtest, Ytrain, Ytest) {
  df[,covariate] = as.factor(df[,covariate])
  # Dealing with missing probes (litterature_models)
  idx_notmissing_probes = rownames(m$coeff)[(rownames(m$coeff) %in% colnames(Xtrain))]
  tmp_Xtrain = Xtrain[,idx_notmissing_probes] # Keep only common CpG between coeffs and Xtrain
  tmp_Xtest  = Xtest [,idx_notmissing_probes] # Keep only common CpG between coeffs and Xtrain
  m$coeff = m$coeff[idx_notmissing_probes,]

  # prediction
  predTr = tmp_Xtrain %*% as.matrix(m$coeff$beta) + m$Intercept
  predTe = tmp_Xtest %*% as.matrix(m$coeff$beta) + m$Intercept

  # regression residuals
  m0Tr = lm(Ytrain~predTr)
  rmseTr = sqrt(mean((m0Tr$residuals)^2))
  m0Te = lm(Ytest~predTe, data.frame(Ytest=Ytest, predTe=predTe))
  rmseTe = sqrt(mean((m0Te$residuals)^2))


  plot(predTr, Ytrain, 
    main=paste0(m$name), 
    sub=paste0("TRAIN (", nrow(Xtrain), " obs., ", nrow(m$coeff), " pbs, RMSE: ", signif(rmseTr, 3), ")"), 
    xlab="Predicted Age", 
    ylab="Chronological Age", 
    col=as.numeric(df[rownames(predTr), covariate])
  )
  abline(m0Tr)                                                                    
  abline(a=0, b=1, col="grey", lty=2)
  plot(predTe, Ytest, 
    main = paste0(m$name), 
    sub=paste0("TEST (", nrow(Xtest), " obs., ", nrow(m$coeff), " pbs, RMSE: ", signif(rmseTe, 3), ")"), 
    xlab="Predicted Age", 
    ylab="Chronological Age", 
    col=as.numeric(df[rownames(predTe),covariate])
  )
  abline(m0Te)                                                                    
  abline(a=0, b=1, col="grey", lty=2)



  # RegRes
  RegRes_Te = m0Te$residuals
  RegRes_Te = cbind.data.frame(RegRes_Te, df[names(RegRes_Te),covariate])
  colnames(RegRes_Te) = c("RegRes", covariate)
  pval = kruskal.test(RegRes_Te[,1]~RegRes_Te[,2])$p.value
  # anova(lm(RegRes_Te[,1]~RegRes_Te[,2], data=RegRes_Te))[1,5]
  # density
  den = density(RegRes_Te[, "RegRes"], na.rm=TRUE)
  den_bw = den$bw*1.5
  levls = levels(df[,covariate])
  density = lapply(levls, function(lev){
    if (sum(RegRes_Te[,covariate] %in% lev) > 1) {
      den = density(bw=den_bw, RegRes_Te[RegRes_Te[,covariate] %in% lev, "RegRes"])
      return(den)
    } # Patch density
  })
  plot(0, 0, col=0, ylab="", 
    xlab=paste0("K-W pval=", signif(pval ,3)),
    xlim = c(-1,1)*3*rmseTe, 
    ylim = c(0, max(unlist(lapply(density, function(d){max(d$y)})))), 
    main = paste0("RegRes"))
  sub="ANOVA"
  for (j in c(1:length(levls))){
  	lines(density[[j]], col=j)
  }
  legend(x="topright", legend=levls, col=1:length(levls), lty = 1, title=covariate)           







  #~Ytest_mod = (Ytest - m0$coefficients[[1]])/m0$coefficients[[2]]
  predTe_mod = m0Te$coefficients[[2]]*predTe + m0Te$coefficients[[1]]
  m1Te = lm(Ytest~predTe_mod, data.frame(Ytest=Ytest, predTe_mod=predTe_mod))
  rmseTe_mod = sqrt(mean((m1Te$residuals)^2))

  plot(predTe_mod, Ytest, 
    main = paste0(m$name), 
    sub=paste0("TEST (", nrow(Xtest), " obs., ", nrow(m$coeff), " pbs, RMSE: ", signif(rmseTe_mod, 3), ")"), 
    xlab="Predicted Age", 
    ylab="Chronological Age", 
    col=as.numeric(df[rownames(predTe),covariate])
  )
  abline(m1Te)                                                                    
  abline(m0Te, col="grey", lty=2)

  # AMAR
  AMAR_Te = predTe_mod/Ytest
  AMAR_Te = cbind.data.frame(AMAR_Te,df[rownames(AMAR_Te),covariate])
  colnames(AMAR_Te) = c("AMAR", covariate)
  pval = kruskal.test(AMAR_Te[,1]~AMAR_Te[,2])$p.value
  # density
  den = density(AMAR_Te[, "AMAR"], na.rm=TRUE)
  den_bw = den$bw
  den_bw = .06
  levls = levels(df[,covariate])
  density = lapply(levls, function(lev){
    if (sum(AMAR_Te[,covariate] %in% lev) > 1) {
      den = density(bw=den_bw, AMAR_Te[AMAR_Te[,covariate] %in% lev, "AMAR"])
      return(den)
    } # Patch density
  })
  plot(0,0, 
    xlab=paste0("K-W pval=", signif(pval ,3)),
    xlim = c(0.5, 1.5), 
    ylim = c(0, max(unlist(lapply(density, function(d){max(d$y)})))), 
    main = paste0("AMAR"))
  sub="ANOVA"
  for (j in c(1:length(levls))){
  	lines(density[[j]], col=j)
  }
  legend(x="topright", legend=levls, col=1:length(levls), lty = 1, title=covariate)           
}



if (!exists("mreadRDS")) {mreadRDS = memoise::memoise(readRDS, cache=cachem::cache_mem(max_size = 10*1024 * 1024^2)) }
if (!exists("mget_df_preproc")) {mget_df_preproc = memoise::memoise(get_df_preproc, cache = cachem::cache_mem(max_size = 10*1024 * 1024^2))}
if (!exists("mget_full_cpg_matrix")) {mget_full_cpg_matrix = memoise::memoise(get_full_cpg_matrix, cache = cachem::cache_mem(max_size = 10*1024 * 1024^2))}
if (!exists("mmodel_factory_glmnet")) {mmodel_factory_glmnet = memoise::memoise(model_factory_glmnet, cache = cachem::cache_mem(max_size = 10*1024 * 1024^2))}
if (!exists("mcall_glmnet_mod")) {mcall_glmnet_mod = memoise::memoise(call_glmnet_mod)}
if (!exists("mcvaglmnet")) {mcvaglmnet = memoise::memoise(cvaglmnet)}   # Memoise for cvaglmnet
