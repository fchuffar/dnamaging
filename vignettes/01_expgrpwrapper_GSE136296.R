s$exp_grp$age = as.numeric(as.character(s$exp_grp$"age:ch1"))

s$exp_grp$"Sex:ch1"  
s$exp_grp$gender = as.factor(as.character(s$exp_grp$"Sex:ch1"))  
sort(s$exp_grp$gender)

dim(s$exp_grp)
s$exp_grp$gender01 = as.numeric(s$exp_grp$gender)
library(EpiDISH)
betaData.m = s$data
dim(s$data)
BloodFrac.m <- epidish(betaData.m, ref.m = centDHSbloodDMC.m, method = "RPC")$estF
head(BloodFrac.m)
s$exp_grp = cbind(s$exp_grp, BloodFrac.m)



s$data = s$data[,rownames(s$exp_grp)] 


# remove probes on chrX and chrY
head(s$platform[,1:6]) 
table(s$platform[,1]) 
s$platform = s$platform[!s$platform[,1] %in% c("chrX", "chrY"),]
table(s$platform[,1]) 

s$data = s$data[rownames(s$platform),]