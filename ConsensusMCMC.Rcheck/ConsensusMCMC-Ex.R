pkgname <- "ConsensusMCMC"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('ConsensusMCMC')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
cleanEx()
nameEx("ACFPlot")
### * ACFPlot

flush(stderr()); flush(stdout())

### Name: ACFPlot
### Title: Plot for the autocorrelation function of a given Markov chain.
### Aliases: ACFPlot

### ** Examples

# Generate two sets of values
chain = rnorm(100)

# Produce the plot
ACFPlot(chain, ggtitle('acf'))




cleanEx()
nameEx("BetaMH")
### * BetaMH

flush(stderr()); flush(stdout())

### Name: BetaMH
### Title: MH-Algorithm for a Univariate Beta target distribution.
### Aliases: BetaMH

### ** Examples

# Generate data
observations = rbinom(10000, size = 1, prob = 0.5)

# Set the parameters for the function
nr_servers = 1 
n_iter = 1000
burn_in = 0.1*n_iter
sigma = 0.01
alpha_prior = 1.0
beta_prior = 1.0
x_0 = 0.1


# Run the function for the chosen parameters
markov_chain = NormalMH(observations,
               n_iter = n_iter,
               sigma = sigma, 
               alpha_prior = alpha_prior, 
               beta_prior = beta_prior, 
               s = 1, 
               x_0 = x_0)




cleanEx()
nameEx("GammaMH")
### * GammaMH

flush(stderr()); flush(stdout())

### Name: GammaMH
### Title: MH-Algorithm for a Univariate Gamma target distribution.
### Aliases: GammaMH

### ** Examples

# Generate data
observations = rpois(10000, 4)

# Set the parameters for the function
nr_servers = 1 
n_iter = 100000
burn_in = 0.1*n_iter
sigma = 0.01
k_prior = 1.0
theta_prior = 4.0
x_0 = 4

# Run the function for the chosen parameters
markov_chain = GammaMH(observations, 
                       n_iter = n_iter, 
                       sigma = sigma, 
                       k_prior = k_prior, 
                       theta_prior = theta_prior, 
                       s = 1, 
                       x_0 = x_0) 





cleanEx()
nameEx("HistPlot")
### * HistPlot

flush(stderr()); flush(stdout())

### Name: HistPlot
### Title: Density estimates of the histograms for a list of Markov chains.
### Aliases: HistPlot

### ** Examples

# Generate two sets of values
chain1 = rnorm(100)
chain2 = rnorm(100)

# Produce the density plots
HistPlot(list(chain1, chain2), 
         method = c('Single machine', 'Multiple machines'), 
         burn_in = 0.2, 
         size_line = 2)




cleanEx()
nameEx("NormalMH")
### * NormalMH

flush(stderr()); flush(stdout())

### Name: NormalMH
### Title: MH-Algorithm for a Univariate Normal target distribution.
### Aliases: NormalMH

### ** Examples

# Generate data
observations = rnorm(10000, 1 , sigma_known)

# Set the parameters for the function
sigma_known = 1
nr_servers = 1 
n_iter = 1000
burn_in = 0.1*n_iter
sigma = 0.01
mean_prior = 0.0
sigma_prior = 1.0
x_0 = 0.0

# Run the function for the chosen parameters
markov_chain = NormalMH(observations, 
               n = n_iter, 
               sigma = sigma, 
               mean_prior = mean_prior, 
               sigma_prior = sigma_prior, 
               sigma_known = sigma_known, 
               s = nr_servers, 
               x_0 = x_0) 





cleanEx()
nameEx("QQPlot")
### * QQPlot

flush(stderr()); flush(stdout())

### Name: QQPlot
### Title: QQPlot for two Markov chains.
### Aliases: QQPlot

### ** Examples

# Generate two sets of values
chain1=rnorm(100)
chain2=rnorm(100)

# Produce the qqplot
QQPlot(chain1=rnorm(100), chain2=rnorm(100))




cleanEx()
nameEx("TracePlot")
### * TracePlot

flush(stderr()); flush(stdout())

### Name: TracePlot
### Title: Trace plots for a list of Markov chains.
### Aliases: TracePlot

### ** Examples

# Generate two sets of values
chain1 = rnorm(100)
chain2 = rnorm(100)

# Produce the trace plots
TracePlot(list(chain1, chain2), 
         method = c('Single machine', 'Multiple machines'), 
         burn_in = 0.2)




cleanEx()
nameEx("gslrng")
### * gslrng

flush(stderr()); flush(stdout())

### Name: gslrng
### Title: Random number generation
### Aliases: gslrng

### ** Examples

gslrng(5)
gslrng(20)



cleanEx()
nameEx("weightsComputation")
### * weightsComputation

flush(stderr()); flush(stdout())

### Name: weightsComputation
### Title: Weights computation for Consensus MCMC algorithm
### Aliases: weightsComputation

### ** Examples


df = data.frame(lapply(lambda, function(y) y))
parallel_markov_chain = weightsComputation(df, method = "sample variance")




### * <FOOTER>
###
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
