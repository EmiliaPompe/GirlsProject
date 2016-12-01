library(devtools)
devtools::load_all("ConsensusMCMC")


set.seed(15)
# load our data frame
load('logistic_data_frame.RData')
#################################################################################################################
## Set parameters
#################################################################################################################

sigma = c(0.1, 0.1, 0.1, 0.1, 0.1)           #covariance matrix for the proposal distribution. Need to be of dimension ncol
sigma_prior = c(1,1,1,1,1)                   #covariance prior for beta coefficients dimension nrow(z)
mean_prior = c(-2, 0.5, 0, 0.5, 2)           #mean prior for beta coefficients dimension nrow(z)
x_0 = c(-3.5,1.7,-0.2,0.5,3.5)               #initial values for the parameters of interest (beta)
nr_servers = 4                    
n_iter = 10000
burn_in = 0.2

############################################################################
#  Split data into shards and run on 4 machines
############################################################################

shards <- split(1:nrow(logistic_data_frame), rep(seq_len(nr_servers),each=nrow(logistic_data_frame)/nr_servers))
shards = lapply(shards, function(x) logistic_data_frame[x,])

clust <- makePSOCKcluster(names = c("greywagtail",
                                    "greyheron",
                                    "greypartridge",
                                    "greyplover"))

clusterEvalQ(cl = clust, devtools::load_all("~/Workspace/GirlsProject/ConsensusMCMC/"))

lambda <- clusterApplyLB(clust, shards, LogisticMH, n_iter=n_iter, sigma=sigma, mean_prior=mean_prior, sigma_prior=sigma_prior, s= nr_servers, x_0 = x_0)

stopCluster(clust)

df = data.frame(lapply(lambda, function(y) y))
colnames(df) <- paste0('x', seq_len(nr_servers))

#  Combine results
parallel_chain = weightsComputation(df, method="sample variance")


############################################################################
#  Run on a single machine
############################################################################

nr_servers <- 1

clust <- makePSOCKcluster(names = c("greywagtail"))
clusterEvalQ(cl = clust, devtools::load_all("~/Workspace/GirlsProject/ConsensusMCMC/"))
lambda <- clusterApplyLB(clust, shards, LogisticMH, n=n_iter, sigma=sigma, mean_prior=mean_prior, sigma_prior=sigma_prior, sigma_known=sigma_known, s= nr_servers, x_0 = x_0)
stopCluster(clust)

df = data.frame(lapply(lambda, function(y) y))
colnames(df) <- paste0('x', seq_len(nr_servers))
single_chain = df$x


#################################################################################################################
## Plot results
#################################################################################################################

par(mfrow=c(1,1))
HistPlot(list(single_markov_chain, parallel_markov_chain, theoretical_distribution), 
         method = c("1 machine", "4 machines", "theoretical posterior distribution"), burn_in = 0.3)

QQPlot(single_markov_chain[burn_in:n_iter], parallel_markov_chain[burn_in:n_iter], line = TRUE)

TracePlot(list(single_markov_chain, parallel_markov_chain), method = c('single machine', '4 machines'),  burn_in=0.3)

