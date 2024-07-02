if (!exists("mreadRDS")) {mreadRDS = memoise::memoise(readRDS, cache=cachem::cache_mem(max_size = 10*1024 * 1024^2)) }
if (!exists("mget_df_preproc")) {mget_df_preproc = memoise::memoise(dnamaging::get_df_preproc, cache = cachem::cache_mem(max_size = 10*1024 * 1024^2))}
if (!exists("mget_full_cpg_matrix")) {mget_full_cpg_matrix = memoise::memoise(dnamaging::get_full_cpg_matrix, cache = cachem::cache_mem(max_size = 10*1024 * 1024^2))}
if (!exists("mmodel_factory_glmnet")) {mmodel_factory_glmnet = memoise::memoise(dnamaging::model_factory_glmnet, cache = cachem::cache_mem(max_size = 10*1024 * 1024^2))}
if (!exists("mcall_glmnet_mod")) {mcall_glmnet_mod = memoise::memoise(dnamaging::call_glmnet_mod)}
if (!exists("mcvaglmnet")) {mcvaglmnet = memoise::memoise(dnamaging::cvaglmnet)}   # Memoise for cvaglmnet
if (!exists("mlimma_lmFit")) {mlimma_lmFit = memoise::memoise(limma::lmFit)}  
if (!exists("mreadtablegz")) {mreadtablegz = memoise::memoise(function(gz_file, ...){read.table(file=gzfile(gz_file), ...)})}  
if (!exists("mepimedtools_monitored_apply")) {mepimedtools_monitored_apply = memoise::memoise(epimedtools::monitored_apply)}  
# if (!exists("mopenxlsx_read.xlsx")) {mopenxlsx_read.xlsx = memoise::memoise(openxlsx::read.xlsx)}





# HERE ALGO FAT_FEAT
get_fat_feats = function(pf, pf_chr_colname, pf_pos_colname, extend_region_dist) {
  table(pf[,pf_chr_colname], useNA="always")
  # pf = pf[pf[,pf_pos_colname]>0,]
  # pf = pf[order(pf[[pf_chr_colname]],pf[[pf_pos_colname]]), ]
  ## index meth probes by chr
  chrs = unique(pf[[pf_chr_colname]])
  chrs_indexed_methpf = lapply(chrs, function(chr) {
      print(chr)
      idx = rownames(pf)[!is.na(pf[[pf_chr_colname]]) & pf[[pf_chr_colname]]==chr]
      ret = pf[idx,]
      return(ret)
  })
  names(chrs_indexed_methpf) = chrs

  fat_feats = lapply(unique(pf[,pf_chr_colname]), function(chr) {
    d = pf[pf[,pf_chr_colname]==chr,c(pf_chr_colname, pf_pos_colname)]
    i = intervals::Intervals(c(d[,2], d[,2]+1), type="Z")
    # enlarge your fat feat
    l = extend_region_dist
    c = intervals::close_intervals( intervals::contract( intervals::reduce(intervals::expand(i, l)), l) )
    dim(c)
    df = data.frame(chr, c[,1], c[,2])
    return(df)
  })
  fat_feats = do.call(rbind, fat_feats)
  dim(fat_feats)
  fat_feats[,4] = paste0(fat_feats[,1], ":", fat_feats[,2], "-", fat_feats[,3])
  fat_feats[,5] = fat_feats[,3] - fat_feats[,2]
  fat_feats[,6] = "+"
  # fat_feats = fat_feats[fat_feats[,5]>1,]
  rownames(fat_feats) = fat_feats[,4]
  colnames(fat_feats)  = c("chr", "start", "end", "id", "score", "strand")
  dim(fat_feats)
  head(fat_feats)

  ## index probes by feat name
  print("# indexing probes by feat name")
  fat_feats_indexed_probes = epimedtools::monitored_apply(fat_feats, 1, function(feat) {
    # feat = fat_feats[3,]
    # print(feat)
    chr = feat[[1]]
    len = as.numeric(feat[[5]])
    meth_platform = chrs_indexed_methpf[[chr]]
    ret = dmprocr_get_probe_names(feat, meth_platform, pf_chr_colname, pf_pos_colname, 0, len)
    # meth_platform[ret,1:3]
    # feat
    return(ret)
  })

  sum(rownames(fat_feats) != names(fat_feats_indexed_probes))

  fat_feats$probes = fat_feats_indexed_probes
  fat_feats$n_probes = sapply(fat_feats_indexed_probes, length) 
  return(fat_feats)
}
if (!exists("mget_fat_feats")) {mget_fat_feats = memoise::memoise(get_fat_feats)}


