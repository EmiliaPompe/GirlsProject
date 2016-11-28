#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include "utilities.h"
#include "distributions.h"

void gammaMH(int *restrict dataP, int *restrict data_lenP,  int *restrict nP, double *restrict sigmaP, double *restrict k_priorP, double *restrict theta_priorP, double *restrict vec_xP)
{
  
  long n, i;
  double sigma, x, x_proposed, u, acc_prob;
  int acc_count;
  
  static gsl_rng *restrict rP = NULL;
  
  if(rP == NULL) {  //set up random numbers generator
    gsl_rng_env_setup();
    rP = gsl_rng_alloc(gsl_rng_mt19937);
  }
  
  acc_count = 0;

  n = *nP;
  sigma = *sigmaP;
  x = 5.0;
  vec_xP[0] = x; // *(myPointer + index) and myPointer[index] are equivalent
  for (i=1; i<n; i++)
  {
    x_proposed = x + gsl_ran_gaussian(rP, sigma);  // random walk MH
    acc_prob = min(1.0, gammaTargetDistribution(&x_proposed,  dataP,  data_lenP,  k_priorP, theta_priorP)/gammaTargetDistribution(&x,  dataP,  data_lenP,  k_priorP, theta_priorP));
    
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

