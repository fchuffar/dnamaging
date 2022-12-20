# 1. age
sort(s$exp_grp$age)
s$exp_grp = s$exp_grp[!is.na(s$exp_grp$age), ]

# 2. gender
table(s$exp_grp$gender, useNA="always")

# 3. tissue
table(s$exp_grp$tissue, useNA="always")
s$exp_grp$tissue = "blood"

# 4. tobacco
table(s$exp_grp$smoking, useNA="always")
s$exp_grp$smoking = as.numeric(s$exp_grp$smoking)

# 4.1 tobacco_never_01 tobacco_current_01 tobacco_former_01
s$exp_grp$smoking_never = 0
s$exp_grp$smoking_current = 0
s$exp_grp$smoking_former = 0
for(i in 1:length(s$exp_grp$smoking)){
	if(s$exp_grp$smoking[i] == 0){
		s$exp_grp$smoking_never01[i] = 1
	} else if(s$exp_grp$smoking[i] == 1){
		s$exp_grp$smoking_former01[i] = 1
	} else if(s$exp_grp$smoking[i] == 2){
		s$exp_grp$smoking_current01[i] = 1
	}
}

# 5. disease

# No disease in this data


