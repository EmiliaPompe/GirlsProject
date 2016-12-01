

### function to compute the weights as a sample variance 

df = data.frame(lapply(lambda, function(y) y))
colnames(df) <- paste0('x', seq_len(nr_servers))

machine_sample_variance = apply(df, 2, var)
machine_precision = 1/machine_sample_variance

sum_machine_precision = sum(machine_precision)

parallel_chain = (as.matrix(df) %*% machine_precision)/sum_machine_precision
