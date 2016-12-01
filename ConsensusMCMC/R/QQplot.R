
#' QQPlot for two Markov chains.
#' 
#' \code{} The QQPlot function returns the qqplot for two given Markov chains.
#' @param chain1 The first Markov-chain to plot.
#' @param chain2 The second Markov-chain to plot.
#' @param line Logical parameter. If TRUE, the line chain1 = chain2 is added to the qqplot. Default value is TRUE. 
#' @param size_point The desired size of the points in the plot. Default value is 2.
#' @param size_line The desired size of the line in the plot. Default value is 1.
#' @param ... Additional graphical parameters to be passed to ggplot.
#' 
#' @return The function returns the qqplot for two specified Markov chains. 
#' @examples
#' # Generate two sets of values
#' chain1=rnorm(100)
#' chain2=rnorm(100)
#' 
#' # Produce the qqplot
#' QQPlot(chain1=rnorm(100), chain2=rnorm(100))
#' 

QQPlot <- function(chain1, chain2, line = TRUE, size_point = 2, size_line =1, ...){
# QQPlot creates a qqplot that compares two Markov chains
# if qqline = TRUE we plot also the line (y=x)
  require(ggplot2)
 
  q1 <- quantile(chain1, probs = seq(0, 1, 0.01), na.rm = FALSE)
  q2 <- quantile(chain2, probs = seq(0, 1, 0.01), na.rm = FALSE)
  df <- data.frame(q1 = q1, q2 = q2)
  
  l <- list(...)
  p <-  ggplot(df, aes(x=q1, y=q2)) + geom_point(size = size_point) + l
  if (line){
    p <- p + geom_abline(intercept = 0, slope = 1, col='red', size = size_line)
  }
  p
}

