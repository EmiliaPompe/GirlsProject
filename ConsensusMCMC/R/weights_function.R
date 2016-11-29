
### function to compute weights to aggregate parallel MCMC (constant weights or sample variance) 

weightsComputation = function(df, method){
   
  if (method == "constant"){
    df$mean = rowMeans(df)
    result = df$mean
  } 
  
  if (method == "sample variance"){
    machine_sample_variance = apply(df, 2, var)
    machine_precision = 1/machine_sample_variance
    sum_machine_precision = sum(machine_precision)
    result = (as.matrix(df) %*% machine_precision)/sum_machine_precision
  }
  
  return(result)
}

# df = data.frame(lapply(lambda, function(y) y))
# colnames(df) <- paste0('x', seq_len(nr_servers))
# 
# machine_sample_variance = apply(df, 2, var)
# machine_precision = 1/machine_sample_variance
# 
# sum_machine_precision = sum(machine_precision)
# 
# parallel_chain = (as.matrix(df) %*% machine_precision)/sum_machine_precision
