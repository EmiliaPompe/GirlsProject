library(parallel)
source("plotting_functions.R")

sigma_known = 1.0
observations <- rnorm(2, 0 , sigma_known)
nr_servers <- 4
shards <- split(observations, rep(seq_len(nr_servers),each=length(observations)/nr_servers))

n_iter = 2
burn_in = 0.1*n_iter
sigma = 0.01

clust <- makePSOCKcluster(names = c("greywagtail",
                                    "greyheron",
                                    "greypartridge",
                                    "greyplover"))

clusterEvalQ(cl = clust, devtools::load_all("~/Workspace/GirlsProject/ConsensusMCMC/"))

lambda <- clusterApplyLB(clust, shards, NormalMH, n=n_iter, sigma=sigma, mean_prior=0, sigma_prior=1.0, sigma_known=sigma_known, s= nr_servers)

stopCluster(clust)

df = data.frame(lapply(lambda, function(y) y))
colnames(df) <- paste0('x', seq_len(nr_servers))

df$mean = rowMeans(df)

par(mfrow=c(1,1))
result = NormalMH(observations, n = n_iter, sigma = sigma, mean_prior=1/nr_servers, sigma_prior=1/nr_servers, sigma_known=sigma_known, s=1) #are these args right TODO
markov_chain = result

d1 = density(markov_chain)
d2 = density(df$mean)
d3 = density(rnorm(1000, 4 , sigma_known))

plot(range(d1$x, d2$x, d3$x), range(d1$y, d2$y, d3$y), type = "n", xlab = "x",
     ylab = "Density", xlim=c(0,0.01))
lines(d1, col = "red")
lines(d2, col = "blue")
lines(d3, col = "black")

plot(density(markov_chain))
plot(density(df$mean), col='red')

qqplot(markov_chain[burn_in:n_iter], df$mean[burn_in:n_iter])
