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


TracePlot <- function(list_of_vectors, method = NULL, size_line = 1, ...){
  require(ggplot2)
  l <- list(...)
  chain <- unlist(list_of_vectors)
  iteration <- lapply(list_of_vectors, fucntion(x) seq_len(length(x)))
  # TO DO add method
  
  df <- data.frame(chain=chain, iteration = seq_along(chain))
  if(is.null(method)){
    p <- ggplot(df, aes(x=iteration, y=chain)) + geom_line(size = size_line) +  l
  } else {
    df$method <- method
    p <- ggplot(df, aes(x=iteration, y=chain)) + geom_line(size = size_line) + l
  }
}


