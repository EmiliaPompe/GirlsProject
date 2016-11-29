
#' Weights computation for Consensus MCMC algorithm
#' 
#' \code{} The function computes the weights used for the Consensus MCMC algorithm. 
#' The computed weights are used to aggregate the Markov Chains obtained parallelizing the data on different machines. 
#' @param x A number
#' @param y A number
#' @return The sum of \code{x} and \code{y}
#' @examples
#' add(1, 1)
#' add(10, 1)

### function to compute weights to aggregate parallel MCMC (constant weights or sample variance) 

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

