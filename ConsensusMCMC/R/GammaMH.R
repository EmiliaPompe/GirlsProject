# Wrapper for C function gammaMH
#int *restrict dataP, int *restrict data_lenP,  int *restrict nP, double *restrict sigmaP, double *restrict k_priorP, double *restrict theta_priorP, double *restrict vec_xP

GammaMH <- function(data, n, sigma, k_prior, theta_prior, s) {
  ans <- .C("gammaMH", as.integer(data), as.integer(length(data)), as.integer(n), as.double(sigma), as.double(k_prior), as.double(theta_prior), as.integer(s), vec_xP=as.double(rep(0, n)))
  return(ans$vec_xP)
}

