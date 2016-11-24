source("beta_example.R")

# example
observations <- c(1, rep(0, times=999))

n_iter = 10000
result <- BetaMH(observations, n_iter, sigma =0.001)
markov_chain <- result$x
result$acc/n_iter
plot(1000:10000, markov_chain[1000:10000], type="l")
acf(markov_chain)
hist(markov_chain[1000:10000], 50, col='blue')
hist(rbeta(9000, 2, 1001), 50, col='red', alpha=0.9, add=TRUE)

n_iter = 1000
burn_in = 0.1*n_iter
result <- BetaMH(observations, n_iter, sigma = 1)
markov_chain = result$x
markov_chain_with_burn_in = markov_chain[burn_in:n_iter]

par(mfrow=c(1,2))
hist(markov_chain_with_burn_in, 50, col='blue')
hist(rbeta(90000, 2, 1000), 50, col='red')

acf(markov_chain[10000:1000000], main='ble2')

par(mfrow=c(1,3))
plot(density(markov_chain[10000:100000]), xlim=c(0,0.016))
plot(density(rbeta(90000, 2, 1000)), col='red', add=TRUE, xlim=c(0,0.016))
plot(density(rbeta(90000, 2, 1001)), col='red', add=TRUE, xlim=c(0,0.016))
