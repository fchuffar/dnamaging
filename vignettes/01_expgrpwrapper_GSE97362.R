# 1. age
s$exp_grp$age = as.numeric(as.character(s$exp_grp$age))
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$age), ]

# 2. gender
s$exp_grp$"gender:ch1"  
s$exp_grp$gender = as.factor(as.character(s$exp_grp$"gender:ch1"))  
table(s$exp_grp$gender, useNA="always")
s$exp_grp$gender01 = as.numeric(s$exp_grp$gender)-1

# 3. tissue
s$exp_grp$"tissue:ch1"  
s$exp_grp$tissue = as.factor(as.character(s$exp_grp$"tissue:ch1"))  
table(s$exp_grp$tissue, useNA="always")



# 4. tobacco

# 5. disease

