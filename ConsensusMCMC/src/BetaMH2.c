#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include "min.h"

void BetaMH_v2( int *restrict dataP, int *restrict data_lenP, int *restrict nP, double *restrict sigmaP, double *restrict alpha_priorP, double *restrict beta_priorP, double *restrict vec_xP)
{
  static gsl_rng *restrict rP = NULL;
  
  if(rP == NULL) {  //set up random numbers generator
    gsl_rng_env_setup();
    rP = gsl_rng_alloc(gsl_rng_mt19937);
  }
  
  long n, i;
  double sigma, x, x_proposed, u, acc_prob, alpha_post, beta_post, alpha_prior, beta_prior, denom;
  int acc_count, num_successes, data_len;
  
  acc_count = 0;
  num_successes = 0;
  data_len = *data_lenP;
  
  for (i=0; i<data_len; i++){
    if (dataP[i]==1)
      num_successes++;
  }
  
  alpha_prior = *alpha_priorP;
  beta_prior = *beta_priorP;
  alpha_post = alpha_prior + (double) num_successes;
  beta_post = beta_prior + (double) (data_len-num_successes);
  printf("%lf/n", beta_post);
  
  n = *nP;
  sigma = *sigmaP;
  x = 0.1;
  vec_xP[0] = x; // *(myPointer + index) and myPointer[index] are equivalent
  for (i=1; i<n; i++)
  {
    x_proposed = x + gsl_ran_gaussian(rP, sigma);
    denom = gsl_ran_beta_pdf(x, alpha_post, beta_post);
    if (denom != 0)
    {
      acc_prob = min(1.0, gsl_ran_beta_pdf(x_proposed, alpha_post, beta_post)/denom);
    }
    else{
      acc_prob = 0;
      printf("Divide by zero");
    }
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

