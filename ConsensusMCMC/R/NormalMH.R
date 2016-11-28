# Wrapper for C function normalMH

NormalMH <- function(data, n, sigma, mean_prior, sigma_prior, sigma_known, s) {
  ans <- .C("normalMH", as.double(data), as.integer(length(data)), as.integer(n), as.double(sigma), as.double(mean_prior), as.double(sigma_prior), as.double(sigma_known) , as.integer(s), vec_xP=as.double(rep(0, n)))
  return(ans$vec_xP)
}

