# 1. age
s$exp_grp$age = as.numeric(as.character(s$exp_grp$"age_sampling:ch1"))
sort(s$exp_grp$age)
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$age), ]

# 2. gender
s$exp_grp$gender = as.factor(as.character(s$exp_grp$"gender:ch1"))
# levels(s$exp_grp$gender) = substr(toupper(levels(s$exp_grp$gender)), 1, 1)
table(s$exp_grp$gender, useNA="always")

# 3. tissue
s$exp_grp$tissue = as.factor(as.character(s$exp_grp$"source_name_ch1"))
table(s$exp_grp$tissue, useNA="always")
s$exp_grp$tissue 
s$exp_grp$tissue = as.factor("blood")  
table(s$exp_grp$tissue, useNA="always")

# 4. tobacco
s$exp_grp$tobacco = as.character(s$exp_grp$"smoking_evernever:ch1")
table(s$exp_grp$tobacco, useNA="always")
s$exp_grp[s$exp_grp$tobacco%in%"E",]$tobacco = "former"
s$exp_grp[s$exp_grp$tobacco%in%"N",]$tobacco = "never"
table(s$exp_grp$tobacco, useNA="always")
s$exp_grp[s$exp_grp$tobacco%in%"former"&s$exp_grp$"smoke_free_years:ch1"==0,]$tobacco = "current"
table(s$exp_grp$tobacco, useNA="always")
s$exp_grp$tobacco = as.factor(s$exp_grp$tobacco)
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$tobacco), ]
foo = s$exp_grp[, c("smoke_free_years:ch1", "smoking_evernever:ch1", "tobacco")]
foo[order(foo[,3]),]
table(s$exp_grp$tobacco, useNA="always")
# 4.1 tobacco_never_01 tobacco_current_01 tobacco_former_01 tobacco_occas01
s$exp_grp$tobacco_current01 = 0
s$exp_grp$tobacco_former01 = 0 
s$exp_grp$tobacco_never01 = 0
s$exp_grp[s$exp_grp$tobacco%in%"current",]$tobacco_current01 = 1
s$exp_grp[s$exp_grp$tobacco%in%"former" ,]$tobacco_former01  = 1
s$exp_grp[s$exp_grp$tobacco%in%"never"  ,]$tobacco_never01   = 1
head(s$exp_grp[, c("tobacco", "tobacco_never01", "tobacco_former01", "tobacco_current01")])


# No tobacco informations in this data


# 5. disease
# No disease status in this data


