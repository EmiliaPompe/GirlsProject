sq <- function(x) {
  ans <- .C("sq", as.double(x), res=as.double(0))
  return(ans$res)
}
