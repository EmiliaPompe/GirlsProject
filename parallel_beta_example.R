library(parallel)
source("plotting_functions.R")

#observations <- c(1, rep(0, times=999))
observations <- rbinom(100, size = 1, prob = 0.5)
nr_servers <- 4
shards <- split(observations, rep(seq_len(nr_servers),each=length(observations)/nr_servers))

n_iter = 100
burn_in = 0.1*n_iter
sigma = 2

clust <- makePSOCKcluster(names = c("greywagtail",
                                    "greyheron",
                                    "greypartridge",
                                    "greyplover"))

clusterEvalQ(cl = clust, devtools::load_all("~/Workspace/GirlsProject/ConsensusMCMC/"))

lambda <- clusterApplyLB(clust, shards, BetaMH_v3, n=n_iter, sigma=sigma, alpha_prior=1/nr_servers, beta_prior=1/nr_servers)

stopCluster(clust)

df = data.frame(lapply(lambda, function(y) y$x))
colnames(df) <- paste0('x', seq_len(nr_servers))

df$mean = rowMeans(df)

par(mfrow=c(1,1))
result = BetaMH_v3(observations, n_iter, sigma = sigma, alpha_prior=1, beta_prior=1, s=1, x_0=0.1 )
markov_chain = result$x

d1 = density(markov_chain)
d2 = density(df$mean)
d3 = density(rbeta(10000,2,1000))

plot(range(d1$x, d2$x, d3$x), range(d1$y, d2$y, d3$y), type = "n", xlab = "x",
     ylab = "Density", xlim=c(0,0.01))
lines(d1, col = "red")
lines(d2, col = "blue")
lines(d3, col = "black")

plot(density(markov_chain))
plot(density(df$mean), col='red')

qqplot(markov_chain[burn_in:n_iter], df$mean[burn_in:n_iter])
