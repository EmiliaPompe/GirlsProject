matmul <- function(A, B) {
  if(!is.matrix(A) || !is.matrix(B))
    stop("A and B must be matrices")
  if(ncol(A)!=nrow(B))
    stop("A and B can't be multiplied")
  ans <- .C("matmul", as.double(A), as.double(B), as.integer(nrow(A)), as.integer(ncol(A)), as.integer(ncol(B)), res=as.double(matrix(0, nrow(A), ncol(B))))
  return(matrix(ans$res, nrow(A), ncol(B))) # Note, ans$res is just an array of doubles on return so we have to cast to the right dimensions
}
