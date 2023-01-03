# 1. age

# 2. gender

# 3. tissue
s$exp_grp$tissue = as.factor("brain")  
table(s$exp_grp$tissue, useNA="always")

# 4. tobacco

# 5. disease
s$exp_grp$disease = as.factor(s$exp_grp$"sample type:ch1")
table(s$exp_grp$disease, useNA="always")
levels(s$exp_grp$disease) = c("control", "MCD")
table(s$exp_grp$disease, useNA="always")
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$disease), ]


