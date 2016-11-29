library(parallel)
library(devtools)
library(ggplot2)
source("plotting_functions.R")

sigma_known = 0.1
observations <- rnorm(1000, 0 , sigma_known)
nr_servers <- 4
shards <- split(observations, rep(seq_len(nr_servers),each=length(observations)/nr_servers))

n_iter = 1000
burn_in = 0.1*n_iter
sigma = 0.01
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

df$mean = rowMeans(df)

par(mfrow=c(1,1))
result = NormalMH(observations, n = n_iter, sigma = sigma, mean_prior=mean_prior, sigma_prior=sigma_prior, sigma_known=sigma_known, s=1, x_0 = x_0) #are these args right TODO
markov_chain = result
mean_post = (mean_prior/sigma_prior^2 + sum(observations)/sigma_known^2)/(1/sigma_prior^2 + length(observations)/sigma_known^2)
sigma_post = sqrt(1/(1/sigma_prior^2 + length(observations)/sigma_known^2))

HistPlot(list(markov_chain, rnorm(1000, mean_post, sigma_post)), method = c("markov chain", "theor"), burn_in = 0.3)

HistPlot(list(markov_chain, df$mean, rnorm(1000, mean_post, sigma_post)), method = c("One machine", "4 machines", "theoretical post distribution"), burn_in = 0.3)

HistPlot(list(df$x1, df$x2, df$x3, df$x4), method = c("1", "2", "3", "4"))
#d1 = density(markov_chain)
#d2 = density(df$mean)
#d3 = density(rnorm(1000, mean_post, sigma_post))

#plot(range(d1$x, d2$x, d3$x), range(d1$y, d2$y, d3$y), type = "n", xlab = "x",
#     ylab = "Density", xlim=c(0,0.01))
#lines(d1, col = "red")
#lines(d2, col = "blue")
#lines(d3, col = "black")

#plot(density(markov_chain))
#plot(density(df$mean), col='red')

qqplot(markov_chain[burn_in:n_iter], df$mean[burn_in:n_iter])
