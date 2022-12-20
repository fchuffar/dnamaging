foo = openxlsx::read.xlsx("~/projects/datashare/GSE89353/GSE89353_41467_2018_4540_MOESM4_ESM.xlsx", colNames=TRUE, rowNames=TRUE);
head(foo[,1:6])





# 1. age
foo$age = foo$Age.at.enrollment.in.years
foo = foo[!is.na(foo$age), ]
foo[foo$age == "Newborn",]$age = 0
foo$age = as.numeric(foo$age)

s$exp_grp$age = as.numeric(as.character(s$exp_grp$"age:ch1"))
sort(s$exp_grp$age)
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$age), ]

# 2. gender
s$exp_grp$"Sex:ch1"  
s$exp_grp$gender = as.factor(as.character(s$exp_grp$"Sex:ch1"))  
table(s$exp_grp$gender, useNA="always")
s$exp_grp$gender01 = as.numeric(s$exp_grp$gender)-1

# 3. tissue
table(s$exp_grp$tissue, useNA="always")

# 4. tobacco

# 5. disease


