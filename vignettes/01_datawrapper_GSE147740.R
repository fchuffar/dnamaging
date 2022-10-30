# get betamatrix_file form a file
current_dir = getwd()
setwd(paste0("~/projects/datashare/", gse))
betamatrix_file = "GSE147740_beta_QN_normalisation.txt.gz"
if (!file.exists(betamatrix_file)) {
  cmd = "wget"
  args = paste0("https://ftp.ncbi.nlm.nih.gov/geo/series/GSE147nnn/GSE147740/suppl/", betamatrix_file)
  print(paste(cmd, args))
  system2(cmd, args)
}
setwd(current_dir)
if (! exists("mread.tablegz")) {
  mread.tablegz = memoise::memoise(function(matrix_file, ...) {
    read.table(gzfile(matrix_file), ...)
  }, cache = cachem::cache_mem(max_size = 10*1024 * 1024^2))  
}
# test if it is readable
foo = mread.tablegz(paste0("~/projects/datashare/", gse, "/", betamatrix_file), nrow=100, header=TRUE, row.names=1)
head(foo[,1:10])
dim(foo)

# read it
foo = mread.tablegz(paste0("~/projects/datashare/", gse, "/", betamatrix_file), header=TRUE, row.names=1, nrow=761652)

head(foo[,1:10])
dim(foo)

tmp_data = foo
colnames(tmp_data)

s$exp_grp$key = paste0("X", s$exp_grp$title)
s$exp_grp = s$exp_grp[s$exp_grp$key %in% colnames(tmp_data),]
sort(s$exp_grp$key[!s$exp_grp$key %in% colnames(tmp_data)])
sort(colnames(tmp_data)[!colnames(tmp_data) %in% s$exp_grp$key])
tmp_data = tmp_data[,s$exp_grp$key]
colnames(tmp_data) == s$exp_grp$key
colnames(tmp_data) = rownames(s$exp_grp)
colnames(tmp_data)
tmp_data = as.matrix(tmp_data)


s$data = tmp_data







