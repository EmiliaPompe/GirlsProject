#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include "utilities.h"
#include "distributions_v2.h"

void normalMH(double *restrict dataP, int *restrict data_lenP,  int *restrict nP, double *restrict sigmaP, double *restrict mean_priorP, double *restrict sigma_priorP, double *restrict sigma_knownP, int *restrict sP, double *restrict vec_xP)
{
  
  int n, i;
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
  x = 4.0;
  vec_xP[0] = x; // *(myPointer + index) and myPointer[index] are equivalent
  for (i=1; i<n; i++)
  {
    x_proposed = x + gsl_ran_gaussian(rP, sigma);  // random walk MH

    acc_prob = min(1.0, normalTargetDistribution_v2(&x_proposed,  dataP,  data_lenP,  mean_priorP, sigma_priorP, sigma_knownP, sP)/normalTargetDistribution_v2(&x,  dataP,  data_lenP,  mean_priorP, sigma_priorP, sigma_knownP, sP));
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

