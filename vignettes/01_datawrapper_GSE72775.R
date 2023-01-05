s_betatabfile_filename = paste0("~/projects/datashare/", gse, "/study_", gse, "_betatabfile.rds")
if (!file.exists(s_betatabfile_filename)) {
  current_dir = getwd()
  setwd(paste0("~/projects/datashare/", gse))
  postfix = "_datBetaNormalized.csv.gz"
  if (!file.exists(paste0(gse, postfix))) {
    cmd = "wget"
    args = paste0("https://ftp.ncbi.nlm.nih.gov/geo/series/", substr(gse, 1, nchar(gse)-3), "nnn/", gse, "/suppl/", gse, postfix)
    print(paste(cmd, args))
    system2(cmd, args)
  }
  setwd(current_dir)
  if (! exists("mread.tablegz")) {
    mread.tablegz = memoise::memoise(function(matrix_file, ...) {
      read.table(gzfile(matrix_file), ...)
    }, cache = cachem::cache_mem(max_size = 10*1024 * 1024^2))  
  }

  normalized_betas_matrix_file = paste0("~/projects/datashare/", gse, "/", gse, postfix)
  sep=","

  foo = mread.tablegz(normalized_betas_matrix_file, nrow=100, header=TRUE, row.names=1, sep=sep)
  head(foo[,1:10])
  dim(foo)

  foo = mread.tablegz(normalized_betas_matrix_file, header=TRUE, row.names=1, sep=sep)

  head(foo[,1:10])
  dim(foo)

  # pdf()
  # layout(matrix(1:2, 1), respect=TRUE)
  # plot(density(foo[,1], na.rm=TRUE))
  # plot(density(foo[,2], na.rm=TRUE))
  # dev.off()
  # foo = foo[,-grep("Pval", colnames(foo), fixed=TRUE)]

  
  tmp_data = foo
  head(tmp_data[,1:10])
  colnames(tmp_data)

  s$exp_grp$key = substr(as.character(s$exp_grp$title), 53, 10000)
  s$exp_grp$key
  sum(!colnames(tmp_data) %in% s$exp_grp$key)
  sum(!s$exp_grp$key %in% colnames(tmp_data))
  tmp_data = tmp_data[,s$exp_grp$key]
  sum(!colnames(tmp_data) == s$exp_grp$key)
  colnames(tmp_data) = rownames(s$exp_grp)
  colnames(tmp_data)
  tmp_data = as.matrix(tmp_data)


  s_betatabfile = epimedtools::create_study()
  s_betatabfile$data     = tmp_data
  s_betatabfile$exp_grp  = data.frame(samples = colnames(s_betatabfile$data))
  rownames(s_betatabfile$exp_grp) = colnames(s_betatabfile$data)
  s_betatabfile$platform = data.frame(probes = rownames(s_betatabfile$data))
  rownames(s_betatabfile$platform) = rownames(s_betatabfile$data)
  print(paste0("Writing ", s_betatabfile_filename, "..."))
  s_betatabfile$save(s_betatabfile_filename)  
} else {
  s_betatabfile = readRDS(s_betatabfile_filename)  
}


s$data = s_betatabfile$data







