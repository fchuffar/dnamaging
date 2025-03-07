# s = readRDS("~/projects/datashare/GSE152710/study_GSE152710.rds")
exp_grp_paper = openxlsx::read.xlsx("~/projects/dnamaging/misc/13148_2021_1002_MOESM1_ESM_STab1.xlsx")
exp_grp_paper[,1] = as.character(exp_grp_paper[,1])
head(exp_grp_paper)
dim(exp_grp_paper)

# Patient with a lot of observations
sort(table(exp_grp_paper[,1]))
# Patient where MDS ---> AML
tab = apply(table(exp_grp_paper[,1], exp_grp_paper[,4]) == 0, 1, sum) 
exp_grp_paper[exp_grp_paper[,1]%in%names(tab)[tab==0],]


head(s$exp_grp[,1:6])
dim(s$exp_grp)

head(s$exp_grp[,c("title", "response:ch1", "time afer diagnosis:ch1", "tissue:ch1", "treatment:ch1")])
table(exp_grp_paper["Treatment"])
table(s$exp_grp[,c("treatment:ch1")])

# s$exp_grp$title
foo = do.call(rbind, strsplit(s$exp_grp$title, "_"))[,c(1,3)]
foo = foo[foo[,2]!="CTR",]
foo = foo[!duplicated(foo[,2]),]
colnames(foo) = c("idx", "pid")
foo = data.frame(foo)
foo$idx = as.numeric(foo$idx)
rownames(foo) = paste0("pid", foo$pid)

# exp_grp_paper
exp_grp_paper$offset = as.numeric(gsub("R", "", exp_grp_paper[,2]))
exp_grp_paper$pid = exp_grp_paper[,1]
bar = exp_grp_paper[,c("offset", "pid")]
bar = bar[!duplicated(bar$pid),]
rownames(bar) = paste0("pid", bar$pid)

head(foo)
head(bar)

exp_grp_paper$title = paste0(exp_grp_paper$offset - bar[paste0("pid", exp_grp_paper$pid),]$offset + foo[paste0("pid", exp_grp_paper$pid),]$idx, "_smp_", exp_grp_paper$pid)
head(exp_grp_paper)

head(s$exp_grp[,1:6])

if (sum(!exp_grp_paper$title %in% s$exp_grp$title) != 0) {stop("problem in 13148_2021_1002_MOESM1_ESM_STab1.xlsx precessing")}
# exp_grp_paper[!exp_grp_paper$title %in% s$exp_grp$title,]
rownames(exp_grp_paper) = exp_grp_paper$title

# head(s$exp_grp)

s$exp_grp$title[!s$exp_grp$title %in% rownames(exp_grp_paper)]
s$exp_grp[!s$exp_grp$title %in% rownames(exp_grp_paper),1:6]
baz = s$exp_grp[s$exp_grp$title %in% rownames(exp_grp_paper),]
dim(baz)

exp_grp_paper$gsm = NA
exp_grp_paper[baz$title,]$gsm = rownames(baz)
exp_grp_paper$gsm
rownames(exp_grp_paper) = exp_grp_paper$gsm
head(exp_grp_paper)
dim(exp_grp_paper)

colnames(exp_grp_paper)
head(exp_grp_paper)

s$exp_grp$disease = exp_grp_paper[rownames(s$exp_grp),]$"Cytological.category.group"                             
s$exp_grp$treatment = exp_grp_paper[rownames(s$exp_grp),]$"Treatment"                                              
s$exp_grp$response = exp_grp_paper[rownames(s$exp_grp),]$"Sample.stage"                                           

s$exp_grp$time = exp_grp_paper[rownames(s$exp_grp),]$"Disease.time.point.(diagnosis.or.months.from.diagnosis)"
s$exp_grp[is.na(s$exp_grp$time),]$time = "00m_Control"
s$exp_grp[s$exp_grp$time%in%"Diagnosis",]$time = "00m_Diagnosis"
table(s$exp_grp$time)




# # 1. age
# s$exp_grp$"age:ch1"
# s$exp_grp$age = as.numeric(as.character(s$exp_grp$"age:ch1"))
# sort(s$exp_grp$age)
# quantile(s$exp_grp$age)
# s$exp_grp = s$exp_grp[!is.na(s$exp_grp$age), ]

# # 2. gender
# s$exp_grp$"gender:ch1"
# s$exp_grp$gender = as.factor(s$exp_grp$"gender:ch1")
# levels(s$exp_grp$gender) = substr(toupper(levels(s$exp_grp$gender)), 1, 1)
# table(s$exp_grp$gender, useNA="always")
# s$exp_grp$gender01 = as.numeric(s$exp_grp$gender)-1
# table(s$exp_grp$gender01, useNA="always")

# 3. tissue
s$exp_grp$tissue = as.factor("bone marrow")
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
s$exp_grp[is.na(s$exp_grp$disease),]$disease = "CTR"
table(s$exp_grp$disease, useNA="always")
s$exp_grp$disease = factor(s$exp_grp$disease, levels=c("CTR", "MDS", "AML"))
table(s$exp_grp$disease, useNA="always")

# 6. BMI
# s$exp_grp$bmi =  as.numeric(as.character(s$exp_grp$"body mass index:ch1"))
# sort(s$exp_grp$bmi)

# 7. ethnicity
# s$exp_grp$ethnicity = as.factor(s$exp_grp$"race/ethnicity:ch1")
# table(s$exp_grp$ethnicity)


