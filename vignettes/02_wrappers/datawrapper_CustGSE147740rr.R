gse_orig = substr(gse, 5, nchar(gse)-2)
orig_study = readRDS(paste0("~/projects/datashare/",  gse_orig , "/study_preproc_",  gse_orig , ".rds"))

# colnames(orig_study$data) == rownames(orig_study$exp_grp)
all(colnames(orig_study$data) == rownames(orig_study$exp_grp))
table(orig_study$exp_grp$gender, useNA="always")

data = as.matrix(orig_study$exp_grp[,c("B", "NK", "CD4T", "CD8T", "Mono", "Neutro", "Eosino")])
pca = prcomp(data)
v = pca$sdev * pca$sdev
p = v / sum(v) * 100
colnames(pca$x) = paste0("CC_", colnames(pca$x))
orig_study$exp_grp = cbind(orig_study$exp_grp, pca$x[,1:4])

gender = orig_study$exp_grp$gender
CC_PC1 = orig_study$exp_grp$CC_PC1
CC_PC2 = orig_study$exp_grp$CC_PC2
CC_PC3 = orig_study$exp_grp$CC_PC3
CC_PC4 = orig_study$exp_grp$CC_PC4

# residuals = epimedtools::monitored_apply(orig_study$data, 1, function(meth) {
#   # meth = orig_study$data[1,]
#   m = lm(meth ~ gender + CC_PC1 + CC_PC2 + CC_PC3 + CC_PC4)
#   m$residuals
# })

if (!exists("cl_bs")) {
  if(!exists("nb_cores")) {
    nb_cores = parallel::detectCores()
  }
  nb_cores = min(32, nb_cores)
  cl_bs = parallel::makeCluster(nb_cores, type="FORK")
}
residuals = parallel::parApply(cl_bs, orig_study$data, 1, function(meth, gender, CC_PC1, CC_PC2, CC_PC3, CC_PC4) {
  m = lm(meth ~ gender + CC_PC1 + CC_PC2 + CC_PC3 + CC_PC4)
  m$residuals
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






