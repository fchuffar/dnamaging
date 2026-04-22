sample.sheet = file.path("~/projects/datashare_epistorage/expe5300/blood/SampleSheet_Blood_Final.csv")
e = read.table(sample.sheet, sep=",", header=TRUE)
head(e)
e$Sentrix_ID = gsub("rescan", "", e$Sentrix_ID)
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
s$exp_grp$tissue = as.factor("blood")  

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
s$exp_grp$disease = factor(s$exp_grp$CMSgroups, levels=c("NoCMS", "MildCMS", "ModSevCMS"))
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





# Deduplicate patients
s$exp_grp$Sample_Name = do.call(rbind, strsplit(as.character(s$exp_grp$Sample_Name), "_"))[,1]
s$exp_grp = s$exp_grp[!duplicated(s$exp_grp$Sample_Name),]

# Remove CMS patients from Puno (SV: Il vaut mieux exclure des analyses les sujets avec CMS de Puno)
# /s$exp_grp[c("X204855010055_R01C01","X204860510130_R01C01"),]
s$exp_grp = s$exp_grp[!(s$exp_grp$city=="Puno"&  s$exp_grp$disease!="NoCMS"),]
table(s$exp_grp$city, s$exp_grp$disease, useNA="always")


# - la comparaison en fonction de l'altitude de résidence peut être faite soit avec seulement les sujets sans CMS de La Rinconada, soit avec tous les sujets de La Rinconada


# Physio params ( SV: Côté paramètres physio clefs, répondre aux questions de base suivantes pourrait être une première étape: Quelles sont les différences/profils génétiques (méthylation en particulier) associées à l'altitude de résidence ? au statut de CMS (CMS score ou CMS group) chez les habitants de La Rinconada ? à la saturation artérielle en oxygène (SpO2) ? au niveau de concentration en hémoglobine ([Hb] et Hbmass) ? au niveau de pression artérielle pulmonaire (PAPM) ? au degré d'inflammation (TNF alpha par exemple qui augmente en altitude) ? )
foo = openxlsx::read.xlsx("~/projects/expedition_5300/data/LaRinconada-DataPhysio-Omics.xlsx", colNames=TRUE)
head(foo[,1:10])
rownames(foo) = foo[,1]
colnames(foo[s$exp_grp$Sample_Name,])

# meth ~ city
table(s$exp_grp$city, s$exp_grp$disease)

# meth ~ cityNoCMS
s$exp_grp$cityNoCMS = s$exp_grp$city
s$exp_grp[!s$exp_grp$disease %in% "NoCMS",]$cityNoCMS = NA
table(s$exp_grp$cityNoCMS, s$exp_grp$disease)

# meth ~ cmsRinc
s$exp_grp$cmsRinc = s$exp_grp$disease
s$exp_grp[!s$exp_grp$city %in% "Rinc",]$cmsRinc = NA
table(s$exp_grp$city, s$exp_grp$cmsRinc)

# meth ~ cmsRinc01
s$exp_grp$cmsRinc01 = as.numeric(s$exp_grp$disease != "NoCMS") 
s$exp_grp[!s$exp_grp$city %in% "Rinc",]$cmsRinc01 = NA
table(s$exp_grp$city, s$exp_grp$cmsRinc01)
table(s$exp_grp$cmsRinc, s$exp_grp$cmsRinc01)

# meth ~ SpO2
s$exp_grp$SpO2     = foo[s$exp_grp$Sample_Name,]$`SpO2_Min`
table(!is.na(s$exp_grp$SpO2), s$exp_grp$city)
table(!is.na(s$exp_grp$SpO2), s$exp_grp$disease)

# meth ~ Hb
s$exp_grp$Hb       = foo[s$exp_grp$Sample_Name,]$`[Hb]`
table(!is.na(s$exp_grp$Hb), s$exp_grp$city)
table(!is.na(s$exp_grp$Hb), s$exp_grp$disease)

# meth ~ Hbmass
s$exp_grp$Hbmass   = foo[s$exp_grp$Sample_Name,]$`Hbmass`
table(!is.na(s$exp_grp$Hbmass), s$exp_grp$city)
table(!is.na(s$exp_grp$Hbmass), s$exp_grp$disease)

# meth ~ PAPM
s$exp_grp$PAPM     = foo[s$exp_grp$Sample_Name,]$`PAPM`
table(!is.na(s$exp_grp$PAPM), s$exp_grp$city)
table(!is.na(s$exp_grp$PAPM), s$exp_grp$disease)

# meth ~ TNFalpha
s$exp_grp$TNFalpha = foo[s$exp_grp$Sample_Name,]$`TNF-a`
table(!is.na(s$exp_grp$TNFalpha), s$exp_grp$city)
table(!is.na(s$exp_grp$TNFalpha), s$exp_grp$disease)










