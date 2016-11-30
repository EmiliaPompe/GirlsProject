library(devtools)
devtools::load_all("ConsensusMCMC")


set.seed(15)

sigma_known = 1
observations <- rnorm(10000, 3 , sigma_known)
nr_servers <- 4
shards <- split(observations, rep(seq_len(nr_servers),each=length(observations)/nr_servers))

n_iter = 10000
burn_in = 0.1*n_iter
sigma = 0.01  # sigma for the proposal distribution
mean_prior=0
sigma_prior=1.0
x_0 = 0

clust <- makePSOCKcluster(names = c("greywagtail",
                                    "greyheron",
                                    "greypartridge",
                                    "greyplover"))

clusterEvalQ(cl = clust, devtools::load_all("~/Workspace/GirlsProject/ConsensusMCMC/"))

lambda <- clusterApplyLB(clust, shards, NormalMH, n=n_iter, sigma=sigma, mean_prior=mean_prior, sigma_prior=sigma_prior, sigma_known=sigma_known, s= nr_servers, x_0 = x_0)

stopCluster(clust)

df = data.frame(lapply(lambda, function(y) y))
colnames(df) <- paste0('x', seq_len(nr_servers))


parallel_markov_chain = weightsComputation(df, method = "sample variance")

single_markov_chain = NormalMH(observations, n = n_iter, sigma = sigma, mean_prior=mean_prior, sigma_prior=sigma_prior, sigma_known=sigma_known, s=1, x_0 = x_0) 

theoretical_distribution = rnorm(n_iter,
                          mean = (mean_prior/sigma_prior^2 + sum(observations)/sigma_known^2)/(1/sigma_prior^2 + length(observations)/sigma_known^2),
                          sd = sqrt(1/(1/sigma_prior^2 + length(observations)/sigma_known^2)))


#################################################################################################################
## Plot results
#################################################################################################################

par(mfrow=c(1,1))
HistPlot(list(single_markov_chain, parallel_markov_chain, theoretical_distribution), 
              method = c("1 machine", "4 machines", "theoretical posterior distribution"), burn_in = 0.3)

QQPlot(single_markov_chain[burn_in:n_iter], parallel_markov_chain[burn_in:n_iter], line = TRUE)

TracePlot(list(single_markov_chain, parallel_markov_chain), method = c('single machine', '4 machines'),  burn_in=0.3)
