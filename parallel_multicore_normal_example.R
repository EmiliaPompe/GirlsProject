library(devtools)
devtools::load_all("ConsensusMCMC")

time_start = Sys.time()

############################################################################
#  Generate data and specify params
############################################################################
sigma_known = 1.0
nr_observations = 30000
observations <- rnorm(nr_observations, 3, sigma_known)

n_iter = 100000
burn_in = 0.3
sigma = 0.01
mean_prior=0.0
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

lambda <- clusterApplyLB(clust, shards, NormalMultiCoreMH, multicore=1,n=n_iter, sigma=sigma, mean_prior=mean_prior, sigma_prior=sigma_prior, sigma_known=sigma_known, s= nr_servers, x_0 = x_0)

stopCluster(clust)

df = data.frame(lapply(lambda, function(y) y))
colnames(df) <- paste0('x', seq_len(nr_servers))

#  Combine results
#df$mean = rowMeans(df)
parallel_chain = weightsComputation(df, method="constant")

############################################################################
#  Run on a single machine
############################################################################

nr_servers <- 1
shards <- split(observations, rep(seq_len(nr_servers),each=length(observations)/nr_servers))

clust <- makePSOCKcluster(names = c("greywagtail"))
clusterEvalQ(cl = clust, devtools::load_all("~/Workspace/GirlsProject/ConsensusMCMC/"))
lambda <- clusterApplyLB(clust, shards, NormalMultiCoreMH, multicore=1, n=n_iter, sigma=sigma, mean_prior=mean_prior, sigma_prior=sigma_prior, sigma_known=sigma_known, s= nr_servers, x_0 = x_0)
stopCluster(clust)

df = data.frame(lapply(lambda, function(y) y))
colnames(df) <- paste0('x', seq_len(nr_servers))
single_chain = df$x

#single_chain = NormalMultiCoreMH(multicore=1, data=observations, n = n_iter, sigma = sigma, mean_prior=mean_prior, sigma_prior=sigma_prior, sigma_known=sigma_known, s=1, x_0 = x_0) #are these args right TODO

############################################################################
#  Plot and compare to theory
############################################################################

mean_post = (mean_prior/sigma_prior^2 + sum(observations)/sigma_known^2)/(1/sigma_prior^2 + length(observations)/sigma_known^2)
sigma_post = sqrt(1/(1/sigma_prior^2 + length(observations)/sigma_known^2))
theoretical = rnorm(10000, mean_post, sigma_post)

HistPlot(list(single_chain, parallel_chain, theoretical), method = c("1 machine, multicore", "4 machines, multicore", "Theoretical"), burn_in = burn_in)
#HistPlot(list(single_chain, parallel_chain), method = c("1 machine, multicore", "4 machines, multicore"), burn_in = burn_in)

cat(Sys.time() - time_start)

############################################################################
#  Compare different number of computers - DONE ON AMAZON
############################################################################
# 
# n_iter_vec = c(1000, 10000, 100000, 1000000)
# n_machines = c(1,4,10)
# #time_vec = matrix(NA, nrow=n_alternatives , ncol=4)
# 
# for (k in n_iter_vec){
#   for (m in n_machines){
#     nr_servers = m
#     print(m)
#     nr_iter_vec = n_iter_vec  
#   }
#   
#   shards <- split(observations, rep(seq_len(nr_servers),each=length(observations)/nr_servers))
#   clust <- makePSOCKcluster(names = c("greywagtail"))
#   clusterEvalQ(cl = clust, devtools::load_all("~/Workspace/GirlsProject/ConsensusMCMC/"))
#   lambda <- clusterApplyLB(clust, shards, NormalMultiCoreMH, multicore=1, n=n_iter, sigma=sigma, mean_prior=mean_prior, sigma_prior=sigma_prior, sigma_known=sigma_known, s= nr_servers, x_0 = x_0)
#   stopCluster(clust)
#   
#   df = data.frame(lapply(lambda, function(y) y))
#   colnames(df) <- paste0('x', seq_len(nr_servers))
#   single_chain = df$x
#   
#   
#   names <- c("greywagtail",
#              "greyheron",
#              "greypartridge",
#              "greyplover")
#   time_start = Sys.time()
#   
#   }
# 
# 
# for (nr_servers in rep(1:4,5)) {
#   time_start = Sys.time()
# 
#     shards <- split(observations, rep(seq_len(nr_servers),each=length(observations)/nr_servers))
#   
#   clust <- makePSOCKcluster(names = server_sample)
#   
#   clusterEvalQ(cl = clust, devtools::load_all("~/Workspace/GirlsProject/ConsensusMCMC/"))
#   
#   lambda <- clusterApplyLB(clust, shards, NormalMultiCoreMH, multicore=1,n=n_iter, sigma=sigma, mean_prior=mean_prior, sigma_prior=sigma_prior, sigma_known=sigma_known, s= nr_servers, x_0 = x_0)
#   
#   stopCluster(clust)
#   
#   df = data.frame(lapply(lambda, function(y) y))
#   colnames(df) <- paste0('x', seq_len(nr_servers))
#   
#   #  Combine results
#   #df$mean = rowMeans(df)
#   parallel_chain = weightsComputation(df, method="constant")
#   print(nr_servers)
#   print(Sys.time() - time_start)
# }
