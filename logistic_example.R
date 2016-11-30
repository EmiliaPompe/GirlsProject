library(devtools)
devtools::load_all("ConsensusMCMC")

#beta_coefficients = c(-3, 1.2, -0.5, 0.8, 3) #true bete parameters
z = rbind(matrix(rep(c(1,0,0,1,0), 2755), nrow = 2755, byrow=TRUE),
         matrix(rep(c(1,0,0,0,0), 2753), nrow = 2753, byrow=TRUE),
         matrix(rep(c(1,0,1,0,0), 1186), nrow = 1186, byrow=TRUE),
         matrix(rep(c(1,1,0,1,0), 717), nrow = 717, byrow=TRUE),
         matrix(rep(c(1,0,1,1,0), 1173), nrow = 1173, byrow=TRUE),
         matrix(rep(c(1,1,1,0,0), 305), nrow = 305, byrow=TRUE),
         matrix(rep(c(1,1,1,1,0), 301), nrow = 301, byrow=TRUE),
         matrix(rep(c(1,1,0,0,0), 706), nrow = 706, byrow=TRUE),
         matrix(rep(c(1,0,0,0,1), 32), nrow = 32, byrow=TRUE),
         matrix(rep(c(1,0,1,1,1), 17), nrow = 17, byrow=TRUE),
         matrix(rep(c(1,0,0,1,1), 24), nrow = 24, byrow=TRUE),
         matrix(rep(c(1,1,0,1,1), 10), nrow = 10, byrow=TRUE),
         matrix(rep(c(1,1,1,0,1), 2), nrow = 2, byrow=TRUE),
         matrix(rep(c(1,0,1,0,1), 13), nrow = 13, byrow=TRUE),
         matrix(rep(c(1,1,1,1,1), 2), nrow = 2, byrow=TRUE),
         matrix(rep(c(1,1,0,0,1), 4), nrow = 4, byrow=TRUE))
y = c(rep(1, times=266),
         rep(0, times=2755-266),
         rep(1, times=116), 
         rep(0, times=2753 - 116),
         rep(1, times=34), 
         rep(0, times=1186-34),
         rep(1, times=190), 
         rep(0, times=717-190),
         rep(1, times=61), 
         rep(0, times=1173-61),
         rep(1, times = 37), 
         rep(0, times = 305-37),
         rep(1, times=68), 
         rep(0, times=301-68),
         rep(1, 119), 
         rep(0, 706-119),
         rep(1, 18), 
         rep(0, 32-18),
         rep(1, 13), 
         rep(0,4),
         rep(1, 18),
         rep(0,6),
         rep(1, 8),
         rep(0, 2),
         rep(1,2),
         rep(1,7), 
         rep(0, 6),
         rep(1,2),
         rep(1,3), 
         rep(0,1))
sigma = c(0.3, 0.1, 0.1, 0.1, 0.1) #covariance matrix for the proposal distribution. Need to be of dimension ncol
sigma_prior = c(10,10,10,10,10)         #covariance prior for beta coefficients dimension nrow(z)
mean_prior = c(-2, 0.5, 0, 0.5, 2) #mean prior for beta coefficients dimension nrow(z)
x_0 = c(-3.5,1.7,-0.2,0.5,3.5)                 #initial values for the parameters of interest (beta)
s = 1                              #number of servers
n_iter = 10000
burn_in = 0

#v = LogisticMH()
#chain = matrix(v, nrow=11, ncol=2, byrow=TRUE)
chain = LogisticMH(y, z, n_iter=n_iter, sigma=sigma, sigma_prior=sigma_prior, mean_prior=mean_prior, s=s, x_0=x_0)
chain_matrix <- matrix(chain, ncol=ncol(z), byrow=TRUE)

#z_data <- as.data.frame(z)
#z_data$y <- as.factor(y)
#mle = glm(y~., family=binomial(link='logit'), data = z_data)
#summary(mle)

#################################################################################################################
## Plot results
#################################################################################################################


TracePlot(list(chain_matrix[,2]), method = NULL, burn_in = 0.1)
HistPlot(list(chain_matrix[,2]))
  
  