# 1. age

# 2. gender

# 3. tissue
s$exp_grp$"tissue:ch1"
s$exp_grp$tissue = as.factor(s$exp_grp$"tissue:ch1")
table(s$exp_grp$tissue, useNA="always")
s$exp_grp$tissue 
s$exp_grp$tissue = as.factor("blood")  
table(s$exp_grp$tissue, useNA="always")

# 4. tobacco
s$exp_grp$smoking_status = as.factor(s$exp_grp$"subject status:ch1")
table(s$exp_grp$smoking_status, useNA="always")
s$exp_grp$tobacco = NA
s$exp_grp[s$exp_grp$smoking_status%in%"non-smoker"  ,]$tobacco = "never"
s$exp_grp[s$exp_grp$smoking_status%in%"smoker",]$tobacco = "current"
s$exp_grp$tobacco = as.factor(s$exp_grp$tobacco)
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$tobacco), ]
table(s$exp_grp$tobacco, useNA="always")
# 4.1 tobacco_never_01 tobacco_current_01 tobacco_former_01 tobacco_occas01
s$exp_grp$tobacco_current01 = 0
s$exp_grp$tobacco_never01 = 0
s$exp_grp[s$exp_grp$tobacco%in%"current",]$tobacco_current01 = 1
s$exp_grp[s$exp_grp$tobacco%in%"never"  ,]$tobacco_never01   = 1
head(s$exp_grp[, c("tobacco", "tobacco_never01", "tobacco_current01")])

# 5. disease

