library(devtools)
devtools::load_all("ConsensusMCMC")


set.seed(15)
# load our data frame
load('logistic_data_frame.RData')
#################################################################################################################
## Set parameters
#################################################################################################################

sigma = c(0.1, 0.1, 0.1, 0.1, 0.1)           #covariance matrix for the proposal distribution. Need to be of dimension ncol
sigma_prior = c(1,1,1,1,1)                   #covariance prior for beta coefficients dimension nrow(z)
mean_prior = c(-2, 0.5, 0, 0.5, 2)           #mean prior for beta coefficients dimension nrow(z)
x_0 = c(-3.5,1.7,-0.2,0.5,3.5)               #initial values for the parameters of interest (beta)
nr_servers = 4                    
n_iter = 10000
burn_in = 0.2

############################################################################
#  Split data into shards and run on 4 machines
############################################################################

shards <- split(sample(1:nrow(logistic_data_frame),nrow(logistic_data_frame), replace = FALSE),
                rep(seq_len(nr_servers),times = nrow(logistic_data_frame)/nr_servers))

shards = lapply(shards, function(x) logistic_data_frame[x,])

clust <- makePSOCKcluster(names = c("greywagtail",
                                    "greyheron",
                                    "greypartridge",
                                    "greyplover"))

clusterEvalQ(cl = clust, devtools::load_all("~/Workspace/GirlsProject/ConsensusMCMC/"))

lambda <- clusterApplyLB(clust, shards, LogisticMH, n_iter=n_iter, sigma=sigma, mean_prior=mean_prior, sigma_prior=sigma_prior, s= nr_servers, x_0 = x_0)

stopCluster(clust)


#  Combine results
parallel_chain = weightsMultivariateComputation(lambda, method="sample variance")


############################################################################
#  Run on a single machine
############################################################################

nr_servers <- 1

clust2 <- makePSOCKcluster(names = c("greywagtail"))
clusterEvalQ(cl = clust2, devtools::load_all("~/Workspace/GirlsProject/ConsensusMCMC/"))
lambda <- clusterApplyLB(clust2, list(logistic_data_frame), LogisticMH, n_iter=n_iter, sigma=sigma, mean_prior=mean_prior, sigma_prior=sigma_prior, s= 1, x_0 = x_0)
stopCluster(clust)

df = data.frame(lapply(lambda, function(y) y))
#colnames(df) <- paste0('x', seq_len(nr_servers))
single_chain = df[ ,1]


#################################################################################################################
## Plot results OLD
#################################################################################################################

par(mfrow=c(1,1))
HistPlot(list(single_chain, parallel_chain[,1]), 
         method = c("1 machine", "4 machines"), burn_in = 0.3)

QQPlot(single_chain[burn_in:n_iter], parallel_chain[,1][burn_in:n_iter], line = TRUE)

TracePlot(list(single_chain, parallel_chain[,1]), method = c('single machine', '4 machines'),  burn_in=0.3)

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


p = HistPlot(list(single_chain, parallel_chain[,1]), 
             method = c("1 machine", "4 machines"), burn_in = 0.3, 
             size_line = 1, ggtitle("Histograms for the logistic \nregression example"))

ggsave("plots_presentation/hist_logistic.pdf", p +  our_theme)


p = QQPlot(single_chain[burn_in:n_iter], parallel_chain[,1][burn_in:n_iter], 
           line = TRUE, size_point = 2, size_line =1, ggtitle("QQplot for the logistic regression example"), 
           xlab("Single Markov chain"), ylab("Parallel Markov chain"))
p+our_theme
ggsave("plots_presentation/qqplot_logistic.pdf", p +  our_theme)

p = TracePlot(list(single_chain, parallel_chain[,1]), 
              method = c('Single machine', '4 machines'),  
              burn_in=0.3,
              size_line = 1,
              ggtitle("Trace plot for the logistic \nregression example"))

ggsave("plots_presentation/traceplot_logistic.pdf", p +  our_theme)


p1 = ACFPlot(single_chain, lag.max = 10, 
             ggtitle("Single")) + our_theme

p2 = ACFPlot(parallel_chain[,1], lag.max = 10, 
             ggtitle("Parallel")) + our_theme

p3 = grid.arrange(p1, p2, ncol = 2)
ggsave("plots_presentation/acf_logistic.pdf", p3)



