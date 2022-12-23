exp_grp_paper = openxlsx::read.xlsx("~/projects/datashare/GSE89353/GSE89353_41467_2018_4540_MOESM4_ESM.xlsx", rowNames=TRUE)
head(exp_grp_paper[,1:6])
dim(exp_grp_paper)


# head(s$exp_grp)
sum(!s$exp_grp$"individual:ch1" %in% rownames(exp_grp_paper))
s$exp_grp$"individual:ch1"[!s$exp_grp$"individual:ch1" %in% rownames(exp_grp_paper)]
head(s$exp_grp[!s$exp_grp$"individual:ch1" %in% rownames(exp_grp_paper),])
s$exp_grp = s$exp_grp[s$exp_grp$"individual:ch1" %in% rownames(exp_grp_paper),]
dim(s$exp_grp)

exp_grp_paper$gsm = NA
exp_grp_paper[s$exp_grp$"individual:ch1",]$gsm = rownames(s$exp_grp)
exp_grp_paper$gsm
rownames(exp_grp_paper) = exp_grp_paper$gsm
dim(s$exp_grp)
dim(exp_grp_paper)
s$exp_grp = cbind(s$exp_grp, exp_grp_paper[rownames(s$exp_grp),])


# 1. age
s$exp_grp$"Age.at.enrollment.in.years"
s$exp_grp[s$exp_grp$"Age.at.enrollment.in.years" %in% "Newborn",]$"Age.at.enrollment.in.years" = "0"
s$exp_grp$"Age.at.enrollment.in.years"
s$exp_grp$age = as.numeric(as.character(s$exp_grp$"Age.at.enrollment.in.years"))
sort(s$exp_grp$age)
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$age), ]

# 2. gender
s$exp_grp$"gender:ch1"
s$exp_grp$gender = as.factor(s$exp_grp$"gender:ch1")
table(s$exp_grp$gender, useNA="always")
s$exp_grp$gender01 = as.numeric(s$exp_grp$gender)-1
table(s$exp_grp$gender01, useNA="always")

# 3. tissue
s$exp_grp$"tissue:ch1"
s$exp_grp$tissue = as.factor(s$exp_grp$"tissue:ch1")
table(s$exp_grp$tissue, useNA="always")

# 4. tobacco

# 5. disease


