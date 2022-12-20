# 1. age
s$exp_grp$age = as.numeric(s$exp_grp$"age (y):ch1")
sort(s$exp_grp$age)
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$age), ]

# 2. gender
s$exp_grp$gender = as.factor(s$exp_grp$"gender:ch1")
table(s$exp_grp$gender, useNA="always")
s$exp_grp$gender01 = as.numeric(s$exp_grp$gender)-1
table(s$exp_grp$gender01, useNA="always")

# 3. tissue
s$exp_grp$tissue = as.factor(s$exp_grp$"tissue:ch1")
table(s$exp_grp$tissue, useNA="always")
s$exp_grp$tissue 

# 4. tobacco
# No tobacco informations in this data


# 5. disease
# No disease status in this data


