foo = openxlsx::read.xlsx("~/projects/datashare/GSE89353/GSE89353_41467_2018_4540_MOESM4_ESM.xlsx", colNames=TRUE, rowNames=TRUE);
head(foo[,1:6])





# 1. age
foo$age = foo$Age.at.enrollment.in.years
foo = foo[!is.na(foo$age), ]
foo[foo$age == "Newborn",]$age = 0
foo$age = as.numeric(foo$age)

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

# B. remove probes on chrX and chrY
head(s$platform[,1:6]) 
table(s$platform[,1]) 
s$platform = s$platform[!s$platform[,1] %in% c("chrX", "chrY"),]
table(s$platform[,1]) 
s$data = s$data[rownames(s$platform),]

# C. clean data
s$data = s$data[rownames(s$platform),rownames(s$exp_grp)] 
