orig_study = readRDS(paste0("~/projects/datashare/GSE89353/study_preproc_GSE89353.rds"))

# colnames(orig_study$data) == rownames(orig_study$exp_grp)
all(colnames(orig_study$data) == rownames(orig_study$exp_grp))
table(orig_study$exp_grp$gender, useNA="always")

gender = orig_study$exp_grp$gender
age = orig_study$exp_grp$age

# residuals = epimedtools::monitored_apply(orig_study$data, 1, function(meth) {
#   # meth = orig_study$data[1,]
#   m = lm(meth ~ gender + CC_PC1 + CC_PC2 + CC_PC3 + CC_PC4)
#   m$residuals
# })

if (!exists("cl_bs")) {
  if(!exists("nb_core")) {nb_core = parallel::detectCores()}
  cl_bs = parallel::makeCluster(nb_core, type="FORK")
}
residuals = parallel::parApply(cl_bs, orig_study$data, 1, function(meth, gender, age) {
  m = lm(meth ~ gender + age)
  m$residuals
}, gender, age)
parallel::stopCluster(cl_bs)
rm("cl_bs")

residuals = t(residuals)
typeof(residuals)
class(residuals)

s$data = residuals
s$platform_name = orig_study$platform_name
# idx_samples = intersect(colnames(s$data), rownames(s$exp_grp))
# s$data = s$data[, idx_samples]






