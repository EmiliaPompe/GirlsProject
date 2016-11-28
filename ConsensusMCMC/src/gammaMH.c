#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include "utilities.h"
#include "distributions_v2.h"

void gammaMH(int *restrict dataP, int *restrict data_lenP,  int *restrict nP, double *restrict sigmaP, double *restrict k_priorP, double *restrict theta_priorP, int *restrict sP, double *restrict vec_xP)
{
  
  int n, i;
  double sigma, x, x_proposed, u, acc_prob, prior_ratio, log_lik_difference, s;
  int acc_count;
  
  static gsl_rng *restrict rP = NULL;
  
  if(rP == NULL) {  //set up random numbers generator
    gsl_rng_env_setup();
    rP = gsl_rng_alloc(gsl_rng_mt19937);
  }
  
  acc_count = 0;

  n = *nP;
  sigma = *sigmaP;
  k_prior = *k_priorP;
  theta_prior = *theta_priorP;
  data_len = *data_lenP;
  data = *dataP
  s = (double) *sP;
  
  x = 4.0;
  vec_xP[0] = x; // *(myPointer + index) and myPointer[index] are equivalent
  for (i=1; i<n; i++)
  {
    x_proposed = x + gsl_ran_gaussian(rP, sigma);  // random walk MH
    
    prior_ratio = pow((pow(x_proposed, k_prior-1)*exp(-x_proposed/theta_prior))/(pow(x, k_prior-1)*exp(-x/theta_prior)), (1.0/s))
    
    log_lik_difference = (-data_len*x_proposed) + ((log(x_proposed))*sum(data)) + (data_len*x) - ((log(x))*sum(data))
    
    acc_prob = min(1.0, prior_ratio * exp(log_lik_difference));
    
    //acc_prob = min(1.0, gammaTargetDistribution_v2(&x_proposed,  dataP,  data_lenP,  k_priorP, theta_priorP, sP)/gammaTargetDistribution_v2(&x,  dataP,  data_lenP,  k_priorP, theta_priorP, sP));
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

