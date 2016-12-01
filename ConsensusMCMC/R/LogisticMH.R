
LogisticMH <- function(data_frame,  n_iter, sigma, sigma_prior, mean_prior, s, x_0) {
  data <- data_frame$y
  z <- as.matrix(subset(data_frame, select =  -c(y)))
  ans <- .C("LogisticMH", as.integer(data), as.vector(as.double(t(z))), as.integer(length(data)), 
            as.integer(ncol(z)), as.integer(n_iter), as.double(sigma), as.double(sigma_prior), 
            as.double(mean_prior), as.integer(s), as.double(x_0),  vec_xP=as.double(rep(0, (n_iter+1)*(ncol(z)))))
  
  result <- as.data.frame(matrix(ans$vec_xP, ncol = ncol(z), byrow=TRUE))
  colnames(result) <- paste0('beta_', seq_len(result)-1)
  return(result)
}

