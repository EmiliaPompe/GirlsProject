
#' Weights computation for Consensus MCMC algorithm targeting multivariate distributions
#' 
#' \code{} The function computes the weights used for the Consensus MCMC algorithm targeting multivariate distributions. 
#' The computed weights are used to aggregate the Markov Chains obtained parallelizing the data on different machines. 
#' @param result_list A list derived from running \code{\link{LogisticMH}} on the relative data. 
#' @param method The method that needs to be used to aggregate the markov chains obtained from different machines. Need to be used when running in parallel. 
#' @return The functions returns the aggregated Markov chain from the Consensus MCMC.  
#' @examples
#' 
#' # Load the data frame
#' # not run
#' #load('logistic_data_frame.RData')
#' 
#' # Set the parameters
#' sigma = c(0.1, 0.1, 0.1, 0.1, 0.1)           
#' sigma_prior = c(1,1,1,1,1)                   
#' mean_prior = c(-2, 0.5, 0, 0.5, 2)           
#' x_0 = c(-3.5,1.7,-0.2,0.5,3.5)               
#' nr_servers = 4                    
#' n_iter = 10000
#' burn_in = 0.2
#' 
#' # Run the Consensus MCMC algorithm on different machines
#' shards <- split(sample(1:nrow(logistic_data_frame),nrow(logistic_data_frame), replace = FALSE),
#' rep(seq_len(nr_servers),times = nrow(logistic_data_frame)/nr_servers))
#' shards = lapply(shards, function(x) logistic_data_frame[x,])
#'
#' clust <- makePSOCKcluster(names = c("greywagtail",
#'                                    "greyheron",
#'                                    "greypartridge",
#'                                    "greyplover"))
#'                                    
#' clusterEvalQ(cl = clust, devtools::load_all("~/Workspace/GirlsProject/ConsensusMCMC/"))
#'
#' lambda <- clusterApplyLB(clust, shards, LogisticMH, n_iter=n_iter, sigma=sigma, mean_prior=mean_prior, sigma_prior=sigma_prior, s= nr_servers, x_0 = x_0)
#'
#' stopCluster(clust)
#' 
#' # Aggregate the Markov chains
#' parallel_markov_chain = weightsMultivariateComputation(lambda, method="sample variance")
#' 

weightsMultivariateComputation <- function(result_list, method){
  nr_params <- ncol(result_list[[1]]) # we assume that all elements of list have the same number of columns
  
  if (method == "constant"){
    weighted_list <- list()
    for (i in 1:nr_params){
      l <- lapply(result_list, function(x) x[[i]])
      d <- data.frame(l)
      weighted_list[[i]] <-rowMeans(d)
    }
    
    result <- data.frame(weighted_list)
  } 
  
  if (method == "sample variance"){
    list_matrices <- lapply(result_list, function(x) solve(cov(x)))
    sum_weights  <- solve(Reduce('+', list_matrices))
    
    l <- lapply(1:length(result_list), function(i){
      list_matrices[[i]]%*%t(result_list[[i]])
    })
    result <-  t(sum_weights%*%(Reduce('+', l)))
    
  }
  
  return(result)
}