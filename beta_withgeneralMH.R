
observations <- c(1, rep(0, times=999))

beta_example = MH(observations, d = 1, n_iter = 1000, initial_value=0.1, prior_par = c(1,1), 
                  proposal_distribution = UNInormal_proposal_distribution, 
                  prop_par = c(1,sigma = 0.001),  
                  target_distribution = beta_target_distribution)
