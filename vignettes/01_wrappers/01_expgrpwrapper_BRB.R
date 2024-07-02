dir.create(paste0("./datashare/BRB/"))
tcga_study = readRDS(paste0("~/projects/tcga_studies/study_BRB_meth.rds"))
s$exp_grp = tcga_study$exp_grp

s$exp_grp$paired_with = gsub(" " , "", s$exp_grp$paired_with)


s$exp_grp[,c("age_min", "gender", "paired_with")]


s$exp_grp$id_patient = rownames(s$exp_grp)
for (gsm in rownames(s$exp_grp)[!is.na(s$exp_grp$paired_with)]) {
  pw = s$exp_grp[gsm,]$paired_with
  # print(s$exp_grp[gsm,]$age_min)
  if (is.na(s$exp_grp[gsm,]$age_min)) {
    print(s$exp_grp[pw,]$age_min)
    s$exp_grp[gsm,]$age_min = s$exp_grp[pw,]$age_min
  }
  if (s$exp_grp[gsm,]$gender == "NTL") {
    print(s$exp_grp[pw,]$gender)
    s$exp_grp[gsm,]$gender = s$exp_grp[pw,]$gender
  }
  if (pw %in% rownames(s$exp_grp))s$exp_grp[gsm,]$id_patient = paste(sort(c(s$exp_grp[pw,]$paired_with, s$exp_grp[gsm,]$paired_with)), collapse="_")
}

table(s$exp_grp[,c("paired_with")])


s$exp_grp["GSM748118",c("age_min", "gender", "paired_with")]
s$exp_grp["GSM748232",c("age_min", "gender", "paired_with")]
s$exp_grp[!is.na(s$exp_grp$paired_with),c("age_min", "gender", "paired_with", "id_patient", "tissue_status")]
table(s$exp_grp[!is.na(s$exp_grp$paired_with),c("tissue_status")])


# 1. age
s$exp_grp$age = s$exp_grp$age_min
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$age), ]

# 2. gender
s$exp_grp$gender = as.factor(s$exp_grp$gender)
levels(s$exp_grp$gender) = substr(toupper(levels(s$exp_grp$gender)), 1, 1)
table(s$exp_grp$gender, useNA="always")
s$exp_grp$gender01 = as.numeric(s$exp_grp$gender)-1
table(s$exp_grp$gender01, useNA="always")

# 3. tissue
s$exp_grp$tissue = s$exp_grp$tissue_group_level1
table(s$exp_grp$tissue, useNA="always")

# # 4. tobacco
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
s$exp_grp$disease  = as.factor(s$exp_grp$tissue_status)
table(s$exp_grp$disease, useNA="always")
# levels(s$exp_grp$disease) = c("control", "rheumatoid arthritis")
# table(s$exp_grp$disease, useNA="always")
# s$exp_grp = s$exp_grp[!is.na(s$exp_grp$disease), ]

# # 6. BMI
# # s$exp_grp$bmi =  as.numeric(as.character(s$exp_grp$"body mass index:ch1"))
# # sort(s$exp_grp$bmi)
#
# # 7. ethnicity
# # s$exp_grp$ethnicity = as.factor(s$exp_grp$"race/ethnicity:ch1")
# # table(s$exp_grp$ethnicity)
#
#

s$exp_grp$ethnicity = NULL