plot_meth_hm = function(data, 
  main=""                          , 
  rsc=NULL                         , 
  csc=NULL                         , 
  nb_grp_row=4                     ,
  nb_grp_col=4                     , 
  hcmeth_cols="eucl_dist"          , 
  hcmeth_rows="cor"                , 
  normalization=FALSE              , 
  ordering_func=median             , 
  colors=c("cyan", "black", "red") , 
  range_exp=NULL                   ,
  features_type="probes"           ,
  samples_type="patients"          ,
  PCA=FALSE
) {
  # Remove rows with no variation (needed to clustering rows according to cor)
  # data = data[apply(data, 1, function(l) {length(unique(l))})>1, ]
  
  # normalization
  # colnames(data) = s$exp_grp[colnames(data),]$tissue_group_level1
  if (normalization=="zscore_rows" | normalization==TRUE) {
    data = data - apply(data, 1, mean)
    data = data / apply(data, 1, sd)    
  } else if (normalization=="zscore_cols") {
    data = t(data)
    data = data - apply(data, 1, mean)
    data = data / apply(data, 1, sd)    
    data = t(data)
  } else if (normalization=="rank_cols") {
    data = apply(data, 2, rank)
  } else if (normalization=="qqnorm_cols") {
    data = apply(data, 2, function(c) {
      qqnorm(c, plot.it=FALSE)$x
    })
  }
  
  if (! is.null(range_exp)) {
    data[data<min(range_exp)] = min(range_exp)
    data[data>max(range_exp)] = max(range_exp)    
  }

  # clustering samples...
  if (hcmeth_cols != FALSE) {
    tmp_d = t(data)
    if (hcmeth_cols == "cor") {
      # ... based on correlation
      tmp_d = tmp_d[!apply(is.na(tmp_d), 1, any), ]
      d = dist(1 - cor(t(tmp_d), method="pe"))
      hc_col = hclust(d, method="complete")
      Colv = as.dendrogram(hc_col)
    } else if (hcmeth_cols == "ordered") {
      # ... ordered by median
      data = data[,order(apply(tmp_d, 1, ordering_func, na.rm=TRUE), decreasing=TRUE)]
      hc_col = Colv = NULL      
    } else {
      # ... based on eucl. dist.
      d = dist(tmp_d)
      hc_col = hclust(d, method="complete")
      Colv = as.dendrogram(hc_col)
    }
  } else {
    hc_col = Colv = NULL          
  }
  ColSideColors = rep("white", ncol(data))
  names(ColSideColors) = colnames(data)

  # clustering features...
  if (hcmeth_rows != FALSE) {
    tmp_d = data
    if (hcmeth_rows == "eucl_dist") {
      # ... based on eucl. dist.
      d = dist(tmp_d)
      hc_row = hclust(d, method="complete")
      Rowv = as.dendrogram(hc_row)
    } else if (hcmeth_rows == "ordered") {
      # ... ordered by median
      data = data[order(apply(tmp_d, 1, ordering_func, na.rm=TRUE), decreasing=TRUE),]
      hc_row = Rowv = NULL      
    } else {
      # ... bases on correlation
      tmp_d = tmp_d[!apply(is.na(tmp_d), 1, any), ]
      data = tmp_d 
      d = dist(1 - cor(t(tmp_d), method="pe"))
      hc_row = hclust(d, method="complete")
      Rowv = as.dendrogram(hc_row)      
    }
  } else {
    hc_row = Rowv = NULL    
  }
  
  RowSideColors = rep("white", nrow(data))
  names(RowSideColors) = rownames(data)
  
  if (!is.null(csc)) {
    ColSideColors = csc
  }

  if (!is.null(rsc)) {
      RowSideColors = rsc
  }
      
  if (PCA) {
    tmp_d = t(data)
    
    nb_clusters = c()
    scores = c()
    best_score = NULL
    for (nb_cluster in 2:10) {
      for (i in 1:20) {
        k = kmeans(tmp_d, centers=nb_cluster)

        com1 = k$cluster + 10000
        com2 = as.numeric(as.factor(names(k$cluster)))
        names(com1) = names(com2) = paste0("id", 1:length(com1))
        # score = igraph::compare(com1, com2, method="nmi")
        score = -igraph::compare(com1, com2, method="vi")
        score
        
        nb_clusters = c(nb_clusters, nb_cluster)
        scores = c(scores, score)

        if (is.null(best_score)) {
          best_k = k
          best_score = score
          best_nb_cluster = nb_cluster
        } else if (score > best_score) {
          best_k = k
          best_score = score
          best_nb_cluster = nb_cluster
        }
      }
    }
    
    k = best_k
    nb_cluster = best_nb_cluster
    score = best_score

    ColSideColors = palette(RColorBrewer::brewer.pal(n=8, "Dark2"))[k$cluster[colnames(data)]]    
    names(ColSideColors) = colnames(data)    
    
    if (!is.null(csc)) {
      ColSideColors = csc
    }

    if (!is.null(rsc)) {
      RowSideColors = rsc
    }
    
    # PCA on tissues
    pca = prcomp(tmp_d, scale=FALSE)
    PLOT_SAMPLE_LABELS = length(unique(rownames(pca$x))) < nrow(pca$x)
    if (PLOT_SAMPLE_LABELS) {
      sample_labels = t(sapply(unique(rownames(pca$x)), function(t) {        
        idx= which(rownames(pca$x)==t)
        if (length(idx)==1) {
          pca$x[idx,]          
        } else {
          apply(pca$x[idx,], 2, mean)                    
        }
      }))      
    }
    v = pca$sdev * pca$sdev
    p = v / sum(v) * 100
    layout(matrix(1:6,2, byrow=FALSE), respect=TRUE)
    barplot(p)
    i=3
    j=2
    plot(pca$x[,i], pca$x[,j], xlab=paste0("PC", i, "(", signif(p[i], 3), "%)"), ylab=paste0("PC", j, "(", signif(p[j], 3), "%)"), col=ColSideColors[rownames(pca$x)])
    if (PLOT_SAMPLE_LABELS) text(sample_labels[,i], sample_labels[,j], rownames(sample_labels))
    i=1
    j=3
    plot(pca$x[,i], pca$x[,j], xlab=paste0("PC", i, "(", signif(p[i], 3), "%)"), ylab=paste0("PC", j, "(", signif(p[j], 3), "%)"), col=ColSideColors[rownames(pca$x)])
    if (PLOT_SAMPLE_LABELS) text(sample_labels[,i], sample_labels[,j], rownames(sample_labels))
    i=1
    j=2
    plot(pca$x[,i], pca$x[,j], xlab=paste0("PC", i, "(", signif(p[i], 3), "%)"), ylab=paste0("PC", j, "(", signif(p[j], 3), "%)"), col=ColSideColors[rownames(pca$x)])
    if (PLOT_SAMPLE_LABELS) text(sample_labels[,i], sample_labels[,j], rownames(sample_labels))
    i=4
    j=5
    plot(pca$x[,i], pca$x[,j], xlab=paste0("PC", i, "(", signif(p[i], 3), "%)"), ylab=paste0("PC", j, "(", signif(p[j], 3), "%)"), col=ColSideColors[rownames(pca$x)])
    if (PLOT_SAMPLE_LABELS) text(sample_labels[,i], sample_labels[,j], rownames(sample_labels))

    plot(jitter(nb_clusters), scores)
    points(nb_cluster, score, col=2)

    # stop("EFN")    
  # } else {
  #   ColSideColors = rep("white", ncol(data))
  #   names(RowSideColors) = colnames(data)
  #   hc_col = Colv = NULL


  ColSideColors = palette(RColorBrewer::brewer.pal(n=length(unique(colnames(data))), "Dark2"))[as.factor(colnames(data))]    
  names(ColSideColors) = colnames(data)    

  }

  # stop("EFN")







  # if (is.null(rsc)) {
  #   grps = list()
  #   ct = cutree(hc_row, nb_grp_row)
  #   for (i in 1:nb_grp_row) {
  #     grps[[palette()[i]]] = names(ct)[ct==i]
  #   }
  #   # print(grps)
  #   RowSideColors = palette()[ct[rownames(data)]]
  #   names(RowSideColors) = rownames(data)
  # } else {
  #   RowSideColors = rep("white", nrow(data))
  #   names(RowSideColors) = rownames(data)
  #   idx = intersect(rownames(data), names(rsc))
  #   RowSideColors[idx] = rsc[idx]
  # }
  


  if (!is.null(Colv) & !is.null(Rowv)) {
    dendrogram="both"
  } else if (!is.null(Rowv)) {
    dendrogram="row"
  } else if (!is.null(Colv)) {
    dendrogram="col"
  } else {
    dendrogram="none"
  }

  # colors = c("green", "black", "red")
  # colors = c("blue", "yellow", "red")
  # colors = rev(RColorBrewer::brewer.pal(n=11, "RdYlBu"))
  cols = colorRampPalette(colors)(30)
  tracecol="green"
  foo = gplots::heatmap.2(data, Rowv=Rowv, Colv=Colv, dendrogram=dendrogram, trace="none", col=cols, tracecol=tracecol, main=paste0(main, " (", nrow(data), " ", features_type, " x ", ncol(data), " ", samples_type, ")"), mar=c(10,5), useRaster=TRUE, RowSideColors=RowSideColors, ColSideColors=ColSideColors, cex.axis=0.5)  
  return(list(rsc=RowSideColors, csc=ColSideColors, hc_row=hc_row, hc_col=hc_col))  
}







