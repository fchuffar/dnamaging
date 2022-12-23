# 1. age
s$exp_grp$"age:ch1"
s$exp_grp$age = as.numeric(as.character(s$exp_grp$"age:ch1"))
sort(s$exp_grp$age)
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$age), ]

# 2. gender
s$exp_grp$gender = as.factor(s$exp_grp$"gender:ch1")
table(s$exp_grp$gender, useNA="always")
s$exp_grp$gender01 = as.numeric(s$exp_grp$gender)-1
table(s$exp_grp$gender01, useNA="always")

# 3. tissue
s$exp_grp$tissue = as.factor(s$exp_grp$"source_name_ch1")
table(s$exp_grp$tissue, useNA="always")
s$exp_grp$tissue 

# 4. tobacco
s$exp_grp$smoking_status = as.factor(s$exp_grp$"smoking status:ch1")
table(s$exp_grp$smoking_status, useNA="always")
s$exp_grp$tobacco = NA
s$exp_grp[s$exp_grp$smoking_status%in%"never smoker"  ,]$tobacco = "never"
s$exp_grp[s$exp_grp$smoking_status%in%"ever smoker"     ,]$tobacco = "ever"
s$exp_grp$tobacco = as.factor(s$exp_grp$tobacco)
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$tobacco), ]
table(s$exp_grp$tobacco, useNA="always")

# 5. disease
s$exp_grp$disease = as.factor(s$exp_grp$"disease status:ch1")
table(s$exp_grp$disease, useNA="always")
levels(s$exp_grp$disease) = c("control", "MS")
table(s$exp_grp$disease, useNA="always")
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$disease), ]


