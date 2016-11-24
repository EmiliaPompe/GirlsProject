ssq_naive <- function(x, y) {
  if(length(x)!=length(y))
    stop("x and y must have same length")
  ans <- .C("sumSumSq_naive", as.double(x), as.double(y), sum=as.double(0), sumsq=as.double(0), as.integer(length(x)))
  return(list(sum_X_Y=ans$sum, sumSq_X_Y=ans$sumsq))
}

ssq_naive_restrict <- function(x, y) {
  if(length(x)!=length(y))
    stop("x and y must have same length")
  ans <- .C("sumSumSq_naive_restrict", as.double(x), as.double(y), sum=as.double(0), sumsq=as.double(0), as.integer(length(x)))
  return(list(sum_X_Y=ans$sum, sumSq_X_Y=ans$sumsq))
}

ssq_naive_restrict_omp <- function(x, y) {
  if(length(x)!=length(y))
    stop("x and y must have same length")
  ans <- .C("sumSumSq_naive_restrict_omp", as.double(x), as.double(y), sum=as.double(0), sumsq=as.double(0), as.integer(length(x)))
  return(list(sum_X_Y=ans$sum, sumSq_X_Y=ans$sumsq))
}

ssq_ispc <- function(x, y) {
  if(length(x)!=length(y))
    stop("x and y must have same length")
  ans <- .C("sumSumSq_ispc", as.double(x), as.double(y), sum=as.double(0), sumsq=as.double(0), as.integer(length(x)))
  return(list(sum_X_Y=ans$sum, sumSq_X_Y=ans$sumsq))
}

ssq_SIMD <- function(x, y) {
  warning("THIS WILL SEGFAULT ... DO YOU KNOW WHY?!?")
  if(length(x)!=length(y))
    stop("x and y must have same length")
  ans <- .C("sumSumSq_SIMD", as.double(x), as.double(y), sum=as.double(0), sumsq=as.double(0), as.integer(length(x)))
  return(list(sum_X_Y=ans$sum, sumSq_X_Y=ans$sumsq))
}

ssq_SIMD_omp <- function(x, y) {
  warning("THIS WILL SEGFAULT ... DO YOU KNOW WHY?!?")
  if(length(x)!=length(y))
    stop("x and y must have same length")
  ans <- .C("sumSumSq_SIMD_omp", as.double(x), as.double(y), sum=as.double(0), sumsq=as.double(0), as.integer(length(x)))
  return(list(sum_X_Y=ans$sum, sumSq_X_Y=ans$sumsq))
}