dmprocr_get_probe_names = function (gene, pf_meth, pf_chr_colname = "Chromosome", pf_pos_colname = "Start", 
    up_str = 5000, dwn_str = 5000) 
{
    if (substr(gene[[1]], 1, 3) != "chr") {
        gene[[1]] = paste0("chr", gene[[1]])
    }
    chr = gene[[1]]
    strand = gene[[6]]
    gene_name = gene[[4]]
    beg = as.numeric(gene[[2]])
    end = as.numeric(gene[[3]])
    if (nrow(pf_meth) == 0) {
        warning(paste0("No probes for gene ", gene[[4]], "(", 
            gene[[5]], ")."))
        return(NULL)
    }
    if (substr(pf_meth[1, pf_chr_colname], 1, 3) != "chr") {
        pf_meth[, pf_chr_colname] = paste0("chr", pf_meth[, pf_chr_colname])
    }
    if (strand == "-") {
        off_set_beg = dwn_str
        off_set_end = up_str
        tss = end
    }
    else {
        off_set_beg = up_str
        off_set_end = dwn_str
        tss = beg
    }
    probe_idx = rownames(pf_meth)[!is.na(pf_meth[[pf_pos_colname]]) & 
        !is.na(pf_meth[[pf_chr_colname]]) & pf_meth[[pf_chr_colname]] == 
        chr & pf_meth[[pf_pos_colname]] >= tss - up_str & pf_meth[[pf_pos_colname]] < 
        tss + dwn_str]
    if (length(probe_idx) == 0) {
        warning(paste0("No probes for gene ", gene[[4]], "(", 
            gene[[5]], ")."))
        return(NULL)
    }
    else {
        return(probe_idx)
    }
}

  
  
