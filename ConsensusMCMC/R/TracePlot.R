#' Trace plots for a list of Markov chains.
#' 
#' \code{} The TracePlot function returns the trace plots for a given list of Markov chains.
#' @param list_of_vectors A list of Markov chains to be plotted. The number of element in the list can be greater or equal than one.
#' @param method A vector giving the different algorithms used to produce the Markov chains. The dafault value is NULL.
#' @param burn_in A proportion of the generated sample that need to be discarded in the plot. Need to be given as a percentage in decimal number of the algorithm iterations. The default value is 0.1.
#' @param size_line The size of the line in the plot. The default value is 1. 
#' @param ... Additional graphical parameters to be passed to ggplot.
#' 
#' @return The function returns the qqplot for two specified Markov chains. 
#' @examples
#' # Generate two sets of values
#' chain1 = rnorm(100)
#' chain2 = rnorm(100)
#' 
#' # Produce the trace plots
#' TracePlot(list(chain1, chain2), 
#'          method = c('Single machine', 'Multiple machines'), 
#'          burn_in = 0.2)
#' 

TracePlot <- function(list_of_vectors, method = NULL, burn_in = 0.1, size_line = 1,...){
  # TracePlot prepares a trace plot for one or several Markov chains
  # TracePlot args: list_of_vectors - a list containing vectors of our Markov chains (it may be a list of one vector only)  
  #                          method - a vector containing names of methods (usually c('single machine', 'several machines'))
  #                         burn_in - a proportion of samples to be burned_in  
  #                       size_line - size of the line in the plot 
  #  
  require(ggplot2)
  l <- list(...)
  list_of_vectors_after_burn_in <- lapply(list_of_vectors, function(x){
    x[floor(length(x)*burn_in):length(x)]
  })
  chain <- unlist(list_of_vectors_after_burn_in)
  
  iteration <- unlist(lapply(list_of_vectors, function(x) floor(length(x)*burn_in):length(x)))
  df <- data.frame(chain = chain, iteration = iteration)
  
  if(is.null(method)){
    p <- ggplot(df, aes(x=iteration, y=chain)) + geom_line(size = size_line) +  l
  } else {
    df$method <- unlist(lapply(seq_along(list_of_vectors_after_burn_in), function(i) {
      rep(method[i], times = length(list_of_vectors_after_burn_in[[i]]))
    }))
    
    p <- ggplot(df, aes(x=iteration, y=chain, col = method)) + geom_line(size = size_line) + l
  }
  p
}


