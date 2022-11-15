# 1. age
sort(s$exp_grp$age)
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$age), ]
s$data = s$data[,rownames(s$exp_grp)] 

# 2. gender
table(s$exp_grp$gender, useNA="always")

# 3. tissue
table(s$exp_grp$tissue, useNA="always")
s$exp_grp$tissue = "blood"

# 4. tobacco
table(s$exp_grp$smoking, useNA="always")
s$exp_grp$smoking = as.numeric(s$exp_grp$smoking)

# 4.1 tobacco_never_01 tobacco_current_01 tobacco_former_01
df$smoking_never = 0
df$smoking_current = 0
df$smoking_former = 0
for(i in 1:length(s$exp_grp$smoking)){
	if(s$exp_grp$smoking[i] == 0){
		df$smoking_never[i] = 1
	} else if(s$exp_grp$smoking[i] == 1){
		df$smoking_former[i] = 1
	} else if(s$exp_grp$smoking[i] == 2){
		df$smoking_current[i] = 1
	}
}

# 5. disease

# No disease in this data


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
