library(parallel)
library(devtools)
library(ggplot2)

devtools::load_all("ConsensusMCMC")

time_start = Sys.time()

############################################################################
#  Generate data and specify params
############################################################################

sigma_known = 1.0
nr_observations = 10000
observations <- rnorm(nr_observations, 0.0, sigma_known)

n_iter = 10000
burn_in = 0.5
sigma = 0.1
mean_prior=0.0
sigma_prior=1.0
x_0 = 2.0

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

lambda <- clusterApplyLB(clust, shards, NormalMultiCoreMH, multicore=TRUE,n=n_iter, sigma=sigma, mean_prior=mean_prior, sigma_prior=sigma_prior, sigma_known=sigma_known, s= nr_servers, x_0 = x_0)

stopCluster(clust)

df = data.frame(lapply(lambda, function(y) y))
colnames(df) <- paste0('x', seq_len(nr_servers))

#  Combine results
#df$mean = rowMeans(df)
parallel_chain = weightsComputation(df, method="sample variance")

############################################################################
#  Run on a single machine
############################################################################

nr_servers <- 1
shards <- split(observations, rep(seq_len(nr_servers),each=length(observations)/nr_servers))

clust <- makePSOCKcluster(names = c("greywagtail"))
clusterEvalQ(cl = clust, devtools::load_all("~/Workspace/GirlsProject/ConsensusMCMC/"))
lambda <- clusterApplyLB(clust, shards, NormalMultiCoreMH, multicore=TRUE, n=n_iter, sigma=sigma, mean_prior=mean_prior, sigma_prior=sigma_prior, sigma_known=sigma_known, s= nr_servers, x_0 = x_0)
stopCluster(clust)

df = data.frame(lapply(lambda, function(y) y))
colnames(df) <- paste0('x', seq_len(nr_servers))
single_chain = df$x

#single_chain = NormalMultiCoreMH(multicore=TRUE, data=observations, n = n_iter, sigma = sigma, mean_prior=mean_prior, sigma_prior=sigma_prior, sigma_known=sigma_known, s=1, x_0 = x_0) #are these args right TODO

############################################################################
#  Plot and compare to theory
############################################################################

mean_post = (mean_prior/sigma_prior^2 + sum(observations)/sigma_known^2)/(1/sigma_prior^2 + length(observations)/sigma_known^2)
sigma_post = sqrt(1/(1/sigma_prior^2 + length(observations)/sigma_known^2))
theoretical = rnorm(100, mean_post, sigma_post)

HistPlot(list(single_chain, parallel_chain, theoretical), method = c("1 machine, multicore", "4 machines, multicore", "Theoretical"), burn_in = burn_in)
#HistPlot(list(single_chain, parallel_chain), method = c("1 machine, multicore", "4 machines, multicore"), burn_in = burn_in)

cat(Sys.time() - time_start)
