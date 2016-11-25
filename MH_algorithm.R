
MH <- function(data, d = 1, n_iter = 1000, initial_value, prior_par, proposal_distribution, prop_par, target_distribution, ...){ #pass the proposed values to the proposal distribution
  # MH is an implementation of an M-H algorithm
  # data          - vector of data
  # n_iter        - number of iterations
  # initial_value - starting point of our Markov chain   
  # prior_par     - vector or list of prior parameters  be passed to the target distr. to update the pars
  # proposal d.   - distribution used to proposed a new value together with prop_par
  # prop_par      - value of the parameters to be passed to the proposal distribution (mean and sd for normal)
  # target d.     - posterior distribution can be a Beta, a univariate Gaussian dist or a multivariate Gaussian
  # ...           - use to pass the value of known par to the normal posterior distribution
  
  
  acc <- 0
  x <- matrix(NA, nrow=n_iter+1, ncol=d)  # matrix (vector if d=1) to store the values of the Markov Chain
  x[1,] <- initial_value                  # store initial value in the first row of x. Need to be a vector for the multivariate case  
  
  for (i in seq_len(n_iter)){
    
    # we propose a value sampled from the proposal_distribution with par = prop_par
    x_proposed = proposal_distribution(x[i],prop_par)
    
    # assuming a symmetric proposal distribution the accept. probability reduces to the ratio of target distrbutions
    ratio = target_distribution(x_proposed, data, prior_par, ...)/target_distribution(x[i], data, prior_par, ...)
    
    # acceptance step
    if(runif(1, 0,1) < min(c(1, ratio))){
      x[i+1,] <- x_proposed
      acc <- acc +1
    } else {
      x[i+1,] <- x[i,]
    }
    acceptance_ratio = round(acc/n_iter, digits = 4) 
  }
  return(list(x=x, accept_ratio=acceptance_ratio))
}
