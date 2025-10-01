study_preproc_filename = paste0("./datashare/CustGSE147740rr/study_preproc_CustGSE147740rr.rds")
s = readRDS(study_preproc_filename)
e = s$exp_grp

study_preproc_filename2 = paste0("./datashare/GSE147740/study_preproc_GSE147740.rds")
s2 = readRDS(study_preproc_filename2)
e2 = s2$exp_grp


rownames(e2)
rownames(e)


dim(e2)
dim(e)

idx_samples = intersect(rownames(e), rownames(e2))

all(e[idx_samples,]$gender == e2[idx_samples,]$gender) 
all(e[idx_samples,]$age == e2[idx_samples,]$age) 



print("Build and format training and test sets")

nb_trains = 700
tmp_df = e[idx_samples,c("age", "gender")]
tmp_df$age = cut(tmp_df$age, quantile(tmp_df$age), include.lowest=TRUE)
foo = sapply(1:10000, function(i) {
  set.seed(i)
  idx_train = sample(idx_samples, nb_trains)
  idx_test = sample(setdiff(idx_samples, idx_train))
  fo = tmp_df[idx_train,]
  foo = prop.table(table(tmp_df$age, tmp_df$gender))
  bar = prop.table(table(fo$age, fo$gender))
  signif(sum((foo - bar)^2),3)  
})
i = which(foo==min(foo))
i  
foo[i]

set.seed(i)
custom_idx_train = sample(idx_samples, nb_trains)
custom_idx_test = sample(setdiff(idx_samples, idx_train))


