# 1. age
s$exp_grp$"age at diagnosis (years):ch1"
s$exp_grp$age = as.numeric(as.character(s$exp_grp$"age at diagnosis (years):ch1"))
sort(s$exp_grp$age)
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$age), ]

# 2. gender
s$exp_grp$gender = as.factor(s$exp_grp$"gender:ch1")
levels(s$exp_grp$gender) = substr(toupper(levels(s$exp_grp$gender)), 1, 1)
table(s$exp_grp$gender, useNA="always")
s$exp_grp$gender01 = as.numeric(s$exp_grp$gender)-1
table(s$exp_grp$gender01, useNA="always")

# 3. tissue
s$exp_grp$tissue = as.factor(as.character(s$exp_grp$"tissue:ch1"))
table(s$exp_grp$tissue, useNA="always")
s$exp_grp$tissue = as.factor("brain glioblastoma")
table(s$exp_grp$tissue, useNA="always")
s$exp_grp$tissue 

# 4. tobacco
# No tobacco informations in this data


# 5. disease
# No disease status in this data