#ewas_orig = ewas = mewas_func2(d=d, e=e, USE_PARAPPLY=USE_PARAPPLY, model_formula=model_formula, model_func_name=model_func_name, nb_fact_of_interest=nb_fact_of_interest)

ewas_func2 = function(d, e, USE_PARAPPLY, model_formula, nb_fact_of_interest=1, model_func_name="modelcalllm") {
  model_func = get(model_func_name)
  y_name = rownames(attr(stats::terms(as.formula(model_formula)), "factor"))[1]
  x_values = e[colnames(d),c(rownames(attr(stats::terms(as.formula(model_formula)), "factor"))[-1], colnames(e)[1])]
  head(x_values)

  set.seed(1)
  tmp_d = x_values
  tmp_d[[y_name]] = rnorm(nrow(tmp_d))
  fake_m = lm(model_formula, tmp_d)
  expected_nb_coef = length(fake_m$coefficients)
  expected_nb_na = sum(is.na(fake_m$coefficients))

  if (USE_PARAPPLY) {
    print("ewas using parallel::parApply...")
    if (!exists("cl")) {
      nb_cores = parallel::detectCores()
      cl <<- parallel::makeCluster(nb_cores,  type="FORK")
      # parallel::stopCluster(cl)
    }
    ewas = parallel::parApply(cl, d, 1, model_func, x_values=x_values, model_formula=model_formula, nb_fact_of_interest=nb_fact_of_interest, expected_nb_coef=expected_nb_coef, expected_nb_na=expected_nb_na)
  } else {
    print("ewas using epimedtools::monitored_apply")
    ewas = epimedtools::monitored_apply(d, 1, model_func, x_values=x_values, model_formula=model_formula, nb_fact_of_interest=nb_fact_of_interest, expected_nb_coef=expected_nb_coef, expected_nb_na=expected_nb_na)
  }
  print("done")
  ewas = t(ewas)
  # head(ewas)
  # dim(ewas)
  return(ewas)
}
if (!exists("mewas_func2")) mewas_func2 = memoise::memoise(ewas_func2)
  
  
modelcalllm = function(meth, x_values, model_formula, nb_fact_of_interest, expected_nb_coef, expected_nb_na=0) {
  # meth = d["cg07164639",]
  # meth = d[140340,]
  # meth = d[1,]


  # model
  options(contrasts=c("contr.sum", "contr.poly"))
  # options(contrasts=c("contr.treatment", "contr.poly"))

  y_name = rownames(attr(stats::terms(as.formula(model_formula)), "factor"))[1]
  tmp_d = x_values
  tmp_d[[y_name]] = meth
  head(tmp_d)
  m = try(lm(model_formula, tmp_d))
  if (attributes(m)$class == "try-error") {
    # warning(paste0("Region ", mdata$region_id, " contains probe ", probe, "that through error model. Have to fix it! "))
    set.seed(1)
    tmp_d[[y_name]] = rnorm(nrow(tmp_d))
    m = lm(model_formula, tmp_d)
    a = anova(m)
    m$coefficients[] = NA
    m$residuals[] = NA
    fstat = summary(m)$fstatistic
  } else if (length(m$coefficients) != expected_nb_coef | sum(is.na(m$coefficients)) > expected_nb_na) {
    # warning(paste0("Region ", mdata$region_id, " contains probe ", probe, "that through error model. Have to fix it! "))
    set.seed(1)
    tmp_d[[y_name]] = rnorm(nrow(tmp_d))
    m = lm(model_formula, tmp_d)
    a = anova(m)
    summary(m)$fstatistic
    m$coefficients[] = NA
    m$residuals[] = NA
    fstat = summary(m)$fstatistic
  } else {
    a = anova(m)
    fs1 = sum(a[1:nb_fact_of_interest,2]) / sum(a[1:nb_fact_of_interest,1]) / a[nrow(a),3]
    fs2 = sum(a[1:nb_fact_of_interest,1])
    # fs1 = sum(a[1,2]) / sum(a[1,1]) / a[nrow(a),3]
    # fs2 = sum(a[1,1])
    fs3 = a[nrow(a),1]
    fstat = c(fs1, fs2, fs3)
  }

  # pval for ewas
  if (is.null(fstat)) {
    # warning(paste0("Region ", mdata$region_id, " contains probe ", probe, "that through NULL fstat. Have to fix it! "))
    m$coefficients[] = NA
    lpval_fisher = NA
  } else {
    lpval_fisher = pf(fstat[[1]], fstat[[2]], fstat[[3]], lower.tail=FALSE, log.p=TRUE)/-log(10)
  }

  # ret = c(lpval_fisher=lpval_fisher, r2=summary(m)$r.squared,  nb_notna = sum(!is.na(meth)), fstat_1=fstat[[1]], fstat_2=fstat[[2]], fstat_3=fstat[[3]]) #m$coefficients[-1])
  # return(ret)
  lpv = lpval_fisher
  if (is.factor(x_values[,1])) {
    beta = -2*m$coefficients[[2]]
  } else if (is.numeric(x_values[,1])) {
    beta = m$coefficients[[2]]
  } else {
    stop("Phenotype in not a factor nor numeric (in model_call_lm).")
  }
  # coef = c(unlist(m$coefficients[2:length(levels(pheno))]))
  # coef = c(coef, pheno=-sum(coef))
  ret = c(beta=beta, lpv=lpv, coef=unlist(m$coefficients), pv=a[1:(nrow(a)-1),5])
  ret
  return(ret)
}

