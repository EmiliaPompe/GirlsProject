QQPlot <- function(chain1, chain2, line = TRUE, size_point = 2, size_line =1, ...){
# QQPlot creates a qqplot that compares two Markov chains
# if qqline = TRUE we plot also the line (y=x)
  require(ggplot2)
 
  q1 <- quantile(chain1, probs = seq(0, 1, 0.01), na.rm = FALSE)
  q2 <- quantile(chain2, probs = seq(0, 1, 0.01), na.rm = FALSE)
  df <- data.frame(q1 = q1, q2 = q2)
  
  l <- list(...)
  p <-  ggplot(df, aes(x=q1, y=q2)) + geom_point(size = size_point) +l
  if (line){
    p <- p + geom_abline(intercept = 0, slope = 1, col='red', size = size_line)
  }
  p
}

# example for QQPlot
p <- QQPlot(chain1=rnorm(100), chain2=rnorm(100))
p 


TracePlot <- function(list_of_vectors, method = NULL, burn_in = 0, size_line = 1, ...){
  # TracePlot prepares a trace plot for one or several Markov chains
  # TracePlot args: list_of_vectors - a list containing vectors of our Markov chains (it may be a list of one vector only)  
  #                          method - a vector containing names of methods (usually c('single machine', 'several machines'))
  #                         burn_in - a number of burned_in samples (not proportion)  
  #                       size_line - size of the line in the plot 
  #  
  # TO DO solve the problem with burn_in (we want it to be the proportion)
  require(ggplot2)
  l <- list(...)
  chain <- unlist(list_of_vectors)
  iteration <- unlist(lapply(list_of_vectors, function(x) seq_len(length(x)) + burn_in -1))
  df <- data.frame(chain=chain, iteration = iteration)
  
  if(is.null(method)){
    p <- ggplot(df, aes(x=iteration, y=chain)) + geom_line(size = size_line) +  l
  } else {
    df$method <- unlist(lapply(seq_along(list_of_vectors), function(i) {
      rep(method[i], times = length(list_of_vectors[[i]]))
    }))
    
    p <- ggplot(df, aes(x=iteration, y=chain, col = method)) + geom_line(size = size_line) + l
  }
  p
}

# example
TracePlot(list(rnorm(100), rnorm(100)), method = c('single machine', 'several machines'), burn_in=100)


HistPlot <- function(list_of_vectors, method = NULL, size_line = 1,  ...){
# TO DO add description
# TO DO add burn_in periods  
  require(ggplot2)
  l <- list(...)
  chain <- unlist(list_of_vectors)
  df <- data.frame(chain=chain)
  
  if(is.null(method)){
    p <- ggplot(df, aes(x=chain)) + geom_density() +  l
  } else {
    df$method <- unlist(lapply(seq_along(list_of_vectors), function(i) {
      rep(method[i], times = length(list_of_vectors[[i]]))
    }))
    
    p <- ggplot(df, aes(x = chain, col = method)) + geom_density(size = size_line) +  l
  }
  p
}
  

HistPlot(list(rnorm(100), rnorm(100)), method = c('single machine', 'several machines'), size_line=2)


ACFPlot <- function(chain, ...){
  require(ggplot)
  l <- list(...)
# TO DO finish this function  
}