library(devtools)
devtools::load_all("ConsensusMCMC")

#################################################################################################################
## Set up parameters for GammaMH
#################################################################################################################

observations <- rpois(10000, 4)
nr_servers <- 4
shards <- split(observations, rep(seq_len(nr_servers),each=length(observations)/nr_servers))

n_iter = 10000
burn_in = 0.1*n_iter
sigma = 0.01  # sigma for the proposal distribution
k_prior=1
theta_prior=4
x_0 = 0

#################################################################################################################
## Run in paralell
#################################################################################################################

clust <- makePSOCKcluster(names = c("greywagtail",
                                    "greyheron",
                                    "greypartridge",
                                    "greyplover"))

clusterEvalQ(cl = clust, devtools::load_all("~/Workspace/GirlsProject/ConsensusMCMC"))

lambda <- clusterApplyLB(clust, shards, GammaMH, n=n_iter, sigma=sigma, k_prior=k_prior, theta_prior=theta_prior, s=nr_servers, x_0 = x_0)

stopCluster(clust)

df = data.frame(lapply(lambda, function(y) y))
colnames(df) <- paste0('x', seq_len(nr_servers))


#################################################################################################################
## Aggregate across machines
#################################################################################################################

parallel_markov_chain = weightsComputation(df, method = "sample variance")

#################################################################################################################
## Run on single machine and smaple from theoretuical posterior for comparison
#################################################################################################################

single_markov_chain = GammaMH(observations, n_iter, sigma = sigma, k_prior=k_prior, theta_prior=theta_prior, s=1, x_0 = x_0 ) 

theoretical_distribution = rgamma(n_iter, shape = k_prior+sum(observations), scale = theta_prior/(theta_prior*length(observations)+1))


#################################################################################################################
## Plot results
#################################################################################################################

our_theme <-  theme(
  axis.text = element_text(size = 12),
  #legend.key = element_rect(fill = "navy"),s
  #legend.background = element_rect(fill = "white"),
  #legend.position = c(0.14, 0.80),
  strip.text =element_text(size=14),
  legend.text =element_text(size=14),
  title = element_text(size=14),
  plot.title = element_text(hjust=0.5))

par(mfrow=c(1,1))
p = HistPlot(list(single_markov_chain, parallel_markov_chain, theoretical_distribution), 
             method = c("1 machine", "4 machines", "theoretical"), burn_in = 0.3, 
             size_line = 1, ggtitle("Histograms for the Gamma-Poisson example"))

ggsave("plots_presentation/hist_gamma.pdf", p +  our_theme)


p = QQPlot(single_markov_chain[burn_in:n_iter], parallel_markov_chain[burn_in:n_iter], 
           line = TRUE, size_point = 2, size_line =1, ggtitle("QQplot for the Gamma-Poisson example"), 
           xlab("Single Markov chain"), ylab("Parallel Markov chain"))
p+our_theme
ggsave("plots_presentation/qqplot_gamma.pdf", p +  our_theme)

p = TracePlot(list(single_markov_chain, parallel_markov_chain), 
              method = c('Single machine', '4 machines'),  
              burn_in=0.3,
              size_line = 1,
              ggtitle("Trace plot for the Gamma-Poisson example"))

ggsave("plots_presentation/traceplot_gamma.pdf", p +  our_theme)


p1 = ACFPlot(single_markov_chain, lag.max = 10, 
             ggtitle("Single Markov chain")) + our_theme

p2 = ACFPlot(parallel_markov_chain, lag.max = 10, 
             ggtitle("Parallel Markov chain")) + our_theme

p3 = grid.arrange(p1, p2, ncol = 2)
ggsave("plots_presentation/acf_gamma.pdf", p3)


