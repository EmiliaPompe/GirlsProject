# Wrapper for C function normalMH

NormalMH <- function(data, n, sigma, mean_prior, sigma_prior, sigma_known, s, x_0) {
  ans <- .C("normalMH", as.double(data), as.integer(length(data)), as.integer(n), as.double(sigma), as.double(mean_prior), as.double(sigma_prior), as.double(sigma_known) , as.integer(s), as.double(x_0), vec_xP=as.double(rep(0, n+1)))
  return(ans$vec_xP)
}

