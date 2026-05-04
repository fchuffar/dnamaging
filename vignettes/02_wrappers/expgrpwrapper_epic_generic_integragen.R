file = list.files(
  path = paste0("datashare/", gse, "/raw/"),
  pattern = "Samples_Table\\.txt$",
  recursive = TRUE,
  full.names = TRUE
)

df = read.table(file, sep="\t", header=TRUE)

s$exp_grp = df

rownames(s$exp_grp) = paste0("X", s$exp_grp$Sentrix.Barcode, "_", s$exp_grp$Sample.Section)

head(s$exp_grp)
dim(s$exp_grp)

