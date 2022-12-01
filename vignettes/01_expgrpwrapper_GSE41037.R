 # 1. age
sort(s$exp_grp$age)
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$age), ]
s$data = s$data[,rownames(s$exp_grp)] 

# Platform
s$platform_name
if (s$platform_name=="GPL8490") {
	platform = "27k"
} else if (s$platform_name=="GPL13534"){
	platform = "450k"
} else if (s$platform_name%in%c("GPL21145", "GPL23976")) {
	platform = "epic"
}

s$exp_grp$platform = rep(platform,length(s$exp_grp$age))

# 2. gender
table(s$exp_grp$gender, useNA="always")
gender = rep(NA,length(s$exp_grp$gender))
gender[s$exp_grp$gender%in%"male"]="m"
gender[s$exp_grp$gender%in%"female"]="f"
s$exp_grp$gender = gender
#s$exp_grp$gender01 = as.numeric(s$exp_grp$gender)-1
s$exp_grp$gender01 = rep(NA,length(s$exp_grp$gender))
s$exp_grp$gender01[s$exp_grp$gender%in%"f"]=0
s$exp_grp$gender01[s$exp_grp$gender%in%"m"]=1

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
#library(EpiDISH)
#betaData.m = s$data
#dim(s$data)
#BloodFrac.m <- epidish(betaData.m, ref.m = centDHSbloodDMC.m, method = "RPC")$estF
#head(BloodFrac.m)
#dim(BloodFrac.m)
#s$exp_grp = cbind(s$exp_grp, BloodFrac.m[rownames(s$exp_grp),])
#head(s$exp_grp)





# B. remove probes on chrX and chrY
head(s$platform[,1:6]) 
table(s$platform[,1]) 
s$platform = s$platform[!s$platform[,1] %in% c("chrX", "chrY"),]
table(s$platform[,1]) 
s$data = s$data[rownames(s$platform),]

# C. clean data
s$data = s$data[rownames(s$platform),rownames(s$exp_grp)] 
