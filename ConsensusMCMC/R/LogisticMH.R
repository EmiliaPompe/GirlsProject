LogisticMH <- function() {
  ans <- .C("LogisticMH", vec_xP=as.double(rep(0, 2*(10+1))))
  return(ans$vec_xP)
}