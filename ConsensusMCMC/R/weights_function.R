
#' Weights computation for Consensus MCMC algorithm targeting univariate distributions
#' 
#' \code{} The function computes the weights used for the Consensus MCMC algorithm targeting univariate distributions. 
#' The computed weights are used to aggregate the Markov Chains obtained parallelizing the data on different machines. 
#' @param df A dataframe derived from running \code{\link{BetaMH}} or \code{\link{NormalMH}} or \code{\link{GammaMH}} or \code{\link{NormalMultiCoreMH}}on the relative data. 
#' @param method The method that needs to be used to aggregate the markov chains obtained from different machines. Need to be used when running in parallel. 
#' @return The functions returns the aggregated Markov chain from the Consensus MCMC.  
#' @examples
#' 
#' # Generate the data
#' sigma_known = 1
#' observations <- rnorm(10000, 3 , sigma_known)
#' nr_servers <- 4
#' 
#' 
#' # Set the parameters
#' n_iter = 10000
#' n_iter = 10000
#' burn_in = 0.1*n_iter
#' sigma = 0.01  # sigma for the proposal distribution
#' mean_prior=0
#' sigma_prior=1.0
#' x_0 = -5
#' 
#' # Run the Consensus MCMC algorithm on different machines
#' #' shards <- split(observations, rep(seq_len(nr_servers),each=length(observations)/nr_servers))
#' clust <- makePSOCKcluster(names = c("greywagtail",
#'                                    "greyheron",
#'                                    "greypartridge",
#'                                    "greyplover"))
#'                                    
#' clusterEvalQ(cl = clust, devtools::load_all("~/Workspace/GirlsProject/ConsensusMCMC/"))
#'
#' lambda <- clusterApplyLB(clust, shards, NormalMH, n=n_iter, sigma=sigma, mean_prior=mean_prior, sigma_prior=sigma_prior, sigma_known=sigma_known, s= nr_servers, x_0 = x_0)
#'
#' stopCluster(clust)
#'
#' df = data.frame(lapply(lambda, function(y) y))
#' colnames(df) <- paste0('x', seq_len(nr_servers))
#' df = data.frame(lapply(lambda, function(y) y))
#' 
#' # Aggregate the Markov chains
#' parallel_markov_chain = weightsComputation(df, method = "sample variance")
#' 

weightsComputation = function(df, method){
   
  if (method == "constant"){
    df$mean = rowMeans(df)
    result = df$mean
  } 
  
  if (method == "sample variance"){
    machine_sample_variance = apply(df, 2, var)
    machine_precision = 1/machine_sample_variance
    sum_machine_precision = sum(machine_precision)
    result = (as.matrix(df) %*% machine_precision)/sum_machine_precision
  }
  
  return(result)
}

