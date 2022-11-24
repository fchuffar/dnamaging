current_dir = getwd()
setwd(paste0("~/projects/datashare/", gse))
if (!file.exists("GSE136296_eegoguevara.2019.08.23.data.beta.pdet.csv.gz")) {
  cmd = "wget"
  args = "https://ftp.ncbi.nlm.nih.gov/geo/series/GSE136nnn/GSE136296/suppl/GSE136296_eegoguevara.2019.08.23.data.beta.pdet.csv.gz"
  print(paste(cmd, args))
  system2(cmd, args)
}
setwd(current_dir)
if (! exists("mread.tablegz")) {
  mread.tablegz = memoise::memoise(function(matrix_file, ...) {
    read.table(gzfile(matrix_file), ...)
  }, cache = cachem::cache_mem(max_size = 10*1024 * 1024^2))  
}

foo = mread.tablegz(paste0("~/projects/datashare/", gse, "/GSE136296_eegoguevara.2019.08.23.data.beta.pdet.csv.gz"), nrow=100, header=TRUE, row.names=1, sep=",")
head(foo[,1:10])
dim(foo)

foo = mread.tablegz(paste0("~/projects/datashare/", gse, "/GSE136296_eegoguevara.2019.08.23.data.beta.pdet.csv.gz"), header=TRUE, row.names=1, sep=",")

head(foo[,1:10])
dim(foo)

pdf()
layout(matrix(1:2, 1), respect=TRUE)
plot(density(foo[,1], na.rm=TRUE))
plot(density(foo[,2], na.rm=TRUE))
dev.off()
foo = foo[,-grep("detP", colnames(foo), fixed=TRUE)]

head(foo[,1:10])
dim(foo)

tmp_data = foo
colnames(tmp_data)

s$exp_grp$key = paste0("X", gsub("\\*|-", ".", s$exp_grp[,1]), "_beta")
s$exp_grp$key
colnames(tmp_data) %in% s$exp_grp$key
tmp_data = tmp_data[,s$exp_grp$key]
colnames(tmp_data) == s$exp_grp$key
colnames(tmp_data) = rownames(s$exp_grp)
colnames(tmp_data)
tmp_data = as.matrix(tmp_data)


s$data = tmp_data







