# 1. age
sort(s$exp_grp$age)
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$age), ]
s$data = s$data[,rownames(s$exp_grp)] 

# 2. gender
table(s$exp_grp$gender, useNA="always")
s$exp_grp$gender01 = as.numeric(s$exp_grp$gender)-1

# 3. tissue
table(s$exp_grp$cell_type, useNA="always")
s$exp_grp$tissue = s$exp_grp$cell_type

# 4. tobacco
table(s$exp_grp$smoking_status, useNA="always")
s$exp_grp$tobacco = NA
s$exp_grp$tobacco[s$exp_grp$smoking_status%in%"current",] = "current"
s$exp_grp$tobacco[s$exp_grp$smoking_status%in%"ex",] = "former"
s$exp_grp$tobacco[s$exp_grp$smoking_status%in%"never",] = "never"
# 4.1 tobacco_never_01 tobacco_current_01 tobacco_former_01 tobacco_occas01
s$exp_grp$tobacco_current01 = 0
s$exp_grp$tobacco_former01 = 0 
s$exp_grp$tobacco_never01 = 0
s$exp_grp[s$exp_grp$tobacco%in%"current",]$tobacco_current01 = 1
s$exp_grp[s$exp_grp$tobacco%in%"former" ,]$tobacco_former01  = 1
s$exp_grp[s$exp_grp$tobacco%in%"never"  ,]$tobacco_never01   = 1
# s$exp_grp = s$exp_grp[!is.na(s$exp_grp$tobacco), ]
s$data = s$data[,rownames(s$exp_grp)] 

# 5. disease
s$exp_grp$disease = NA
s$exp_grp$disease[s$exp_grp$disease_state %in% "rheumatoid arthritis",] = "rheumatoid arthritis"
s$exp_grp$disease[s$exp_grp$disease_state %in% "Normal",] = "control"

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

