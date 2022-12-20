s$exp_grp$age = as.numeric(as.character(s$exp_grp$"age:ch1"))
data.frame(age=s$exp_grp$age, orig=s$exp_grp$"age:ch1")
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$age),]

s$exp_grp$"Sex:ch1"  
s$exp_grp$gender = as.factor(as.character(s$exp_grp$"Sex:ch1"))  
sort(s$exp_grp$gender)

dim(s$exp_grp)
s$exp_grp$gender01 = as.numeric(s$exp_grp$gender)
library(EpiDISH)
s$data = s$data[,rownames(s$exp_grp)] 
betaData.m = s$data
dim(s$data)
BloodFrac.m <- epidish(betaData.m, ref.m = centDHSbloodDMC.m, method = "RPC")$estF
head(BloodFrac.m)
s$exp_grp = cbind(s$exp_grp, BloodFrac.m)



s$data = s$data[,rownames(s$exp_grp)] 




