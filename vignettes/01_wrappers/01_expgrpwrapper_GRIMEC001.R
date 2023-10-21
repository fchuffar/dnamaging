exp_grp = openxlsx::read.xlsx("datashare/GRIMEC001/IAB_2023_02_22.xlsx",sheet=2)
dim(exp_grp)
head(exp_grp[,1:6])
exp_grp$sample_id = paste0("SMP",substr(exp_grp[,"TD-GENET.NUMBER"],1,7),"_",exp_grp[,"BEADCHIP.SAMPLE.NUMBER"])
rownames(exp_grp) = exp_grp$sample_id
exp_grp = exp_grp[order(rownames(exp_grp)),]
# convert meth_class
dico = openxlsx::read.xlsx("NIHMS942946-supplement-Sup_Table_1.xlsx")
rownames(dico) = dico[,1]
exp_grp$meth_class = dico[paste0("methylation class ",do.call(rbind,strsplit(do.call(rbind,strsplit(gsub("pediatric","paediatric",gsub("\r\n"," ",gsub("0,","0.",gsub( "Methylation class family", "MCF",exp_grp[,"DKFZ.CLASSIFIER.RESULT.brain.v11b4"])))), "ethylation class "))[,2]," 0.",fixed=TRUE))[,1]),2]
exp_grp$meth_class

s$exp_grp = exp_grp

# # data
# df_grim = mreadRDS("datashare/GRIMEC001/df_GRIMEC001.rds") # Grimec data
# df_grim = t(df_grim)
# df_grim = as.data.frame(df_grim)
# dim(df_grim)
# head(df_grim)[,1:6]
# df_grim$meth_class = exp_grp[,"DKFZ.CLASSIFIER.RESULT.brain.v11b4"]
# cbind(rownames(df_grim), rownames(exp_grp))
# df_grim$meth_class = exp_grp[rownames(df_grim),]$meth_class


# 1. age
s$exp_grp$AGE
s$exp_grp$age = as.numeric(as.character(s$exp_grp$AGE))
sort(s$exp_grp$age)
quantile(s$exp_grp$age)
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$age), ]

# 2. gender
s$exp_grp$GENDER
s$exp_grp$gender = as.factor(s$exp_grp$GENDER)
levels(s$exp_grp$gender) = substr(toupper(levels(s$exp_grp$gender)), 1, 1)
table(s$exp_grp$gender, useNA="always")
s$exp_grp$gender01 = as.numeric(s$exp_grp$gender)-1
table(s$exp_grp$gender01, useNA="always")

# 3. tissue
s$exp_grp$tissue = as.factor("brain")  
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

# # 5. disease
# s$exp_grp$disease = as.factor(s$exp_grp$"disease state:ch1")
# table(s$exp_grp$disease, useNA="always")
# levels(s$exp_grp$disease) = c("control", "rheumatoid arthritis")
# table(s$exp_grp$disease, useNA="always")
# s$exp_grp = s$exp_grp[!is.na(s$exp_grp$disease), ]

# 6. BMI
# s$exp_grp$bmi =  as.numeric(as.character(s$exp_grp$"body mass index:ch1"))
# sort(s$exp_grp$bmi)

# 7. ethnicity
# s$exp_grp$ethnicity = as.factor(s$exp_grp$"race/ethnicity:ch1")
# table(s$exp_grp$ethnicity)


