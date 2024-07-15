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
"GSE42861"
)

pred_list = c(#"GSE147740", 
#"avmps", 
#"combp",
"CustGSE147740rr"
)

for (pred_gse in pred_list) {
	for (data_type in data_list) {
		rmarkdown::render("gsea_tcga.Rmd", output_file = paste0("gsea_",data_type,"_",pred_gse,".html")) 
	}
	rmarkdown::render("resume_gsea.Rmd", output_file = paste0("resume_gsea_",pred_gse,".html")) 
}









