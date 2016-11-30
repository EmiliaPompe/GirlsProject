
LogisticMH <- function(data, z, n_iter, sigma, sigma_prior, mean_prior, s, x_0) {
  ans <- .C("LogisticMH", as.integer(data), as.vector(as.double(t(z))), as.integer(length(data)), 
            as.integer(ncol(z)), as.integer(n_iter), as.double(sigma), as.double(sigma_prior), 
            as.double(mean_prior), as.integer(s), as.double(x_0),  vec_xP=as.double(rep(0, (n_iter+1)*(ncol(z)))))
  return(ans$vec_xP)
}

