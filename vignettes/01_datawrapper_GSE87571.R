current_dir = getwd()
setwd(paste0("~/projects/datashare/", gse))
if (!file.exists("GSE87571_matrix1of2.txt.gz")) {
  cmd = "wget"
  args = "https://ftp.ncbi.nlm.nih.gov/geo/series/GSE87nnn/GSE87571/suppl/GSE87571_matrix1of2.txt.gz"
  print(paste(cmd, args))
  system2(cmd, args)
}
if (!file.exists("GSE87571_matrix2of2.txt.gz")) {
  cmd = "wget"
  args = "https://ftp.ncbi.nlm.nih.gov/geo/series/GSE87nnn/GSE87571/suppl/GSE87571_matrix2of2.txt.gz"
  print(paste(cmd, args))
  system2(cmd, args)
}
setwd(current_dir)
if (! exists("mread.tablegz")) {
  mread.tablegz = memoise::memoise(function(matrix_file, ...) {
    read.table(gzfile(matrix_file), ...)
  }, cache = cachem::cache_mem(max_size = 10*1024 * 1024^2))  
}
foo = mread.tablegz(paste0("~/projects/datashare/", gse, "/GSE87571_matrix1of2.txt.gz"), nrow=100, header=TRUE, row.names=1)
head(foo[,1:10])

foo = mread.tablegz(paste0("~/projects/datashare/", gse, "/GSE87571_matrix1of2.txt.gz"), header=TRUE, row.names=1)
bar = mread.tablegz(paste0("~/projects/datashare/", gse, "/GSE87571_matrix2of2.txt.gz"), header=TRUE, row.names=1)

dim(foo)
dim(bar)
head(foo[,1:10])
head(bar[,1:10])

pdf()
plot(density(foo[,1], na.rm=TRUE))
dev.off()
pdf()
plot(density(foo[,2], na.rm=TRUE))
dev.off()
foo = foo[,-grep(".", colnames(foo), fixed=TRUE)]
bar = bar[,-grep(".", colnames(bar), fixed=TRUE)]


dim(foo)
dim(bar)
head(foo[,1:10])
head(bar[,1:10])

tmp_data = as.matrix(cbind(foo, bar))


dict = cbind(rownames(s$exp_grp), do.call(rbind, strsplit(s$exp_grp[,1], " "))[,1])
rownames(dict) = dict[,2]

colnames(tmp_data) %in% rownames(dict)
rownames(dict) %in% colnames(tmp_data)
colnames(tmp_data) = dict[colnames(tmp_data),1]

head(tmp_data[,1:10])

s$data = tmp_data