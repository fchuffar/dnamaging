# remove probes on chrX and chrY
head(s$platform[,1:6]) 
table(s$platform[,1]) 
s$platform = s$platform[!s$platform[,1] %in% c("chrX", "chrY"),]
table(s$platform[,1]) 

s$data = s$data[rownames(s$platform),]