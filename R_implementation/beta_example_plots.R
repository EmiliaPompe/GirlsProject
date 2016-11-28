source("beta_example.R")

# example
observations <- c(1, rep(0, times=999))

n_iter = 100000
burn_in = 0.1*n_iter
sigma = 0.001
result = BetaMH(observations, n_iter, sigma =sigma)
markov_chain = result$x
result$acc/n_iter
plot(burn_in:n_iter, markov_chain[burn_in:n_iter], type="l")
acf(markov_chain)
par(mfrow=c(1,2))
hist(markov_chain[burn_in:n_iter], 50, col='blue')
hist(rbeta((n_iter-burn_in), 2, 1001), 50, col='red')


n_iter = 100000  #with higher value of sigma you need higher number of iterations in order for the hist to look as a Beta
burn_in = 0.1*n_iter
sigma = 1
result = BetaMH(observations, n_iter, sigma = sigma)
markov_chain = result$x
markov_chain_with_burn_in = markov_chain[burn_in:n_iter]

par(mfrow=c(1,2))
hist(markov_chain_with_burn_in, 50, col='blue')
hist(rbeta((n_iter-burn_in), 2, 1000), 50, col='red')

acf(markov_chain[burn_in:n_iter], main='ble2') #the acf will be higher for higher value of sigma


par(mfrow=c(1,3))
plot(density(markov_chain[burn_in:n_iter]), xlim=c(0,0.016))
plot(density(rbeta((n_iter-burn_in), 2, 1000)), col='red', xlim=c(0,0.016))
plot(density(rbeta((n_iter-burn_in), 2, 1001)), col='red', xlim=c(0,0.016))