plot_res = function(
  roi,
  idx_probes,
  legendplace="topright",
  combp_res_probes,
  ewas,
  study_filename="",
  pheno_key,
  ADD_LEGEND=FALSE,
  rename_results=I,
  pheno_key2,
  LAYOUT=TRUE
) {

  if (!missing(study_filename)) {
    s = mreadRDS(study_filename)
  }
  d = s$data
  e = s$exp_grp

  factors = rownames(attr(stats::terms(as.formula(model_formula)), "factor"))
  
  # convert character as factors
  for (f in factors[-1]) {
    if (is.character(e[[f]])) {
      print(paste0("Converting ", f, " as factor."))
      e[[f]] = as.factor(e[[f]])
    }
  }

  # dealing with pheno_key2
  if (missing(pheno_key2)) {
  #   pheno_key2 = "hb"
  # }
  # if (!pheno_key2 %in% colnames(e)) {
    if (length(factors)>=3) {
      if (is.factor(e[[factors[3]]])) {
        pheno_key2 = factors[3]
      } else {
        pheno_key2 = pheno_key      
      }
    } else {
      pheno_key2 = pheno_key      
    }
  }
  e[is.na(e[[pheno_key]]), pheno_key2] = NA

  if (missing(idx_probes)) {
    idx_probes = ewas[as.character(ewas[,1])==as.character(roi[[1]]) & ewas[,2]>=roi[[2]] & ewas[,2]<=roi[[3]],4]
  }

  # if (missing(pheno_key2)) {
  #   pheno_key2 = pheno_key
  # }

  idx_probes = intersect(idx_probes, rownames(d))
  d = d[idx_probes,]
  if ("tissue" %in% factors) {
    idx_sample = rownames(e)[order(e[["tissue"]], e[[pheno_key2]], e[[pheno_key]])]
  } else if (is.factor(e[[pheno_key2]])) {
    idx_sample = rownames(e)[order(is.na(e[[pheno_key]]), e[[pheno_key2]], e[[pheno_key]])]
    e[idx_sample, c(pheno_key, pheno_key2)]
  } else {
    idx_sample = rownames(e)[order(e[[pheno_key]], e[[pheno_key2]])]
  }


  if (length(idx_probes) > 1) {
    # layout(matrix(c(1, 2, 2, 2, 2), 1))
    # pdf()
    if (LAYOUT) {
      layout(matrix(c(
        c(1,2,2,2,2,4,4,4),
        c(1,2,2,2,2,3,3,3),
        c(1,2,2,2,2,3,3,3),
        c(1,2,2,2,2,3,3,3)
        ), 4, byrow=TRUE), respect=TRUE)
    }
    # PHENO
    par(mar=c(5.7, 4.1, 4.1, 0))
    if (is.factor(e[,pheno_key])) {
      col=(1:length(levels(e[,pheno_key])))[as.numeric(e[idx_sample,pheno_key])]
      x = as.numeric(e[idx_sample,pheno_key]) 
      xlim=c(.5, length(levels(e[,pheno_key]))+.5)
      xlab=""
    } else {
      col=1
      x = e[idx_sample,pheno_key]       
      xlim = range(x)
      xlab=rename_results(pheno_key)
    }
    plot(
      x, 1:length(idx_sample),
      xlab=xlab, ylab=rename_results(pheno_key2),
      yaxt="n", xaxt="n", yaxs = "i", main="", xlim=xlim,
      col=col,
      pch=16
    )
    if (is.factor(e[[pheno_key2]])) {
      abline(h=cumsum(table(e[[pheno_key2]], useNA="ifany")), lty=2, col="grey")
      axis(2, at=cumsum(table(e[[pheno_key2]])) - (table(e[[pheno_key2]])/2), levels(e[[pheno_key2]]))
    }
    if (is.factor(e[[pheno_key]])) {
      axis(1, at=1:length(levels(e[[pheno_key]])), levels(e[[pheno_key]]), las=2)
    } else {
      axis(1)
    }
    # dev.off()

    # METH
    colors = c("cyan", "black", "red")
    cols = colorRampPalette(colors)(1000)
    breaks = seq(0, 1, length.out = length(cols) + 1)
    main = paste0(rename_results(study_filename), " ", roi[[1]], ":", roi[[2]], "-", roi[[3]])
    par(mar=c(5.7, 0, 4.1,0))
    image(d[idx_probes,idx_sample], col=cols, breaks=breaks, xaxt="n", yaxt="n", main=main)
    axis(1, (1:nrow(d[idx_probes,idx_sample]) - 1)/(nrow(d[idx_probes,idx_sample]) - 1), rownames(d[idx_probes,idx_sample]), las = 2)

    # DATAFRAME
    df = lapply(idx_sample, function(i){
      df = lapply(idx_probes, function(j){
        # if (is.null(confounder)) {
          list(meth=d[j,i], probes=as.character(j), pheno=e[i,pheno_key])
        # } else {
        #   list(meth=d[j,i], probes=as.character(j), pheno=e[i,pheno_key], confounder=e[i,confounder])
        # }
      })
      df = do.call(rbind, df)
      df
    })
    df = do.call(rbind, df)
    df = data.frame(lapply(data.frame(df, stringsAsFactors=FALSE), unlist), stringsAsFactors=FALSE)
    # df
    df$probes = factor(df$probes, levels=idx_probes)
    if (is.factor(df$pheno)) {
      df$pheno = factor(df$pheno, levels=levels(df$pheno)[levels(df$pheno)%in%unique(as.character(df$pheno))])
    }

    # # effect
    # options(contrasts=c("contr.treatment", "contr.poly"))
    # if (is.null(confounder)) {
    #   m = lm(meth~pheno+probes, df)
    # } else {
    #   m = lm(meth~pheno+probes+confounder, df)
    # }
    # m$coefficients
    # main = paste0(levels(df$pheno)[2], " effect = " ,   signif(m$coefficients[[2]],3))
    main = ""
    
    

    # BOXPLOT
    par(mar=c(5.1, 4.1, 4.1, 2.1))
    if (is.factor(e[[pheno_key]])) {
      par(mar=c(5.7, 4.1, 0, 0))
      # if (is.null(confounder)) {
        boxplot(meth~pheno+probes, df, las=2, col=1:length(unique(na.omit(df$pheno))), ylim=c(0,1),
          ylab="methylation",
          #, yaxt="n",
          cex.axis=0.5
        )
        # axis(4)
        # mtext("methylation", side=4, line=3)

      # } else {
        # boxplot(meth~pheno+confounder+probes, df, las=2, col=1:length(unique(na.omit(df$pheno))), ylim=c(0,1), main=main)
      # }
    } else {
      plot(0,type='n',axes=FALSE,ann=FALSE)
    }

    # EWAS
    if (!missing(ewas)) {
      # combp
      if (!missing(combp_res_probes)) {
        idx_probes = ewas[as.character(ewas[,1])==as.character(roi[[1]]) & ewas[,2]>=roi[[2]] & ewas[,2]<=roi[[3]],4]
        sub_ewas = ewas[ewas[,4]%in%idx_probes, ]
        sub_ewas = sub_ewas[!duplicated(paste0(sub_ewas[,1], ":", sub_ewas[,2])), ]
        rownames(sub_ewas) = paste0(sub_ewas[,1], ":", sub_ewas[,2])
        head(sub_ewas)
        dim(sub_ewas)
        pval_ewas = combp_res_probes[paste0(combp_res_probes[,1], ":", combp_res_probes[,2]) %in% rownames(sub_ewas),4]
        pval_slk =  combp_res_probes[paste0(combp_res_probes[,1], ":", combp_res_probes[,2]) %in% rownames(sub_ewas),5]
        qval_slk =  combp_res_probes[paste0(combp_res_probes[,1], ":", combp_res_probes[,2]) %in% rownames(sub_ewas),6]
        # pval_ewas[pval_ewas==0] = 10^-45
        # pval_slk [pval_slk ==0] = 10^-45
        # qval_slk [qval_slk ==0] = 10^-45
      } else {
        pval_ewas = 10^-ewas[rownames(ewas) %in% idx_probes, 2]
        # pval_ewas[pval_ewas==0] = 10^-45
        qval_slk = pval_slk = pval_ewas
      }

      # layout(matrix(c(2,1,1,1,1), 1))
      par(mar=c(5.1, 2.1, 0, 0))
      par(mar=c(0, 4.1, 4.1, 0))
      x = 1:length(-log10(pval_ewas))
      ylim=c(0, min(max(-log10(pval_slk), -log10(pval_ewas)), 100))
      print(ylim)
      plot(x, -log10(pval_ewas), col="red", xaxt="n",
        xlab="", ylab="-log10(pv)",
        # yaxt="n",
        # main=paste0("meth~", gene),
        ylim=ylim,
        type="l", lty=3
      )
      # axis(4)
      # mtext("-log10(pv)", side=4, line=3)
      axis(3, at=x, labels=names(pval_ewas),las=2, cex.axis = 0.5)
      lines(-log10(pval_slk), col="blue"  , type="l", lty=3)
      lines(-log10(qval_slk), col="purple", type="l", lty=3)

      # # add Student pvals
      # if (length(gene_symbols)>1) {
      #   for (g in gene_symbols) {
      #     lines(sub_ewas[,paste0("lpval_student_", g)], col=pals::glasbey()[which(gene_symbols%in%g)], type="l")
      #   }
      # }
      # # add DMR
      # abline(h=-log10(as.numeric(pval_tresh)), col="black", lwd=1, lty=2)
      # for (i in 1:nrow(combp_res_region)) {
      #   x1 = c(which(sub_ewas[,2] == combp_res_region[i,2]), which(sub_ewas[,3] == combp_res_region[i,3]))
      #   y1 = c(-log10(as.numeric(pval_tresh)), -log10(as.numeric(pval_tresh)))
      #   lines(x1,y1, type="o", col="green", pch=18, lwd=4)
      # }
      # add legend

      if (ADD_LEGEND) {
        col = c("red","blue", "purple", "black", "green")
        lwd = c(1,1,1,1,4)
        lty = c(3,3,3,2,1)
        legend=c("pval Fisher", "pval SLK", "qval SLK",  "threshold", "DMR")
        legend(legendplace, legend=legend, col=col, lwd=lwd, lty=lty)
        par(mar=c(0,0,0,0), mgp=c(3, 1, 0), las=0)
        plot.new()
        par(mar=c(0,0,0,0), mgp=c(3, 1, 0), las=0)
      }
    } else {
      plot(0,type='n',axes=FALSE,ann=FALSE)
    }


    # return(mdata)
  } else {
    par(mar=c(0, 0, 0, 0), mgp=c(3, 1, 0), las=0)
    plot(0,type='n',axes=FALSE,ann=FALSE)
    plot(0,type='n',axes=FALSE,ann=FALSE)
    plot(0,type='n',axes=FALSE,ann=FALSE)
    plot(0,type='n',axes=FALSE,ann=FALSE)
  }
  par(mar=c(5.1, 4.1, 4.1, 2.1), mgp=c(3, 1, 0), las=0)
}




