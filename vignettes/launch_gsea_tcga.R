data_list = c("CustGSE152710mds", 
"CustGSE152710aml",
"TCGA-LUSC",
"TCGA-LUAD",
"TCGA-KIRC",
"TCGA-BRCA",
"TCGA-COAD",
"TCGA-THCA",
"TCGA-PRAD",
"TCGA-LIHC",
"TCGA-KIRP",
"TCGA-HNSC",
"BRB",
"GSE42861")
 
for (pred_gse in c("GSE147740")) {
	for (data_type in data_list) {
		rmarkdown::render("gsea_tcga.Rmd", output_file = paste0("gsea_",data_type,"_",pred_gse,".html")) 
	}
}

foo = sapply(paste0("info_disease_",data_list,"_GSE147740.rds"), function (f) {
	readRDS(f)
})
foo = t(foo)
foo = data.frame(lapply(data.frame(foo, stringsAsFactors=FALSE), unlist), stringsAsFactors=FALSE)
rownames(foo) = foo$disease

layout(matrix(1:3,1), respect=TRUE)
plot(-log10(foo$pv_up),-log10(foo$pv_dw), xlim = c(0,3.5), ylim = c(0,3.5), col = 0)
text(-log10(foo$pv_up), -log10(foo$pv_dw), foo$disease)
abline(v= -log10(0.05), lty = 3)
abline(h= -log10(0.05), lty = 3)

r2 = foo$r2_mean
names(r2) = foo$disease
r2 = sort(r2, decreasing = TRUE)
barplot(r2, las = 2, ylim = c(0,1))

ind = foo$n_ind
names(ind) = foo$disease
ind = sort(ind, decreasing = TRUE)
barplot(ind, las = 2)
