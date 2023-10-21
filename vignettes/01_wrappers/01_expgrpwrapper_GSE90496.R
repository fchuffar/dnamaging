# 1. age

# 2. gender

# 3. tissue
s$exp_grp$"tissue:ch1" = s$exp_grp$"source_name_ch1"
s$exp_grp$tissue = as.factor(s$exp_grp$"tissue:ch1")
table(s$exp_grp$tissue, useNA="always")

# 4. tobacco

# 5. disease
s$exp_grp$disease = as.factor(s$exp_grp$"material:ch1")
table(s$exp_grp$disease, useNA="always")
levels(s$exp_grp$disease) = c("ffpe", "frozen")
table(s$exp_grp$disease, useNA="always")

# 6. BMI
# s$exp_grp$bmi =  as.numeric(as.character(s$exp_grp$"body mass index:ch1"))
# sort(s$exp_grp$bmi)

# 7. ethnicity
# s$exp_grp$ethnicity = as.factor(s$exp_grp$"race/ethnicity:ch1")
# table(s$exp_grp$ethnicity)

