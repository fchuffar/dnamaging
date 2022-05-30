if (!exists("mreadRDS")) { mreadRDS = memoise::memoise(readRDS, cache=cachem::cache_mem(max_size = 10*1024 * 1024^2)) }
# if (!exists("mget_coefHannum")) mget_coefHannum = memoise::memoise(methylclockData::get_coefHannum)
plot_model_eval = function(m, df, covariate) {
  df[,covariate] = as.factor(df[,covariate])
  # Imputing missing probes (litterature_models)
  tmp_Xtrain = Xtrain[,rownames(m$coeff)[rownames(m$coeff) %in% colnames(Xtrain)]] #Keep only common CpG between coeffs and Xtrain
  tmp_Xtest = Xtest[,rownames(m$coeff)[rownames(m$coeff) %in% colnames(Xtest)]] #Keep only common CpG between coeffs and Xtrain
  idx_missing_probes = rownames(m$coeff)[!(rownames(m$coeff) %in% colnames(Xtrain))]
  if (length(idx_missing_probes) != 0) {
    foo = m$coeff[idx_missing_probes,"mean"]
    names(foo) = idx_missing_probes
    tmp_Xtrain = cbind(tmp_Xtrain,do.call("rbind",replicate(nrow(tmp_Xtrain),foo,simplify=FALSE)))
    tmp_Xtest = cbind(tmp_Xtest,do.call("rbind",replicate(nrow(tmp_Xtest),foo,simplify=FALSE)))
  }
  tmp_Xtrain = tmp_Xtrain[,rownames(m$coeff)]
  tmp_Xtest = tmp_Xtest[,rownames(m$coeff)]
  # prediction
  predTr = tmp_Xtrain %*% as.matrix(m$coeff$beta) + m$Intercept
  rmseTr = sqrt(mean((Ytrain - predTr)^2))
  predTe = tmp_Xtest %*% as.matrix(m$coeff$beta) + m$Intercept
  rmseTe = sqrt(mean((Ytest - predTe)^2))
  # AMRA
  AMAR_Te = predTe/Ytest
  AMAR_Te = cbind.data.frame(AMAR_Te,df[rownames(AMAR_Te),covariate])
  colnames(AMAR_Te) = c("AMAR", covariate)
  pval = anova(lm(AMAR_Te[,1]~AMAR_Te[,2], data=AMAR_Te))[1,5]
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
  plot(Ytrain, predTr,
    main=paste0(m$name), 
    sub=paste0("TRAIN (", nrow(m$coeff), " pbs)", " RMSE: ", signif(rmseTr, 3)), 
    xlab="Chronological Age", 
    ylab="Predicted Age", 
    col=as.numeric(df[rownames(predTr),covariate])
    )
  abline(a=0, b=1)                                                                    
  plot(Ytest , predTe, 
    main = paste0(m$name), 
    sub=paste0("TEST (", nrow(m$coeff), " pbs) RMSE: ", signif(rmseTe, 3)), 
    xlab="Chronological Age", 
    ylab="Predicted Age", 
    col=as.numeric(df[rownames(predTe),covariate])
  )
  abline(a=0, b=1)
  plot(0,0, 
    xlab=paste0("ANOVA pval=", signif(pval ,3)),
    xlim = c(0.5, 1.5), 
    ylim = c(0, max(unlist(lapply(density, function(d){max(d$y)})))), 
    main = paste0("AMAR"))
  sub="ANOVA"
  for (j in c(1:length(levls))){
  	lines(density[[j]], col=j)
  }
  legend(x="topright", legend=levls, col=1:length(levls), lty = 1, title=covariate)           
}
