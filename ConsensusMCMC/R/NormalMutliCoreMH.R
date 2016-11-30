# Wrapper for C function normalMH

NormalMultiCoreMH <- function(multicore, data, n, sigma, mean_prior, sigma_prior, sigma_known, s, x_0, num_cores) {
  ans <- .C("NormalMultiCoreMH", as.integer(multicore), as.double(data), as.integer(length(data)), as.integer(n), as.double(sigma), as.double(mean_prior), as.double(sigma_prior), as.double(sigma_known) , as.integer(s), as.double(x_0), as.integer(num_cores), vec_xP=as.double(rep(0, n+1)))
  return(ans$vec_xP)
}

