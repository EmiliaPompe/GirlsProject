
MHAlgo <- function(observations, N = 1000, x_0 = 0.1, alpha_prior = 1, beta_prior = 1, sigma=0.2){
  # MHalgo is an implementation of an M-H algorithm for the Beta - Bernoulli model
  # the posterior (target distribution) is Beta(alpha_prior + nr_successes, beta_prior + nr_trials)
  # the proposal distribution is normal with sd = sigma
  
  # MHAlgo args: observations - numeric vector of observations
  #               N           - number of iterations
  #               x_0         - starting point of our Markov chain   
  # alpha_prior & beta_prior  - parameters of the prior Beta distribution
  #               sigma       - sd of the proposal (Normal) distribution
  
  x <- vector("numeric", N+1)
  x[1] <- x_0
  nr_success <- sum(observations==1)
  nr_trials <- length(observations)
  for (i in seq_len(N)){
    # we propose a value sampled from the Normal distribution with mean x[i] and sd = sigma
    x_proposed <- rnorm(1, mean = x[i], sd = sigma)
    
    # TO DO make sure that the ratio below is correct
    if((x_proposed > 0) & (x_proposed <1)){
      ratio = (x_proposed/x[i])^(alpha_prior - 1 + nr_success)*((1-x_proposed)/(1-x[i]))^(beta_prior - 1 + nr_trials)
    } else {
      ratio=0
    }
    # acceptance step
    if(runif(1, 0, 1) < min(c(1, ratio))){
      x[i+1] <- x_proposed
    } else {
      x[i+1] <- x[i]
    }
  }
  return(x)
}

# example
observations <- c(1, rep(0, times=999))
markov_chain <- MHAlgo(observations, 10000)
plot(1000:10000, markov_chain[1000:10000], type='line')
hist(markov_chain[1000:10000], 50, col='blue')
hist(rbeta(9000, 2, 1001), 50, col='red', alpha=0.9, add=TRUE)

markov_chain <- MHAlgo(observations, 10000, sigma = 0.6)
hist(markov_chain[1000:10000], 50, col='blue')
hist(rbeta(9000, 2, 1001), 50, col='red', alpha=0.9, add=TRUE)



