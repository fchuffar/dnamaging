source("common.R")

avmps = openxlsx::read.xlsx("avmps_probes.xlsx",cols = 4)
avmps = avmps[[1]]

predimeth = read.table(paste0("predimeth_probes_GSE147740_10.bed"))
predimeth = predimeth$V4

fdr_combp = read.table("dmr_GSE147740_modelcalllm_meth~age_1e-30.fdr.bed.gz")
sign_combp = fdr_combp[fdr_combp$V6 <= 1e-30,]
sign_combp = sign_combp[,1:3]

pf = sign_combp
pf_chr_colname = 1
pf_pos_colname = 2
extend_region_dist = 1000/2 - 1
target = mget_fat_feats(pf, pf_chr_colname, pf_pos_colname, extend_region_dist)

target_combp = target[target$n_probes > 1,]
combp_probes = unlist(target_combp$probes)
combp_probes_bed = sign_combp[combp_probes,]

combp_probes_bed$key = paste0(combp_probes_bed$V1,":",combp_probes_bed$V2)

library(IlluminaHumanMethylationEPICanno.ilm10b2.hg19)
pfEPIC = data.frame(getAnnotation(IlluminaHumanMethylationEPICanno.ilm10b2.hg19))
pfEPIC$key = paste0(pfEPIC$chr,":",pfEPIC$pos)

combp_probes = pfEPIC$Name[pfEPIC$key %in% combp_probes_bed$key]
write.table(combp_probes, "combp_probes_GSE147740_10e-30.txt")

print(paste0("Predimeth probes in avmps paper probes : ", sum(predimeth %in% avmps),"/",length(predimeth),"(",sum(predimeth %in% avmps) / length(predimeth) * 100," %)"))

print(paste0("Predimeth probes in combp 10^-30 : ", sum(predimeth %in% combp_probes),"/",length(predimeth),"(",sum(predimeth %in% combp_probes) / length(predimeth) * 100," %)"))

print(paste0("combp 10^-30 probes in avmps paper probes : ", sum(combp_probes %in% avmps),"/",length(combp_probes),"(",sum(combp_probes %in% avmps) / length(combp_probes) * 100," %)"))




