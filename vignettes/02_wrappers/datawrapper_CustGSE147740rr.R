gse_orig = substr(gse, 5, nchar(gse)-2)
orig_study = readRDS(paste0("~/projects/datashare/",  gse_orig , "/study_preproc_",  gse_orig , ".rds"))

# colnames(orig_study$data) == rownames(orig_study$exp_grp)
if (!all(colnames(orig_study$data) == rownames(orig_study$exp_grp))) {stop("not all data colnames are equal to exp_grp rownames in orig_study.")}

data = as.matrix(orig_study$exp_grp[,c("B", "NK", "CD4T", "CD8T", "Mono", "Neutro", "Eosino")])
pca = prcomp(data)
v = pca$sdev * pca$sdev
p = v / sum(v) * 100
colnames(pca$x) = paste0("CC_", colnames(pca$x))
orig_study$exp_grp = cbind(orig_study$exp_grp, pca$x[,1:4])


layout(matrix(1:6, 2, byrow=FALSE), respect=TRUE)
barplot(p, main="% of expl. var.")
barplot(
  t(as.matrix(data)),
  beside = FALSE,          # empilé
  col = rainbow(ncol(data)), 
  legend = colnames(data),
  args.legend = list(bg = "white"),  # arrière-plan blanc
  xlab = "Patients",
  ylab = "Proportion",
  las=2,
  border = NA
)
i = 1
cols = 1
for (i in 1:4) {
  j = i+1
  plot(pca$x[,i], pca$x[,j], xlab=paste0("PC", i, "(", signif(p[i], 3), "%)"), ylab=paste0("PC", j, "(", signif(p[j], 3), "%)"), col=adjustcolor(cols, alpha.f=0.3), pch=16)
  # for (lev in levels(s$exp_grp$tissue)) {
  #   tmp_idx = rownames(s$exp_grp)[s$exp_grp$tissue==lev]
  #   text(mean(pca$x[tmp_idx,i]), mean(pca$x[tmp_idx,j]), lev)
  # }
}





gender = orig_study$exp_grp$gender
CC_PC1 = orig_study$exp_grp$CC_PC1
CC_PC2 = orig_study$exp_grp$CC_PC2
CC_PC3 = orig_study$exp_grp$CC_PC3
CC_PC4 = orig_study$exp_grp$CC_PC4


# data = orig_study$data[1:10000,]
# # data = orig_study$data
# range(data)
# residuals = epimedtools::monitored_apply(data, 1, function(meth) {
#   # meth = orig_study$data[7,]
#   layout(matrix(1:6, 2, byrow=TRUE), respect=TRUE)
#   mvalues = log2(meth / (1 - meth))
#   # plot(meth, mvalues)
#   mmvalues = lm(mvalues ~ gender + CC_PC1 + CC_PC2 + CC_PC3 + CC_PC4)
#   # mmvalues = MASS::rlm(mvalues ~ gender + CC_PC1 + CC_PC2 + CC_PC3 + CC_PC4)
#   resm = mmvalues$residuals + mmvalues$coefficients[[1]]
#   resbeta = 2^resm / (1 + 2^resm)
#   plot(meth, resbeta)
#   mbeta = lm(meth ~ gender + CC_PC1 + CC_PC2 + CC_PC3 + CC_PC4)
#   # mbeta = MASS::rlm(meth ~ gender + CC_PC1 + CC_PC2 + CC_PC3 + CC_PC4)
#   resb = mbeta$residuals + mbeta$coefficients[[1]]
#   plot(meth, resb)
#   plot(resbeta, resb)
#   return(resbeta)
# })
# residuals = t(residuals)
# plot(apply(residuals, 1, mean), apply(data, 1, mean)) 





if (!exists("cl_bs")) {
  if(!exists("nb_cores")) {
    nb_cores = parallel::detectCores()
  }
  nb_cores = min(32, nb_cores)
  cl_bs = parallel::makeCluster(nb_cores, type="FORK")
}
residuals = parallel::parApply(cl_bs, orig_study$data, 1, function(meth, gender, CC_PC1, CC_PC2, CC_PC3, CC_PC4) {
  # meth = orig_study$data[1,]
  # m = lm(meth ~ gender + CC_PC1 + CC_PC2 + CC_PC3 + CC_PC4)
  # m$residuals + m$coefficients[[1]]
  mvalues = log2(meth / (1 - meth))
  # plot(meth, mvalues)
  mmvalues = lm(mvalues ~ gender + CC_PC1 + CC_PC2 + CC_PC3 + CC_PC4)
  # mmvalues = MASS::rlm(mvalues ~ gender + CC_PC1 + CC_PC2 + CC_PC3 + CC_PC4)
  resm = mmvalues$residuals + mmvalues$coefficients[[1]]
  resbeta = 2^resm / (1 + 2^resm)
  return(resbeta)
}, gender, CC_PC1, CC_PC2, CC_PC3, CC_PC4)
parallel::stopCluster(cl_bs)
rm("cl_bs")

residuals = t(residuals)
typeof(residuals)
class(residuals)

s$data = residuals
s$platform_name = orig_study$platform_name
idx_samples = intersect(colnames(s$data), rownames(s$exp_grp))
s$data = s$data[, idx_samples]






