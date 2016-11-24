library(parallel)
clust <- makePSOCKcluster(names = c("greywagtail",
                                   "greyheron",
                                   "greypartridge",
                                   "greyplover"))

clusterEvalQ(cl = clust, expr = system("hostname"))
stopCluster(clust)

