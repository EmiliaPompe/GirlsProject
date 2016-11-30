sigma_known = 1.0
nr_observations = 100000
set.seed(9)
observations <- rnorm(nr_observations, 3.0, sigma_known)

sigma = 0.01
mean_prior=0.0
sigma_prior=1.0
x_0 = 0.0

n_iter_vec = c(1000, 10000, 100000, 1000000)
n_machines = c(1,4,10)
#time_vec = matrix(NA, nrow=n_alternatives , ncol=4)
time_running_one_core = matrix(NA, nrow=3, ncol=4)

for (k in seq_along(n_iter_vec)){
  for (m in seq_along(n_machines)){
    nr_servers = n_machines[m]
    nr_iter = n_iter_vec[k]
    shards <- split(observations, rep(seq_len(nr_servers),each=length(observations)/nr_servers))
    
    #clust <- makePSOCKcluster(names = c("greywagtail"))# change it!
    #clusterEvalQ(cl = clust, devtools::load_all("~/ConsensusMCMC"))
      time_running[m, k] = unname(system.time({
      lambda <- clusterApplyLB(clust, shards, NormalMultiCoreMH, multicore=0, n=n_iter, sigma=sigma, mean_prior=mean_prior, 
                               sigma_prior=sigma_prior, sigma_known=sigma_known, s= nr_servers, x_0 = x_0, num_cores=1)
   })[3])
    
    stopCluster(clust)
  }
}
  
#####################
n_iter_vec = c(1000, 10000, 100000, 1000000)
n_cores = c(1, 4, 8 )

#time_vec = matrix(NA, nrow=n_alternatives , ncol=4)
time_running_diff_machines = matrix(NA, nrow=3, ncol=4)

for (k in seq_along(n_iter_vec)){
  for (m in seq_along(n_cores)){
    nr_servers = 10
    n_cores = n_cores[m]
    nr_iter = n_iter_vec[k]
    shards <- split(observations, rep(seq_len(nr_servers),each=length(observations)/nr_servers))
    
    #clust <- makePSOCKcluster(names = c("greywagtail"))# change it!
    #clusterEvalQ(cl = clust, devtools::load_all("~/ConsensusMCMC"))
    time_running[m, k] = unname(system.time({
      lambda <- clusterApplyLB(clust, shards, NormalMultiCoreMH, multicore=1, n=n_iter, sigma=sigma, mean_prior=mean_prior, 
                               sigma_prior=sigma_prior, sigma_known=sigma_known, s= nr_servers, x_0 = x_0, num_cores=n_cores[m])
    })[3])
    
    stopCluster(clust)
  }
}
