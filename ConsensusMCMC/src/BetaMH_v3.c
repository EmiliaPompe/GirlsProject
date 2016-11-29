#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include "utilities.h"
#include "distributions_v2.h"

void BetaMH_v3(double *restrict dataP, int *restrict data_lenP, int *restrict nP, double *restrict sigmaP, double *restrict alpha_priorP, double *restrict beta_priorP, int *restrict sP, double *restrict x_0P, double *restrict vec_xP)
{
  
  int n, i;
  double sigma, x, x_proposed, u, acc_prob, alpha_prior, beta_prior, s , prior_ratio, log_lik_difference;
  int acc_count, data_len, num_successes;
  
  static gsl_rng *restrict rP = NULL;
  
  if(rP == NULL) {  //set up random numbers generator
    gsl_rng_env_setup();
    rP = gsl_rng_alloc(gsl_rng_mt19937);
    gsl_rng_set (rP, (unsigned long int) *dataP);
  }
  
  acc_count = 0;
  num_successes = 0;
  data_len = *data_lenP;
  
  for (i=0; i<data_len; i++){
    if (dataP[i]==1)
      num_successes++;
  }
  
  n = *nP;
  sigma = *sigmaP;
  alpha_prior = *alpha_priorP ;
  beta_prior = *beta_priorP ;
  s = (double) *sP;
  data_len = (double) data_len;
  num_successes = (double) num_successes;
  
  x = *x_0P;
  vec_xP[0] = x; // *(myPointer + index) and myPointer[index] are equivalent
  for (i=1; i<n+1; i++)
  {
    x_proposed = x + gsl_ran_gaussian(rP, sigma); // random walk MH
    
    if(x_proposed>=1 || x_proposed <=0){
      acc_prob=0;
    } else{
    prior_ratio = pow((pow(x_proposed, alpha_prior-1)*pow(1-x_proposed, beta_prior-1)/pow(x, alpha_prior-1)*pow(1-x, beta_prior-1)), (1.0/s) );
    printf("prior ratio %lf\n", prior_ratio);
    
    log_lik_difference = num_successes*(log(x_proposed)) + (data_len-num_successes)*log(1-x_proposed) - num_successes*(log(x)) - (data_len-num_successes)*log(1-x);
    printf("log_lik_difference %lf\n", log_lik_difference);
    acc_prob = min(1.0, prior_ratio * exp(log_lik_difference));
    }
    //acc_prob = min(1.0, betaTargetDistribution_v2(&x_proposed, dataP, data_lenP, alpha_priorP, beta_priorP, sP)/betaTargetDistribution_v2(&x, dataP, data_lenP, alpha_priorP, beta_priorP, sP));
    
    u = gsl_ran_flat(rP,0.0,1.0);
    
    if (u < acc_prob)
    {
      x = x_proposed;
      acc_count++;
    }
    
    vec_xP[i] = x;
  }
  printf("Acceptance rate: %lf\n", (float) acc_count/n);
}

