# 1. age
sort(s$exp_grp$age)
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$age), ]
s$data = s$data[,rownames(s$exp_grp)] 

# 2. gender
table(s$exp_grp$gender, useNA="always")
s$exp_grp$gender01 = as.numeric(s$exp_grp$gender)-1

# 3. tissue
table(s$exp_grp$cell_type, useNA="always")
s$exp_grp$cell_type = "blood"

# 4. tobacco

table(s$exp_grp$smoking, useNA="always")

# 4.1 tobacco_never_01 tobacco_current_01 tobacco_former_01 tobacco_occas01
s$exp_grp$smoking_never01 = 0
s$exp_grp$smoking_current01 = 0
s$exp_grp$smoking_former01 = 0
s$exp_grp$smoking_occas01 = 0

for(i in 1:length(s$exp_grp$smoking_status)){
	if(s$exp_grp$smoking_status[i] == "never"){
		s$exp_grp$smoking_never01[i] = 1
	} else if(s$exp_grp$smoking_status[i] == "ex"){
		s$exp_grp$smoking_former01[i] = 1
	} else if(s$exp_grp$smoking_status[i] == "current"){
		s$exp_grp$smoking_current01[i] = 1
	} else if(s$exp_grp$smoking_status[i] == "occasional"){
		s$exp_grp$smoking_occas01[i] = 1
	} else if(s$exp_grp$smoking_status[i] == "na"){
		s$exp_grp$smoking_status[i] = NA
	}
}

s$exp_grp = s$exp_grp[!is.na(s$exp_grp$smoking_status), ]
s$data = s$data[,rownames(s$exp_grp)] 


# 5. disease

s$exp_grp$disease = "control"
for (i in 1:length(s$exp_grp$disease_state)){
	if(s$exp_grp$disease_state[i] == "rheumatoid arthritis"){
		s$exp_grp$disease[i] = "rheumatoid arthritis"
	}
}


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

