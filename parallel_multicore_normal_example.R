devtools::load_all("ConsensusMCMC")
library(parallel)
library(devtools)
library(ggplot2)
source("plotting_functions.R")

############################################################################
#  Generate data and specify params
############################################################################

sigma_known = 1
observations <- rnorm(10000, 3 , sigma_known)

n_iter = 10000
burn_in = 0.1*n_iter
sigma = 0.01
mean_prior=0
sigma_prior=1.0
x_0 = 0

############################################################################
#  Split data into shards and run on 4 machines
############################################################################

nr_servers <- 4
shards <- split(observations, rep(seq_len(nr_servers),each=length(observations)/nr_servers))

clust <- makePSOCKcluster(names = c("greywagtail",
                                    "greyheron",
                                    "greypartridge",
                                    "greyplover"))

clusterEvalQ(cl = clust, devtools::load_all("~/Workspace/GirlsProject/ConsensusMCMC/"))

lambda <- clusterApplyLB(clust, shards, NormalMH, n=n_iter, sigma=sigma, mean_prior=mean_prior, sigma_prior=sigma_prior, sigma_known=sigma_known, s= nr_servers, x_0 = x_0)

stopCluster(clust)

df = data.frame(lapply(lambda, function(y) y))
colnames(df) <- paste0('x', seq_len(nr_servers))

#  Combine results
df$mean = rowMeans(df)


############################################################################
#  Run on a single machine
############################################################################

result = NormalMH(observations, n = n_iter, sigma = sigma, mean_prior=mean_prior, sigma_prior=sigma_prior, sigma_known=sigma_known, s=1, x_0 = x_0) #are these args right TODO

############################################################################
#  Plot and compare to theory
############################################################################

mean_post = (mean_prior/sigma_prior^2 + sum(observations)/sigma_known^2)/(1/sigma_prior^2 + length(observations)/sigma_known^2)
sigma_post = sqrt(1/(1/sigma_prior^2 + length(observations)/sigma_known^2))

HistPlot(list(markov_chain, parallel_chain, rnorm(10000, mean_post, sigma_post)), method = c("One machine", "4 machines", "theoretical post distribution"), burn_in = 0.3)
