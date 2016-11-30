library(devtools)
devtools::load_all("ConsensusMCMC")

beta_coefficients = c(-3, 1.2, -0.5, 0.8, 3)
z = rbind(matrix(rep(c(1,0,0,1,0), 2755), nrow = 2755, byrow=TRUE),
         matrix(rep(c(1,0,0,0,0), 2753), nrow = 2753, byrow=TRUE),
         matrix(rep(c(1,0,1,0,0), 1186), nrow = 1186, byrow=TRUE),
         matrix(rep(c(1,1,0,1,0), 717), nrow = 717, byrow=TRUE),
         matrix(rep(c(1,0,1,1,0), 1173), nrow = 1173, byrow=TRUE),
         matrix(rep(c(1,1,1,0,0), 305), nrow = 305, byrow=TRUE),
         matrix(rep(c(1,1,1,1,0), 301), nrow = 301, byrow=TRUE),
         matrix(rep(c(1,1,0,0,0), 706), nrow = 706, byrow=TRUE),
         matrix(rep(c(1,0,1,1,1), 17), nrow = 17, byrow=TRUE),
         matrix(rep(c(1,0,1,1,1), 17), nrow = 17, byrow=TRUE),
         matrix(rep(c(1,0,0,1,1), 24), nrow = 24, byrow=TRUE),
         matrix(rep(c(1,1,0,1,1), 10), nrow = 10, byrow=TRUE),
         matrix(rep(c(1,1,1,0,1), 2), nrow = 2, byrow=TRUE),
         matrix(rep(c(1,0,1,0,1), 13), nrow = 13, byrow=TRUE),
         matrix(rep(c(1,1,1,1,1), 2), nrow = 2, byrow=TRUE),
         matrix(rep(c(1,1,0,0,1), 4), nrow = 4, byrow=TRUE))


v = LogisticMH()
chain = matrix(v, nrow=11, ncol=2, byrow=TRUE)

LogisticMH <- function(data, z, n_iter, sigma, sigma_prior, mean_prior, s, x_0)