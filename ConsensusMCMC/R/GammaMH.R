# Wrapper for C function gammaMH
#int *restrict dataP, int *restrict data_lenP,  int *restrict nP, double *restrict sigmaP, double *restrict k_priorP, double *restrict theta_priorP, double *restrict vec_xP

GammaMH <- function(data, n, sigma, k_prior, theta_prior) {
  ans <- .C("gammaMH", as.integer(data), as.integer(length(data)), as.integer(n), as.double(sigma), as.double(k_prior), as.double(theta_prior), vec_xP=as.double(rep(0, n)))
  return(ans$vec_xP)
}

data <- rpois(1000, 5)
chain <- GammaMH(data, 100000, 0.9, 1,4) # our markov chain
chain2 <- rgamma(1000000, 1 + sum(data), scale = 4/(4*length(data)+1)) # theoretical  posterior distribution
HistPlot(list(chain, chain2), method = c('markov', 'theor'), 0.1, size_line=2)
         