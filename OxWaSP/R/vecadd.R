vecadd <- function(x, y) {
  if(length(x)!=length(y))
    stop("x and y must have same length")
  if(length(x)%%20!=0)
    stop("This toy example only works for vectors of length divisible by 20")
  ans <- .C("VecAdd", as.single(x), as.single(y), sum=as.single(1:1000), as.integer(length(x)))
  return(ans$sum)
}
