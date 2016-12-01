library(devtools)
devtools::load_all("ConsensusMCMC")


set.seed(15)

#################################################################################################################
## Create data
#################################################################################################################

#beta_coefficients = c(-3, 1.2, -0.5, 0.8, 3) #true bete parameters
z = rbind(matrix(rep(c(1,0,0,1,0), 2755), nrow = 2755, byrow=TRUE),
          matrix(rep(c(1,0,0,0,0), 2753), nrow = 2753, byrow=TRUE),
          matrix(rep(c(1,0,1,0,0), 1186), nrow = 1186, byrow=TRUE),
          matrix(rep(c(1,1,0,1,0), 717), nrow = 717, byrow=TRUE),
          matrix(rep(c(1,0,1,1,0), 1173), nrow = 1173, byrow=TRUE),
          matrix(rep(c(1,1,1,0,0), 305), nrow = 305, byrow=TRUE),
          matrix(rep(c(1,1,1,1,0), 301), nrow = 301, byrow=TRUE),
          matrix(rep(c(1,1,0,0,0), 706), nrow = 706, byrow=TRUE),
          matrix(rep(c(1,0,0,0,1), 32), nrow = 32, byrow=TRUE),
          matrix(rep(c(1,0,1,1,1), 17), nrow = 17, byrow=TRUE),
          matrix(rep(c(1,0,0,1,1), 24), nrow = 24, byrow=TRUE),
          matrix(rep(c(1,1,0,1,1), 10), nrow = 10, byrow=TRUE),
          matrix(rep(c(1,1,1,0,1), 2), nrow = 2, byrow=TRUE),
          matrix(rep(c(1,0,1,0,1), 13), nrow = 13, byrow=TRUE),
          matrix(rep(c(1,1,1,1,1), 2), nrow = 2, byrow=TRUE),
          matrix(rep(c(1,1,0,0,1), 4), nrow = 4, byrow=TRUE))

y = c(rep(1, times=266),
      rep(0, times=2755-266),
      rep(1, times=116), 
      rep(0, times=2753 - 116),
      rep(1, times=34), 
      rep(0, times=1186-34),
      rep(1, times=190), 
      rep(0, times=717-190),
      rep(1, times=61), 
      rep(0, times=1173-61),
      rep(1, times = 37), 
      rep(0, times = 305-37),
      rep(1, times=68), 
      rep(0, times=301-68),
      rep(1, 119), 
      rep(0, 706-119),
      rep(1, 18), 
      rep(0, 32-18),
      rep(1, 13), 
      rep(0,4),
      rep(1, 18),
      rep(0,6),
      rep(1, 8),
      rep(0, 2),
      rep(1,2),
      rep(1,7), 
      rep(0, 6),
      rep(1,2),
      rep(1,3), 
      rep(0,1))



#################################################################################################################
## Set parameters
#################################################################################################################

sigma = c(0.1, 0.1, 0.1, 0.1, 0.1)           #covariance matrix for the proposal distribution. Need to be of dimension ncol
sigma_prior = c(1,1,1,1,1)                   #covariance prior for beta coefficients dimension nrow(z)
mean_prior = c(-2, 0.5, 0, 0.5, 2)           #mean prior for beta coefficients dimension nrow(z)
x_0 = c(-3.5,1.7,-0.2,0.5,3.5)               #initial values for the parameters of interest (beta)
nr_servers = 4                    
n_iter = 10000
burn_in = 0.5

############################################################################
#  Split data into shards and run on 4 machines
############################################################################

z_data <- as.data.frame(z)
z_data$y <- as.factor(y)
z_data = as.data.frame(z_data)
shards <- split(1:nrow(z_data), rep(seq_len(nr_servers),each=length(observations)/nr_servers))
shards = lapply(shards, function(x) z_data[x,])

clust <- makePSOCKcluster(names = c("greywagtail",
                                    "greyheron",
                                    "greypartridge",
                                    "greyplover"))

clusterEvalQ(cl = clust, devtools::load_all("~/Workspace/GirlsProject/ConsensusMCMC/"))

lambda <- clusterApplyLB(clust, shards, LogisticMH, n=n_iter, sigma=sigma, mean_prior=mean_prior, sigma_prior=sigma_prior, sigma_known=sigma_known, s= nr_servers, x_0 = x_0)

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

