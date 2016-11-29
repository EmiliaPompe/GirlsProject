library(parallel)
source("plotting_functions.R")

observations <- rpois(10000, 4)
#chain <- GammaMH(data, 10000, 0.9, 1,4, s = 1) # our markov chain
#chain2 <- rgamma(1000000, 1 + sum(data), scale = 4/(4*length(data)+1)) # theoretical  posterior distribution
#HistPlot(list(chain, chain2), method = c('markov', 'theor'), 0.1, size_line=2)

nr_servers <- 4
shards <- split(observations, rep(seq_len(nr_servers),each=length(observations)/nr_servers))

n_iter = 100
burn_in = 0.1*n_iter
sigma = 0.1

clust <- makePSOCKcluster(names = c("greywagtail",
                                    "greyheron",
                                    "greypartridge",
                                    "greyplover"))

clusterEvalQ(cl = clust, devtools::load_all("~/Workspace/GirlsProject/ConsensusMCMC"))

lambda <- clusterApplyLB(clust, shards, GammaMH, n=n_iter, sigma=sigma, k_prior=1, theta_prior=4, s=nr_servers)

stopCluster(clust)

df = data.frame(lapply(lambda, function(y) y))
colnames(df) <- paste0('x', seq_len(nr_servers))

df$mean = rowMeans(df)

par(mfrow=c(1,1))
markov_chain = GammaMH(observations, n_iter, sigma = sigma, k_prior=1, theta_prior=4, s=1, x_0 = 4 ) 
HistPlot(list(markov_chain, rgamma(10000, shape = 1+sum(observations), scale = 4/(4*length(observations)+1))), method = c("One machine", "theoretical"), burn_in = 0.1)


HistPlot(list(markov_chain, df$mean), method = c("One machine", "4 machines"), burn_in = 0.1)

plot(range(d1$x, d2$x, d3$x), range(d1$y, d2$y, d3$y), type = "n", xlab = "x",
     ylab = "Density", xlim=c(0,0.01))
lines(d1, col = "red")
lines(d2, col = "blue")
lines(d3, col = "black")

plot(density(markov_chain))
plot(density(df$mean), col='red')

qqplot(markov_chain[burn_in:n_iter], df$mean[burn_in:n_iter])
