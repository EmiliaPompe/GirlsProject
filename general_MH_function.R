install.packages("MASS")
library("MASS")

d = 1               #dimension
prior_par = c(1,1)  #in the beta case this is alpha and beta
initial_value = 0.1 #initial value for the Markov Chain
n_iter = 100        #number of iterations
prop_par = c(0.1)   #in this case my proposed value is sigma



MH <- function(data, d = 1, n_iter = 1000, initial_value, prior_par, target_distribution, proposal_distribution, prop_par, ...){ #pass the proposed values to the proposal distribution
  # MH is an implementation of an M-H algorithm
  # the posterior (target distribution) can be a Beta, a univariate Gaussian
  # the proposal distribution is passed in the function together with the pars to pass
  # BetaMH args:  data         - numeric vector of data
  #               N            - number of iterations
  #               x_0          - starting point of our Markov chain   
  # alpha_prior & beta_prior   - parameters of the prior Beta distribution
  #               sigma        - sd of the proposal (Normal) distribution
  
  acc <- 0
  x <- matrix(NA, nrow=n_iter+1, ncol=d)  #matrix (vector if d=1) to store the values of the Markov Chain
  x[1,] <- initial_value                  #store initial value. The first row stores the proposed values.  
  #nr_successes <- sum(data==1)
  #nr_trials <- length(data)
  for (i in seq_len(n_iter)){
    
    # we propose a value sampled from the proposal_distribution with par = prop_par
    #x_proposed <- rnorm(1, mean = x[i], sd = sigma)
    x_proposed = proposal_distribution(d, prop_par)
    
    #when we assume a symmetric proposal distribution the accept. probability reduces to the ratio of target distrbutions
    ratio = target_distribution(x_proposed, data, prior_par, ...)/target_distribution(x[i], data, prior_par, ...)
    #ratio <- dbeta(x_proposed, alpha_prior + nr_successes, beta_prior + nr_trials - nr_successes)/dbeta(x[i], alpha_prior + nr_successes, beta_prior + nr_trials - nr_successes)
    
    # acceptance step
    if(runif(1, 0, 1) < min(c(1, ratio))){
      x[i+1] <- x_proposed
      acc <- acc +1
    } else {
      x[i+1] <- x[i]
    }
    acceptance_ratio = acc/n_iter
  }
  return(list(x=x, accept_ratio=acceptance_ratio))
}
