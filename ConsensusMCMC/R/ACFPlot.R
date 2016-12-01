#' Plot for the autocorrelation function of a given Markov chain.
#' 
#' \code{} The ACFPlot function returns the plot for the autocorrelation function (acf) of a given Markov chain.
#' @param chain A vector of values from the Markov chain. 
#' @param lag.max Maximum number of lags to be displayed in the plot. Dafault is 10.
#' @param ... Additional graphical parameters to be passed to ggplot.
#' 
#' @return The function returns the acf plot for a specified Markov chain. 
#' @examples
#' # Generate one set of values
#' chain = rnorm(100)
#' 
#' # Produce the plot
#' ACFPlot(chain, lag.max = 10)
#' 

ACFPlot <- function(chain, lag.max = 10, ...){
# TO DO: should this function consider a burn-in
# ACFPlot prepares a plot of autocorrelations for subsequent lags
# ACFPlot args:  chain - a vector of values of our Markov chain
#             lag.max  - values of ACF for lag from 0 to lag.max will be displayed  
  
  require(ggplot2)
  l <- list(...)
  
  # creating a data frame with autocorrelations for subsequent values of lag
  df <- with(acf(chain, lag.max, plot = FALSE), data.frame(lag, acf))
  df$lag <- as.factor(df$lag)
  p <- ggplot(df, aes(x = lag, y = acf)) + geom_bar(stat = "identity") + l
  p
}
