recap_it_DMR = function(newas=2000, neighb=1000, run=0, pval=1e-30, study_filename) { 
	
	foo = mreadRDS(paste0("~/projects/datashare/GSE42861/", study_filename))
	platform = foo$platform
	
	foo = read.table("~/projects/datashare/genomes/Homo_sapiens/UCSC/hg19/hg19.chrom.sizes")[-1,]
	xshift = c(0,cumsum(as.numeric(foo[,2]))[-nrow(foo)]) ; names(xshift) = foo[,1] 


	probes_it = list(probes = c(), it = c(), chr = c(), pos = c(), pos_tot = c())
	
	for (i in 0:run) { 
    rds_model_file = paste0("models_r",i,"_ewas",newas, "_nn", neighb, "_GSE42861.rds")
    print(rds_model_file)
		modele = readRDS(rds_model_file)
		modele = modele[[2]]$coeff$probes
		probes_it$probes = c(probes_it$probes,modele)
		probes_it$it = c(probes_it$it, rep(i, length(modele)))
		probes_it$chr = c(probes_it$chr,platform[modele,"chr"])
		probes_it$pos = c(probes_it$pos,platform[modele,"pos"])
	}
	probes_it$pos_tot = c(probes_it$pos_tot, probes_it$pos + xshift[probes_it$chr])
	
	saveRDS(probes_it, paste0("meth_it_run",run,"_ewas", newas, "_nn", neighb, "_GSE42861.rds"))

  ewascombpr_global_results_file = paste0("~/projects/ewascombpr/vignettes/global_results_study_GSE42861_modelcalllm_meth~age_ewas", newas, "_nn", neighb, ".rds_modelcalllm_meth~age+gender_", pval, ".xlsx")
  print(ewascombpr_global_results_file)
	tab_DMR = openxlsx::read.xlsx(ewascombpr_global_results_file)
	tab_DMR = as.data.frame(tab_DMR)
	
	tab_comp = tab_DMR[,c("X.chrom","start","end","len","n_probes","probes")]
	
	# Probes de la méthode itérative présente dans chaque DMR
	
	probes_it_in_DMR = c()
	nb_probes_it_in_DMR = c()
	for (i in 1:nrow(tab_DMR)) {
		tmp_probes_it_in_DMR = probes_it$probes[probes_it$pos_tot <= tab_comp[i,"end"] + xshift[tab_comp[i,"X.chrom"]] & probes_it$pos_tot >= tab_comp[i,"start"] + xshift[tab_comp[i,"X.chrom"]]]
		tmp_nb_probes_it_in_DMR = length(tmp_probes_it_in_DMR)
		tmp_probes_it_in_DMR = paste(tmp_probes_it_in_DMR, collapse = ";")
		probes_it_in_DMR = c(probes_it_in_DMR, tmp_probes_it_in_DMR)
		nb_probes_it_in_DMR = c(nb_probes_it_in_DMR, tmp_nb_probes_it_in_DMR)
	}
	tab_comp = cbind.data.frame(tab_comp,probes_it_in_DMR,nb_probes_it_in_DMR)
	
	# Probes des DMR qui ne sont pas dans la méthode itérative 
	
	probes_DMR_not_in_it = c()
	for (i in 1:nrow(tab_comp)) {
		DMR_probes = strsplit(tab_comp[i,"probes"], split = ";")
		it_probes = strsplit(tab_comp[i,"probes_it_in_DMR"], split = ";")
		tmp_DMR_not_in_it = DMR_probes[!(DMR_probes %in% it_probes)]
		tmp_DMR_not_in_it = paste(unlist(tmp_DMR_not_in_it), collapse = ";")
		probes_DMR_not_in_it = c(probes_DMR_not_in_it,tmp_DMR_not_in_it) 
	}
	tab_comp = cbind.data.frame(tab_comp,probes_DMR_not_in_it)
	
	# pourcentage de probes de la méthode it présente et non presente dans chaque DMR
	
	pct_probes_DMR_in_it = tab_comp[,"nb_probes_it_in_DMR"] / tab_comp[,"n_probes"] *100
	pct_probes_DMR_not_in_it = 100 - pct_probes_DMR_in_it
	tab_comp = cbind.data.frame(tab_comp,pct_probes_DMR_in_it, pct_probes_DMR_not_in_it)
	
	WriteXLS::WriteXLS(tab_comp, paste0("tab_comp_run",run,"_ewas", newas, "_nn", neighb, "_pval",pval,"_GSE42861.xlsx"), verbose=TRUE, row.names=FALSE, AdjWidth=TRUE, BoldHeaderRow=TRUE, FreezeCol=1) 
	
	# Recap global 
	
    probes_DMR = unlist(strsplit(tab_comp[,"probes"], split = ";"))
	probes_it_in_DMR = unlist(strsplit(tab_comp[,"probes_it_in_DMR"],split=";"))
	probes_it_not_in_DMR = probes_it$probes[!(probes_it$probes %in% probes_it_in_DMR)]
	nb_probes_it_in_DMR = length(probes_it_in_DMR)
	nb_probes_it_not_in_DMR = length(probes_it_not_in_DMR)
	pct_nb_probes_it_not_in_DMR = nb_probes_it_not_in_DMR / length(probes_it$probes) *100
	pct_gl_it_in_DMR = length(probes_it_in_DMR) / length(probes_DMR) *100
	pct_mean_it_in_DMR = mean(tab_comp[,"pct_probes_DMR_in_it"])
	
	stats_pres_it = data.frame(nb_probes_it_not_in_DMR, nb_probes_it_in_DMR)
	saveRDS(stats_pres_it, paste0("stats_pres_it_run",run,"_ewas", newas, "_nn", neighb, "_pval", pval,"_GSE42861.rds"))
	
	# Annotations probes not in DMR 
	
#	annot_it_not_in_DMR = data.frame(probes = probes_it_not_in_DMR,chr = probes_it$chr[!(probes_it$probes %in% probes_it_in_DMR)],it = probes_it$it[!(probes_it$probes %in% probes_it_in_DMR)],pos = probes_it$pos[!(probes_it$probes %in% probes_it_in_DMR)],pos_tot = probes_it$pos_tot[!(probes_it$probes %in% probes_it_in_DMR)])
#	WriteXLS::WriteXLS(annot_it_not_in_DMR, paste0("annot_it_not_in_DMR_run",run,"_pval",pval,".xlsx"), verbose=TRUE, row.names=FALSE, AdjWidth=TRUE, BoldHeaderRow=TRUE, FreezeRow=1, FreezeCol=1)
	
	print(paste0("run ", run, " terminated"))
	
	return()
	
}

