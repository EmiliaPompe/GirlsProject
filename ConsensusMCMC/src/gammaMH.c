#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include "utilities.h"
#include <sys/time.h>


void gammaMH(int *restrict dataP, int *restrict data_lenP,  int *restrict nP, double *restrict sigmaP, double *restrict k_priorP, double *restrict theta_priorP, int *restrict sP, int *restrict x_0P, double *restrict vec_xP)
{
  
  int n, i;
  double sigma, x, x_proposed, u, acc_prob, prior_ratio, log_lik_difference, theta_prior, k_prior, s;
  int acc_count, data_len;
  
  static gsl_rng *restrict rP = NULL;
  
  if(rP == NULL) {  //set up random numbers generator

    struct timeval tv;
    gettimeofday(&tv,NULL);

    gsl_rng_env_setup();
    rP = gsl_rng_alloc(gsl_rng_mt19937);
    gsl_rng_set (rP, (unsigned long int) 1000000*tv.tv_sec+tv.tv_usec);
  }
  
  acc_count = 0;

  n = *nP;
  sigma = *sigmaP;
  k_prior = *k_priorP;
  theta_prior = *theta_priorP;
  data_len = (double) *data_lenP;
  s = (double) *sP;
  x = *x_0P;
  
  vec_xP[0] = x; // *(myPointer + index) and myPointer[index] are equivalent
  for (i=1; i<n+1; i++)
  {
    x_proposed = x + gsl_ran_gaussian(rP, sigma);  // random walk MH
    
    if(x_proposed <=0){
      acc_prob=0;
    } else {
    prior_ratio = pow((pow(x_proposed, k_prior-1)*exp(-x_proposed/theta_prior))/(pow(x, k_prior-1)*exp(-x/theta_prior)), (1.0/s));
    
    log_lik_difference = (-data_len*x_proposed) + ((log(x_proposed))* ((double) sumInt(dataP, data_len))) + (data_len*x) - ((log(x))*((double)sumInt(dataP, data_len)));
    
    acc_prob = min(1.0, prior_ratio * exp(log_lik_difference));
    }
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

