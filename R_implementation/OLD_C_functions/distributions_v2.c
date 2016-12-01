#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include "utilities.h"

double uniNormalProposalDistribution_v2(double *restrict xP, double *restrict sigmaP){
  
  double x, sigma, prop_val;
  
  static gsl_rng *restrict rP = NULL;
  
  if(rP == NULL) {  //set up random numbers generator
    gsl_rng_env_setup();
    rP = gsl_rng_alloc(gsl_rng_mt19937);
  }
  
  x = *xP;
  sigma = *sigmaP;
  
  prop_val = x + gsl_ran_gaussian(rP, sigma);
  
  return(prop_val);
}

double betaTargetDistribution_v2(double *restrict xP, double *restrict dataP, int *restrict data_lenP, double *restrict alpha_priorP, double *restrict beta_priorP, int *restrict sP){
  
  double x, alpha_prior, beta_prior, alpha_post, beta_post, target_val, s;
  int i, num_successes, data_len;
  
  static gsl_rng *restrict rP = NULL;
  
  if(rP == NULL) {  //set up random numbers generator
    gsl_rng_env_setup();
    rP = gsl_rng_alloc(gsl_rng_mt19937);
  }
  
  num_successes = 0;
  data_len = *data_lenP;
  x = *xP;
  s = (double) *sP;
  
  for (i=0; i<data_len; i++){
    if (dataP[i]==1)
      num_successes++;
  }
  
  alpha_prior = *alpha_priorP;
  beta_prior = *beta_priorP;
  alpha_post = (alpha_prior - 1.0)/s + 1.0 + (double) num_successes;
  beta_post = (beta_prior - 1.0)/s + 1.0 + (double) (data_len-num_successes);
  
  target_val = gsl_ran_beta_pdf(x, alpha_post, beta_post);
  return(target_val);
  
}

double normalTargetDistribution_v2(double *restrict xP, double *restrict dataP, int *restrict data_lenP, double *restrict mean_priorP, double *restrict sigma_priorP, double *restrict sigma_knownP, int *restrict sP){
  
  double x, mean_prior, sigma_prior, sigma_known, target_val, mean_post, sigma_post, sum_obs, s, shard_sigma_prior;
  int data_len;
  
  static gsl_rng *restrict rP = NULL;
  
  if(rP == NULL) {  //set up random numbers generator
    gsl_rng_env_setup();
    rP = gsl_rng_alloc(gsl_rng_mt19937);
  }
  
  x = *xP;
  data_len = *data_lenP;
  sigma_known = *sigma_knownP;
  mean_prior = *mean_priorP;
  sigma_prior = *sigma_priorP;
  s = (double) *sP;
  
  sum_obs = sum(dataP, data_len);
  
  shard_sigma_prior = sigma_prior*sqrt(s);
    
  mean_post = ((mean_prior/(shard_sigma_prior*shard_sigma_prior))+(sum_obs/(sigma_known*sigma_known)))/((1/(shard_sigma_prior*shard_sigma_prior))+(data_len/(sigma_known*sigma_known)));
  sigma_post = 1/(sqrt((1/(shard_sigma_prior*shard_sigma_prior))+(data_len/(sigma_known*sigma_known))));
  
  target_val = gsl_ran_gaussian_pdf(x-mean_post, sigma_post);
  return(target_val);
  
}

double gammaTargetDistribution_v2(double *restrict xP,  int *restrict dataP, int *restrict data_lenP, double *restrict k_priorP, double *restrict theta_priorP, int *restrict sP){
  
  double x, k_prior, theta_prior, target_val, k_post, theta_post, s;
  int data_len;
  
  static gsl_rng *restrict rP = NULL;
  
  if(rP == NULL) {  //set up random numbers generator
    gsl_rng_env_setup();
    rP = gsl_rng_alloc(gsl_rng_mt19937);
  }
  
  x = *xP;
  s = (double) *sP;
  data_len = *data_lenP;
  k_prior = *k_priorP;
  theta_prior = *theta_priorP;
  
  k_post = ((k_prior - 1.0)/ s) + ((double) sumInt(dataP, data_len)) + 1.0;
  theta_post = (s*theta_prior)/(((double) data_len*theta_prior*s) + 1.0);
  
  target_val = gsl_ran_gamma_pdf(x, k_post, theta_post); // we use k and theta instead of a and b
  return(target_val);
  
}
