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

# Calling data : methylation data and clinical data

df_clin = readRDS("../../datashare/GSE90496/df_GSE90496.rds")
clinical_data = readxl::read_excel("clinical_data_GSE90496.xlsx") #2802

# Filtering data 

colnames(clinical_data) = clinical_data[1,] # colnames are on first row
clinical_data = clinical_data[-1,] # delete of first row with clinical names
colnames(clinical_data)[2] = "Sentrix_ID" # Rename to merging
colnames(clinical_data)[7:8] = c("age","gender") # rename correctly age and gender
clinical_data = clinical_data[clinical_data$age != "not available",] #2503 delete individuals without age information
clinical_data = clinical_data[clinical_data$gender != "not available",] #2462 delete individuals without gender information
Sentrix_ID = strsplit(df_clin$supplementary_file,"_") # Sentrix_ID is on supplementary file link informations
Sentrix_ID = paste0(sapply(Sentrix_ID,"[[",2),"_",sapply(Sentrix_ID,"[[",3)) 
df_clin$supplementary_file=Sentrix_ID # replace supp_file ininteresting data with Sentrix_ID
colnames(df_clin)[32]="Sentrix_ID" 
colnames(df_clin)[colnames(df_clin)=="methylation class:ch1"]="meth_class" # Rename meth_class colname

# Creating meth_family (meth_class before comma)

split = strsplit(df_clin[,"meth_class"],",") 
split = sapply(split,"[[",1)
df_clin[,"tissue:ch1"]=split 
colnames(df_clin)[colnames(df_clin)=="tissue:ch1"] = "meth_family"

df_clin$meth_class[df_clin$meth_class == "PIN T,  PB A"] = "PIN T, PB A" #correlation between class problem (too spaces)
df_clin$meth_class[df_clin$meth_class == "PIN T,  PB B"] = "PIN T, PB B"

# Creating super_family (see DKFZ article)

super_f = readxl::read_excel("link_sf.xlsx")
df_tmp = merge(df_clin,super_f,by.x = "meth_class", by.y ="meth_class")
rownames(df_tmp) = df_tmp$geo_accession
df_tmp$characteristics_ch1.1 = df_tmp$super_family
df_tmp = df_tmp[,-ncol(df_tmp)]
colnames(df_tmp)[colnames(df_tmp)=="characteristics_ch1.1"] = "super_family"
df_clin = df_tmp

# Merging methylation data and clinical data

df_tmp = merge(df_clin,clinical_data,by.x = "Sentrix_ID", by.y ="Sentrix_ID")
rownames(df_tmp) = df_tmp$geo_accession
switch_place = df_tmp[,colnames(clinical_data)]
df_tmp = [,-colnames(clinical_data)]
markers_start = grep("cg",colnames(df_tmp))[1]
idx_clinicals = colnames(df_tmp)[1:(markers_start-1)]
idx_cpg = colnames(df_tmp)[markers_start:ncol(df_tmp)]
df_tmp = cbind.data.frame(df_tmp[,idx_clinicals],switch_place,df_tmp[,idx_cpg])
df_clin = df_tmp

df_clin$age = as.numeric(df_clin$age)
saveRDS(df_clin,"../../datashare/GSE90496/df_GSE90496.rds")

# Filter number of individuals cause of difficulties to modelise more than 1000 individuals 

nb_train = 1000
set.seed(1)
idx_train = sample(rownames(df_clin), nb_train)
df_clin_cut = df_clin[idx_train,]
