
BetaMH <- function(observations, N = 1000, x_0 = 0.1, alpha_prior = 1, beta_prior = 1, sigma = 0.1){
  # BetaMH is an implementation of an M-H algorithm for the Beta - Bernoulli model
  # the posterior (target distribution) is Beta(alpha_prior + nr_successes, beta_prior + nr_trials)
  # the proposal distribution is normal with sd = sigma#
  # BetaMH args:  observations - numeric vector of observations
  #               N            - number of iterations
  #               x_0          - starting point of our Markov chain   
  # alpha_prior & beta_prior   - parameters of the prior Beta distribution
  #               sigma        - sd of the proposal (Normal) distribution
  
  acc <- 0
  x <- vector("numeric", N+1)  #vector to store the values of the Markov Chain
  x[1] <- x_0                  #store initial value
  nr_successes <- sum(observations==1)
  nr_trials <- length(observations)
  for (i in seq_len(N)){
    # we propose a value sampled from the Normal distribution with mean x[i] and sd = sigma
    x_proposed <- rnorm(1, mean = x[i], sd = sigma)
    
    # TO DO make sure that the ratio below is correct
    #if((x_proposed > 0) & (x_proposed <1)){
    #ratio  <-  (x_proposed/x[i])^(alpha_prior - 1 + nr_success)*((1-x_proposed)/(1-x[i]))^(beta_prior - 1 + nr_trials)
    ratio <- dbeta(x_proposed, alpha_prior + nr_successes, beta_prior + nr_trials - nr_successes)/dbeta(x[i], alpha_prior + nr_successes, beta_prior + nr_trials - nr_successes)
    #} else {
     # ratio <- 0
    #}
    # acceptance step
    if(runif(1, 0, 1) < min(c(1, ratio))){
      x[i+1] <- x_proposed
      acc <- acc +1
    } else {
      x[i+1] <- x[i]
    }
  }
  return(list(x=x, acc=acc))
}
