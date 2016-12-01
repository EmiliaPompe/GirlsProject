library(devtools)
devtools::load_all("ConsensusMCMC")

############################################################################
#  Generate data and specify params
############################################################################

sigma_known = 1
observations <- rnorm(10000, 3 , sigma_known)
nr_servers <- 4
shards <- split(observations, rep(seq_len(nr_servers),each=length(observations)/nr_servers))

n_iter = 10000
burn_in = 0.1*n_iter
sigma = 0.01  # sigma for the proposal distribution
mean_prior=0
sigma_prior=1.0
x_0 = -5

############################################################################
#  Split data into shards and run on 4 machines
############################################################################

clust <- makePSOCKcluster(names = c("greywagtail",
                                    "greyheron",
                                    "greypartridge",
                                    "greyplover"))

clusterEvalQ(cl = clust, devtools::load_all("~/Workspace/GirlsProject/ConsensusMCMC/"))

lambda <- clusterApplyLB(clust, shards, NormalMH, n=n_iter, sigma=sigma, mean_prior=mean_prior, sigma_prior=sigma_prior, sigma_known=sigma_known, s= nr_servers, x_0 = x_0)

stopCluster(clust)

df = data.frame(lapply(lambda, function(y) y))
colnames(df) <- paste0('x', seq_len(nr_servers))

parallel_markov_chain = weightsComputation(df, method = "sample variance")

############################################################################
#  Run on a single machine
############################################################################

single_markov_chain = NormalMH(observations, n = n_iter, sigma = sigma, mean_prior=mean_prior, sigma_prior=sigma_prior, sigma_known=sigma_known, s=4, x_0 = x_0) 

theoretical_distribution = rnorm(n_iter,
                          mean = (mean_prior/sigma_prior^2 + sum(observations)/sigma_known^2)/(1/sigma_prior^2 + length(observations)/sigma_known^2),
                          sd = sqrt(1/(1/sigma_prior^2 + length(observations)/sigma_known^2)))


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
             size_line = 1, ggtitle("Histograms for the Normal-Normal example"))

ggsave("plots_presentation/hist_normal.pdf", p +  our_theme)


p = QQPlot(single_markov_chain[burn_in:n_iter], parallel_markov_chain[burn_in:n_iter], 
           line = TRUE, size_point = 2, size_line =1, ggtitle("QQplot for the Normal-Normal example"), 
           xlab("Single Markov chain"), ylab("Parallel Markov chain"))
p+our_theme
ggsave("plots_presentation/qqplot_normal.pdf", p +  our_theme)

p = TracePlot(list(single_markov_chain, parallel_markov_chain), 
              method = c('Single machine', '4 machines'),  
              burn_in=0.3,
              size_line = 1,
              ggtitle("Trace plot for the Normal-Normal example"))

ggsave("plots_presentation/traceplot_normal.pdf", p +  our_theme)


p1 = ACFPlot(single_markov_chain, lag.max = 10, 
             ggtitle("Single Markov chain")) + our_theme

p2 = ACFPlot(parallel_markov_chain, lag.max = 10, 
             ggtitle("Parallel Markov chain")) + our_theme

p3 = grid.arrange(p1, p2, ncol = 2)
ggsave("plots_presentation/acf_normal.pdf", p3)
