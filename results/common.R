if (!exists("mreadRDS")) { mreadRDS = memoise::memoise(readRDS) }

if (!exists("cl")) {
  nb_cores = parallel::detectCores()
  cl <<- parallel::makeCluster(nb_cores,  type="FORK")
  # parallel::stopCluster(cl)
}
