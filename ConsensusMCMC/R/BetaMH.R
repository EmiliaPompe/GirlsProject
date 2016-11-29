
# Wrapper for C function BetaMH

BetaMH <- function(n, sigma, alpha_prior, beta_prior) {
  ans <- .C("BetaMH", as.integer(n), as.double(sigma), as.double(alpha_prior), as.double(beta_prior), vec_xP=as.double(rep(0, n)))
  return(ans$vec_xP)
}


BetaMH_v2 <- function(data, n, sigma, alpha_prior, beta_prior) {
  ans <- .C("BetaMH_v2", as.double(data), as.integer(length(data)), as.integer(n), as.double(sigma), as.double(alpha_prior), as.double(beta_prior), vec_xP=as.double(rep(0, n)))
  return(ans$vec_xP)
}


BetaMH_v3 <- function(data, n, sigma, alpha_prior, beta_prior, s, x_0) {
  ans <- .C("BetaMH_v3", as.double(data), as.integer(length(data)), as.integer(n), as.double(sigma), as.double(alpha_prior), as.double(beta_prior), as.integer(s), as.double(x_0), vec_xP=as.double(rep(0, n)))
  return(ans$vec_xP)
}

