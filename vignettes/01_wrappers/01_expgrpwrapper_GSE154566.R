# 1. age
s$exp_grp$"age:ch1"
s$exp_grp$age = as.numeric(substr(as.character(s$exp_grp$"age:ch1"), 5, 100))
sort(s$exp_grp$age)
quantile(s$exp_grp$age)
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$age), ]

# 2. gender
s$exp_grp$"gender:ch1"
s$exp_grp$gender = as.factor(s$exp_grp$"gender:ch1")
levels(s$exp_grp$gender) = substr(toupper(levels(s$exp_grp$gender)), 1, 1)
table(s$exp_grp$gender, useNA="always")
s$exp_grp$gender01 = as.numeric(s$exp_grp$gender)-1
table(s$exp_grp$gender01, useNA="always")

# 3. tissue
s$exp_grp$"tissue:ch1"
s$exp_grp$tissue = as.factor(s$exp_grp$"tissue:ch1")
table(s$exp_grp$tissue, useNA="always")
levels(s$exp_grp$tissue) = c("blood", "buccal")
table(s$exp_grp$tissue, useNA="always")

# 4. tobacco

# 5. disease
s$exp_grp$disease = as.factor(s$exp_grp$"disease state:ch1")
table(s$exp_grp$disease, useNA="always")

# 6. BMI
# s$exp_grp$bmi =  as.numeric(as.character(s$exp_grp$"body mass index:ch1"))
# sort(s$exp_grp$bmi)

# 7. ethnicity
# s$exp_grp$ethnicity = as.factor(s$exp_grp$"race/ethnicity:ch1")
# table(s$exp_grp$ethnicity)


