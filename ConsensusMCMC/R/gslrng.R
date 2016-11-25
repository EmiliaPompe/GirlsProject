gslrng <- function(n) {
  ans <- .C("rng", as.integer(n), res=as.double(rep(0, n)))
  return(ans$res)
}

BetaMH <- function(n, sigma, alpha_prior, beta_prior) {
  ans <- .C("BetaMH", as.integer(n), as.double(sigma), as.double(alpha_prior), as.double(beta_prior), vec_xP=as.double(rep(0, n)))
  return(ans$vec_xP)
}
