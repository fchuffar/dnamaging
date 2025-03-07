# 1. age
s$exp_grp$"age:ch1"
s$exp_grp$age = as.numeric(as.character(s$exp_grp$"age:ch1"))
sort(s$exp_grp$age)
quantile(s$exp_grp$age)
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$age), ]

# 2. gender
s$exp_grp$"Sex:ch1"
s$exp_grp$gender = as.factor(s$exp_grp$"Sex:ch1")
levels(s$exp_grp$gender) = substr(toupper(levels(s$exp_grp$gender)), 1, 1)
table(s$exp_grp$gender, useNA="always")
s$exp_grp$gender01 = as.numeric(s$exp_grp$gender)-1
table(s$exp_grp$gender01, useNA="always")

# 3. tissue
s$exp_grp$tissue = as.factor("blood")  
table(s$exp_grp$tissue, useNA="always")

# 4. tobacco
s$exp_grp$smoking_status = as.factor(s$exp_grp$"smokingstatus")
table(s$exp_grp$smoking_status, useNA="always")
s$exp_grp$tobacco = NA
s$exp_grp[s$exp_grp$smoking_status%in%"never"  ,]$tobacco = "never"
s$exp_grp[s$exp_grp$smoking_status%in%"former" ,]$tobacco = "former"
s$exp_grp[s$exp_grp$smoking_status%in%"current",]$tobacco = "current"
s$exp_grp$tobacco = as.factor(s$exp_grp$tobacco)
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$tobacco), ]
table(s$exp_grp$tobacco, useNA="always")
# 4.1 tobacco_never_01 tobacco_current_01 tobacco_former_01 tobacco_occas01
s$exp_grp$tobacco_current01 = 0
s$exp_grp$tobacco_former01 = 0 
s$exp_grp$tobacco_never01 = 0
s$exp_grp[s$exp_grp$tobacco%in%"current",]$tobacco_current01 = 1
s$exp_grp[s$exp_grp$tobacco%in%"former" ,]$tobacco_former01  = 1
s$exp_grp[s$exp_grp$tobacco%in%"never"  ,]$tobacco_never01   = 1
head(s$exp_grp[, c("tobacco", "tobacco_never01", "tobacco_former01", "tobacco_current01")])

# 5. disease
s$exp_grp$disease = as.factor(s$exp_grp$"diseasestatus:ch1")
table(s$exp_grp$disease, useNA="always")
levels(s$exp_grp$disease) = c("control", "Parkinson")
table(s$exp_grp$disease, useNA="always")
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$disease), ]

# 6. BMI
# s$exp_grp$bmi =  as.numeric(as.character(s$exp_grp$"body mass index:ch1"))
# sort(s$exp_grp$bmi)

# 7. ethnicity
s$exp_grp$ethnicity = as.factor("Caucasian")
table(s$exp_grp$ethnicity)


