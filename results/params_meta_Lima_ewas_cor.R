if (!exists("metabolite")) {metabolite = t(openxlsx::read.xlsx("Data plasma metabolomics Expedition 5300 2019 - Jan2022.xlsx", sheet = 1,rowNames = TRUE))}
if (!exists("markers")) {markers = openxlsx::read.xlsx("global_results_study_exp5300_mergemeth_convoluted.rds_modelcalllm_meth_cmslimapuno+tissue_0.01.xlsx", sheet = 1)}