build_dmr_candidates = function(pf, pf_chr_colname=1, pf_pos_colname=2, extend_region_dist=1000) {
  pf = pf[pf[,pf_pos_colname]>0,]
  pf = pf[order(pf[[pf_chr_colname]],pf[[pf_pos_colname]]), ]
  ## index meth probes by chr
  chrs = unique(pf[[pf_chr_colname]])
  chrs_indexed_methpf = lapply(chrs, function(chr) {
    print(chr)
    idx = rownames(pf)[!is.na(pf[[pf_chr_colname]]) & pf[[pf_chr_colname]]==chr]
    ret = pf[idx,]
    return(ret)
  })
  names(chrs_indexed_methpf) = chrs

  fat_feat = lapply(unique(pf[,pf_chr_colname]), function(chr) {
    d = pf[pf[,pf_chr_colname]==chr,c(pf_chr_colname, pf_pos_colname)]
    i = intervals::Intervals(c(d[,2], d[,2]+1), type="Z")
    # enlarge your fat feat
    l = extend_region_dist
    c = intervals::close_intervals( intervals::contract( intervals::reduce(intervals::expand(i, l)), l) )
    dim(c)
    df = data.frame(chr, c[,1], c[,2])
    return(df)
  })
  fat_feat = do.call(rbind, fat_feat)
  dim(fat_feat)
  fat_feat[,4] = paste0(fat_feat[,1], ":", fat_feat[,2], "-", fat_feat[,3])
  fat_feat[,5] = fat_feat[,3] - fat_feat[,2]
  fat_feat[,6] = "+"
  fat_feat = fat_feat[fat_feat[,5]>1,]
  rownames(fat_feat) = fat_feat[,4]
  colnames(fat_feat)  = c("chr", "start", "end", "id", "score", "strand")
  dim(fat_feat)
  head(fat_feat)

  ## index probes by feat name
  print("# indexing probes by feat name")
  feat_indexed_probes = epimedtools::monitored_apply(fat_feat, 1, function(feat) {
    # feat = fat_feat[3,]
    # print(feat)
    chr = feat[[1]]
    len = as.numeric(feat[[5]])
    meth_platform = chrs_indexed_methpf[[chr]]
    ret = dmprocr_get_probe_names(feat, meth_platform, pf_chr_colname, pf_pos_colname, 0, len)
    # meth_platform[ret,1:3]
    # feat
    return(ret)
  })

  nb_probes = sapply(feat_indexed_probes, length)
  fat_feat$score = nb_probes[rownames(fat_feat)]
  return(feat_indexed_probes)
}


if (!exists("mbuild_dmr_candidates")) {mbuild_dmr_candidates = memoise::memoise(build_dmr_candidates)}


