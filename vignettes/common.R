if (!exists("mreadRDS")) {mreadRDS = memoise::memoise(readRDS, cache=cachem::cache_mem(max_size = 10*1024 * 1024^2)) }
if (!exists("mget_df_preproc")) {mget_df_preproc = memoise::memoise(dnamaging::get_df_preproc, cache = cachem::cache_mem(max_size = 10*1024 * 1024^2))}
if (!exists("mget_full_cpg_matrix")) {mget_full_cpg_matrix = memoise::memoise(dnamaging::get_full_cpg_matrix, cache = cachem::cache_mem(max_size = 10*1024 * 1024^2))}
if (!exists("mmodel_factory_glmnet")) {mmodel_factory_glmnet = memoise::memoise(dnamaging::model_factory_glmnet, cache = cachem::cache_mem(max_size = 10*1024 * 1024^2))}
if (!exists("mcall_glmnet_mod")) {mcall_glmnet_mod = memoise::memoise(dnamaging::call_glmnet_mod)}
if (!exists("mcvaglmnet")) {mcvaglmnet = memoise::memoise(dnamaging::cvaglmnet)}   # Memoise for cvaglmnet
