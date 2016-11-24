#install.packages("MASS")
library("MASS")

#####################################################################################
# Proposal distributions
#####################################################################################

# when using the beta proposal distribution par need a vector with 2 values
# 1_value : value of alpha 
# 2_value : value of beta
beta_proposal_distribution = function(par){
  rbeta(n = 1, shape1 = par[1], shape2 = par[2])
}

# when using the Univariate Normal par need a vector with 2 values
# 1_value : value of the mean 
# 2_value : value of the sd
UNInormal_proposal_distribution = function(par){
  rnorm(n = 1, mean=par[1], sd=par[2])
}

# when using the Multivariate Normal proposal par need to be a list with 
# $1: a vector of dim = d giving the means of the variables that is passed to mu
# $2: a symmetric matrix dim = d*d specifying the covariance matrix of the variables that is passed to Sigma
MULTInormal_proposal_distribution = function(par){  
  mvrnorm(n = 1, mu=par[[1]], Sigma=par[[2]])
} 


#####################################################################################
# Target distributions
#####################################################################################


# beta posterior distribution (= target distribution) for a beta prior distribution and Bernoulli lik
# prior_par: vector listing alpha prior and beta prior 
beta_target_distribution = function(x, data, prior_par){
  nr_successes <- sum(data==1)
  nr_trials <- length(data)
  alpha_prior = prior_par[1]
  beta_prior  = prior_par[2]
  dbeta(x, alpha_prior + nr_successes, beta_prior + nr_trials - nr_successes)
}


# Univariate normal posterior distribution (= target distribution) for a univariate normal prior distribution and Normal lik
# prior_par: the mean(1) and the sd(2) for the prior distrbution of the unknown par (mean)
# know_par:  the known value of sigma (we assume the covariance to be unknown)
UNInormal_target_distribution = function(x, data, prior_par, know_par){
  post_mean = ((prior_par[1]/(prior_par[2]^2))+(sum(data)/know_par))/((1/(prior_par[2]^2))+(n/(know_par^2)))
  post_var = 1/((1/(prior_par[2]^2))+((length(data))/(know_par^2)))
  dnorm(x, post_mean, post_var)
}


# Multivariate normal posterior distribution (= target distribution) for a multivariate normal prior distribution and Normal lik
# prior_par: is a list with the following elements
#            - $1: a vector of dim = d giving the prior mean values of the variables
#            - $2: a symmetric matrix dim = d*d specifying the prior covariance matrix of the variables 
# know_par:  the known value of the covariance matrix (dim = d*d) 
MULTInormal_target_distribution = function(x, data, prior_par, know_par){
  post_mean = (solve(solve(prior_par[[2]])+n*solve(know_par)))*(prior_par[[1]]*solve(prior_par[[2]])+n*solve(know_par)*(mean(data)))
  post_var =  solve(solve(prior_par[[2]])+n*solve(know_par))
  dnorm(x, post_mean, post_var)
}


