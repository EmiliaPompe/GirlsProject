gslrng <- function(n) {
  ans <- .C("rng", as.integer(n), res=as.double(rep(0, n)))
  return(ans$res)
}
