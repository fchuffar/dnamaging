if (!exists("mreadRDS")) { mreadRDS = memoise::memoise(readRDS, cache=cachem::cache_mem(max_size = 10*1024 * 1024^2)) }
if (!exists("mget_coefHannum")) mget_coefHannum = memoise::memoise(methylclockData::get_coefHannum)
