devtools::load_all("ConsensusMCMC")
library(parallel)
library(devtools)
library(ggplot2)

set.seed(15)

observations <- rpois(10000, 4)
nr_servers <- 4
shards <- split(observations, rep(seq_len(nr_servers),each=length(observations)/nr_servers))

n_iter = 100000
burn_in = 0.1*n_iter
sigma = 0.01  # sigma for the proposal distribution
k_prior=1
theta_prior=4
x_0 = 4

clust <- makePSOCKcluster(names = c("greywagtail",
                                    "greyheron",
                                    "greypartridge",
                                    "greyplover"))

clusterEvalQ(cl = clust, devtools::load_all("~/Workspace/GirlsProject/ConsensusMCMC"))

lambda <- clusterApplyLB(clust, shards, GammaMH, n=n_iter, sigma=sigma, k_prior=k_prior, theta_prior=theta_prior, s=nr_servers, x_0 = x_0)

stopCluster(clust)

df = data.frame(lapply(lambda, function(y) y))
colnames(df) <- paste0('x', seq_len(nr_servers))


parallel_markov_chain = weightsComputation(df, method = "sample variance")

single_markov_chain = GammaMH(observations, n_iter, sigma = sigma, k_prior=k_prior, theta_prior=theta_prior, s=1, x_0 = x_0 ) 

theoretical_distribution = rgamma(n_iter, shape = k_prior+sum(observations), scale = theta_prior/(theta_prior*length(observations)+1))


#################################################################################################################
## Plot results
#################################################################################################################

par(mfrow=c(1,1))
HistPlot(list(single_markov_chain, parallel_markov_chain, theoretical_distribution), 
         method = c("1 machine", "4 machines", "theoretical posterior distribution"), burn_in = 0.3)

QQPlot(single_markov_chain[burn_in:n_iter], parallel_markov_chain[burn_in:n_iter], line = TRUE)

TracePlot(list(single_markov_chain, parallel_markov_chain), method = c('single machine', '4 machines'),  burn_in=0.3)


