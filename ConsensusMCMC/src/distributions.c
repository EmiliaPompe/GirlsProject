#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include "utilities.h"

double uniNormalProposalDistribution(double *restrict xP, double *restrict sigmaP){

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

double betaTargetDistribution(double *restrict xP, double *restrict dataP, int *restrict data_lenP, double *restrict alpha_priorP, double *restrict beta_priorP){

  double x, alpha_prior, beta_prior, alpha_post, beta_post, target_val;
  int i, num_successes, data_len;

  static gsl_rng *restrict rP = NULL;

  if(rP == NULL) {  //set up random numbers generator
    gsl_rng_env_setup();
    rP = gsl_rng_alloc(gsl_rng_mt19937);
  }

  num_successes = 0;
  data_len = *data_lenP;
  x = *xP;

  for (i=0; i<data_len; i++){
    if (dataP[i]==1)
      num_successes++;
  }

  alpha_prior = *alpha_priorP;
  beta_prior = *beta_priorP;
  alpha_post = alpha_prior + (double) num_successes;
  beta_post = beta_prior + (double) (data_len-num_successes);

  target_val = gsl_ran_beta_pdf(x, alpha_post, beta_post);
  return(target_val);

}

double normalTargetDistribution(double *restrict xP, double *restrict dataP, int *restrict data_lenP, double *restrict mean_priorP, double *restrict sigma_priorP, double *restrict sigma_knownP){

  double x, mean_prior, sigma_prior, sigma_known, target_val, mean_post, sigma_post, sum_obs;
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

  sum_obs = sum(dataP, data_len);

  mean_post = ((mean_prior/(sigma_prior*sigma_prior))+(sum_obs/(sigma_known*sigma_known)))/((1/(sigma_prior*sigma_prior))+(data_len/(sigma_known*sigma_known)));
  sigma_post = 1/(sqrt((1/(sigma_prior*sigma_prior))+(data_len/(sigma_known*sigma_known))));

  target_val = gsl_ran_gaussian_pdf(x-mean_post, sigma_post);
  return(target_val);

}

double gammaTargetDistribution(double *restrict xP,  int *restrict dataP, int *restrict data_lenP, double *restrict k_priorP, double *restrict theta_priorP){

  double x, k_prior, theta_prior, target_val, k_post, theta_post;
  int data_len;

  static gsl_rng *restrict rP = NULL;

  if(rP == NULL) {  //set up random numbers generator
    gsl_rng_env_setup();
    rP = gsl_rng_alloc(gsl_rng_mt19937);
  }

  x = *xP;
  data_len = *data_lenP;
  k_prior = *k_priorP;
  theta_prior = *theta_priorP;

  k_post = k_prior + (double) sumInt(dataP, data_len);
  theta_post = theta_prior/(((double) data_len*theta_prior)+1.0);

  target_val = gsl_ran_gamma_pdf(x, k_post, theta_post); // we use k and theta instead of a and b
  return(target_val);

}
