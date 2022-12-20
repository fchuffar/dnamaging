# 1. age
s$exp_grp$age = as.numeric(s$exp_grp$"age:ch1")
sort(s$exp_grp$age)
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$age), ]


# 2. gender
table(s$exp_grp$"gender:ch1")
s$exp_grp = s$exp_grp[!s$exp_grp$"gender:ch1"%in%"NA",]
table(s$exp_grp$"gender:ch1")
s$exp_grp$gender = as.factor(s$exp_grp$"gender:ch1")
table(s$exp_grp$gender, useNA="always")
s$exp_grp$gender01 = as.numeric(s$exp_grp$gender)-1
table(s$exp_grp$gender01, useNA="always")

# 3. tissue
s$exp_grp$tissue = as.factor(s$exp_grp$"tissue:ch1")
table(s$exp_grp$tissue, useNA="always")
s$exp_grp$tissue 

# 4. tobacco
# No Tobacco status in this df

# 5. disease
s$exp_grp$disease = as.factor(s$exp_grp$"diseasestatus:ch1")
table(s$exp_grp$disease, useNA="always")
levels(s$exp_grp$disease) = c("control", "schizophrenia")
table(s$exp_grp$disease, useNA="always")
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$disease), ]


