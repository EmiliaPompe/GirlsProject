library(devtools)
devtools::load_all("ConsensusMCMC")

time_start = Sys.time()

############################################################################
#  Generate data and specify params
############################################################################
sigma_known = 1.0
nr_observations = 30000
observations <- rnorm(nr_observations, 3, sigma_known)

n_iter = 100000
burn_in = 0.3
sigma = 0.01
mean_prior=0.0
sigma_prior=1.0
x_0 = 0

############################################################################
#  Split data into shards and run on 4 machines
############################################################################

nr_servers <- 4
shards <- split(observations, rep(seq_len(nr_servers),each=length(observations)/nr_servers))

clust <- makePSOCKcluster(names = c("greywagtail",
                                    "greyheron",
                                    "greypartridge",
                                    "greyplover"))

clusterEvalQ(cl = clust, devtools::load_all("~/Workspace/GirlsProject/ConsensusMCMC/"))

lambda <- clusterApplyLB(clust, shards, NormalMultiCoreMH, multicore=1, num_cores= 8, n=n_iter, sigma=sigma, mean_prior=mean_prior, sigma_prior=sigma_prior, sigma_known=sigma_known, s= nr_servers, x_0 = x_0)

stopCluster(clust)

df = data.frame(lapply(lambda, function(y) y))
colnames(df) <- paste0('x', seq_len(nr_servers))

#  Combine results
#df$mean = rowMeans(df)
parallel_chain = weightsComputation(df, method="constant")

############################################################################
#  Run on a single machine
############################################################################

nr_servers <- 1
shards <- split(observations, rep(seq_len(nr_servers),each=length(observations)/nr_servers))

clust <- makePSOCKcluster(names = c("greywagtail"))
clusterEvalQ(cl = clust, devtools::load_all("~/Workspace/GirlsProject/ConsensusMCMC/"))
lambda <- clusterApplyLB(clust, shards, NormalMultiCoreMH, multicore=1, num_cores= 8, n=n_iter, sigma=sigma, mean_prior=mean_prior, sigma_prior=sigma_prior, sigma_known=sigma_known, s= nr_servers, x_0 = x_0)
stopCluster(clust)

df = data.frame(lapply(lambda, function(y) y))
colnames(df) <- paste0('x', seq_len(nr_servers))
single_chain = df$x

#single_chain = NormalMultiCoreMH(multicore=1, data=observations, n = n_iter, sigma = sigma, mean_prior=mean_prior, sigma_prior=sigma_prior, sigma_known=sigma_known, s=1, x_0 = x_0) #are these args right TODO

############################################################################
#  Plot and compare to theory
############################################################################

mean_post = (mean_prior/sigma_prior^2 + sum(observations)/sigma_known^2)/(1/sigma_prior^2 + length(observations)/sigma_known^2)
sigma_post = sqrt(1/(1/sigma_prior^2 + length(observations)/sigma_known^2))
theoretical = rnorm(10000, mean_post, sigma_post)

#HistPlot(list(single_chain, parallel_chain, theoretical), method = c("1 machine, multicore", "4 machines, multicore", "Theoretical"), burn_in = burn_in)
#TracePlot(list(single_chain, parallel_chain), method = c('single machine', '4 machines'),  burn_in=0.3)


our_theme <-  theme(
  axis.text = element_text(size = 12),
  #legend.key = element_rect(fill = "navy"),s
  #legend.background = element_rect(fill = "white"),
  #legend.position = c(0.14, 0.80),
  strip.text =element_text(size=14),
  legend.text =element_text(size=14),
  title = element_text(size=14))

par(mfrow=c(1,1))
p = HistPlot(list(single_chain, parallel_chain, theoretical), 
             method = c("1 machine, multicore", "4 machines, multicore", "Theoretical"), burn_in = 0.3, 
             size_line = 1, ggtitle("Histograms for the Normal-Normal \nexample, multicore"))

ggsave("plots_presentation/hist_normal_multicore.pdf", p +  our_theme)


p = QQPlot(single_chain[burn_in:n_iter], parallel_chain[burn_in:n_iter], 
           line = TRUE, size_point = 2, size_line =1, ggtitle("QQplot for the Normal-Normal example, multicore"), 
           xlab("Single Markov chain"), ylab("Parallel Markov chain"))
p+our_theme
ggsave("plots_presentation/qqplot_normal_multicore.pdf", p +  our_theme)

p = TracePlot(list(single_chain, parallel_chain), 
              method = c('Single machine, multicore', '4 machines, multicore'),  
              burn_in=0.3,
              size_line = 1,
              ggtitle("Trace plot for the Normal-Normal example, multicore"))

ggsave("plots_presentation/traceplot_normal_multicore.pdf", p +  our_theme)


p1 = ACFPlot(single_chain, lag.max = 10, 
             ggtitle("Single Markov chain, multicore")) + our_theme

p2 = ACFPlot(parallel_chain, lag.max = 10, 
             ggtitle("Parallel Markov chain, multicore")) + our_theme

p3 = grid.arrange(p1, p2, ncol = 2)
ggsave("plots_presentation/acf_normal_multicore.pdf", p3)

