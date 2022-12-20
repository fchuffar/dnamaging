# 1. age
s$exp_grp$age = as.numeric(as.character(s$exp_grp$"age:ch1"))
sort(s$exp_grp$age)
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$age), ]
s$data = s$data[,rownames(s$exp_grp)] 

# 2. gender
s$exp_grp$"Sex:ch1"  
s$exp_grp$gender = as.factor(as.character(s$exp_grp$"Sex:ch1"))  
table(s$exp_grp$gender, useNA="always")
s$exp_grp$gender01 = as.numeric(s$exp_grp$gender)-1

# 3. tissue
s$exp_grp$"tissue:ch1"  
s$exp_grp$tissue = as.factor(as.character(s$exp_grp$"tissue:ch1"))  
table(s$exp_grp$tissue, useNA="always")


# 4. tobacco

# 5. disease


# A. cell composition
library(EpiDISH)
betaData.m = s$data
dim(s$data)
BloodFrac.m <- epidish(betaData.m, ref.m = centDHSbloodDMC.m, method = "RPC")$estF
head(BloodFrac.m)
dim(BloodFrac.m)
s$exp_grp = cbind(s$exp_grp, BloodFrac.m[rownames(s$exp_grp),])
head(s$exp_grp)

