sample.sheet = file.path("~/projects/datashare_epistorage/expe5300/saliva/SampleSheet_Saliva.csv")
e = read.table(sample.sheet, sep=",", header=TRUE)
head(e)
rownames(e) = paste0("X",   e$Sentrix_ID, "_", e$Sentrix_Position)
head(e)
s$exp_grp = e
duplicated(e$Sample_Name)

# 1. age
s$exp_grp$Age
s$exp_grp$age = as.numeric(as.character(s$exp_grp$Age))
sort(s$exp_grp$age)
quantile(s$exp_grp$age)
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$age), ]

# 2. gender
s$exp_grp$gender = as.factor("M")

# 3. tissue
s$exp_grp$tissue = as.factor("saliva")  

# 4. tobacco
# s$exp_grp$smoking_status = as.factor(s$exp_grp$"smoking status:ch1")
# table(s$exp_grp$smoking_status, useNA="always")
# s$exp_grp$tobacco = NA
# s$exp_grp[s$exp_grp$smoking_status%in%"never"  ,]$tobacco = "never"
# s$exp_grp[s$exp_grp$smoking_status%in%"ex"     ,]$tobacco = "former"
# s$exp_grp[s$exp_grp$smoking_status%in%"current",]$tobacco = "current"
# s$exp_grp$tobacco = as.factor(s$exp_grp$tobacco)
# s$exp_grp = s$exp_grp[!is.na(s$exp_grp$tobacco), ]
# table(s$exp_grp$tobacco, useNA="always")
# # 4.1 tobacco_never_01 tobacco_current_01 tobacco_former_01 tobacco_occas01
# s$exp_grp$tobacco_current01 = 0
# s$exp_grp$tobacco_former01 = 0
# s$exp_grp$tobacco_never01 = 0
# s$exp_grp[s$exp_grp$tobacco%in%"current",]$tobacco_current01 = 1
# s$exp_grp[s$exp_grp$tobacco%in%"former" ,]$tobacco_former01  = 1
# s$exp_grp[s$exp_grp$tobacco%in%"never"  ,]$tobacco_never01   = 1
# head(s$exp_grp[, c("tobacco", "tobacco_never01", "tobacco_former01", "tobacco_current01")])

# 5. disease
s$exp_grp$disease = factor(s$exp_grp$CMSgroup, levels=c("NoCMS", "MildCMS", "ModSevCMS"))
table(s$exp_grp$disease, useNA="always")
levels(s$exp_grp$disease) = c("NoCMS", "MiCMS", "MSCMS")
table(s$exp_grp$disease, useNA="always")

# 6. BMI
# s$exp_grp$bmi =  as.numeric(as.character(s$exp_grp$"body mass index:ch1"))
# sort(s$exp_grp$bmi)

# 7. ethnicity
# s$exp_grp$ethnicity = as.factor(s$exp_grp$"race/ethnicity:ch1")
# table(s$exp_grp$ethnicity)

# 8. City
s$exp_grp$city = factor(s$exp_grp$City, levels=c("Lima", "Puno", "LaRinconada"))
table(s$exp_grp$city, s$exp_grp$disease, useNA="always")
table(s$exp_grp$city, useNA="always")
levels(s$exp_grp$city) = c("Lima", "Puno", "Rinc")
table(s$exp_grp$city, useNA="always")


# /s$exp_grp[c("X204855010055_R01C01","X204860510130_R01C01"),]

s$exp_grp = s$exp_grp[!(s$exp_grp$city=="Puno"&  s$exp_grp$disease!="NoCMS"),]
table(s$exp_grp$city, s$exp_grp$disease, useNA="always")

