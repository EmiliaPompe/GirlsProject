library(parallel)

observations <- c(1, rep(0, times=999))
nr_servers <- 4
shards <- split(observations, rep(seq_len(nr_servers),each=length(observations)/nr_servers))

n_iter = 100
burn_in = 0.1*n_iter
sigma = 0.001


clust <- makePSOCKcluster(names = c("greywagtail",
                                    "greyheron",
                                    "greypartridge",
                                    "greyplover"))

clusterEvalQ(cl = clust, source("~/R/beta_example.R"))

lambda <- clusterApplyLB(clust, shards, BetaMH, N=n_iter, sigma=sigma, alpha_prior=1/nr_servers, beta_prior=1/nr_servers)

stopCluster(clust)

df = data.frame(lapply(lambda, function(y) y$x))
colnames(df) <- paste0('x', seq_len(nr_servers))

df$mean = rowMeans(df)