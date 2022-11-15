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

# No Tobacco status in this df

# 5. disease

s$exp_grp$disease = "control"
nb_disease = as.numeric(substr(s$exp_grp$diseasestatus,1,1))
for (i in 1:length(nb_disease)){
	if(nb_disease[i] != 1){
		s$exp_grp$disease[i] = "schizophrenia"
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
