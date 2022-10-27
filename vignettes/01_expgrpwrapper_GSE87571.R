s$exp_grp$"age:ch1"
s$exp_grp$age = as.numeric(as.character(s$exp_grp$"age:ch1"))
sort(s$exp_grp$age)
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$age), ]



s$exp_grp$"gender:ch1"  
s$exp_grp$gender = as.factor(as.character(s$exp_grp$"gender:ch1"))  
sort(s$exp_grp$gender)

s$data = s$data[,rownames(s$exp_grp)] 


# remopve probes on chrX and chrY
head(s$platform[,1:6]) 
table(s$platform[,1]) 
s$platform = s$platform[!s$platform[,1] %in% c("chrX", "chrY"),]
table(s$platform[,1]) 

s$data = s$data[rownames(s$platform),]