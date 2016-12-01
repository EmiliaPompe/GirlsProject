weightsMultivariateComputation <- function(result_list, method){
  nr_params <- ncol(result_list[[1]]) # we assume that all elements of list have the same number of columns
  
  if (method == "constant"){
    weighted_list <- list()
    for (i in 1:nr_params){
      l <- lapply(result_list, function(x) x[[i]])
      d <- data.frame(l)
      weighted_list[[i]] <-rowMeans(d)
    }
    
    result <- data.frame(weighted_list)
  } 
  
  if (method == "sample variance"){
    list_matrices <- lapply(result_list, function(x) solve(cov(x)))
    sum_weights  <- solve(Reduce('+', list_matrices))
    
    l <- lapply(1:length(result_list), function(i){
      list_matrices[[i]]%*%t(result_list[[i]])
    })
    result <-  t(sum_weights%*%(Reduce('+', l)))
    
  }
  
  return(result)
}