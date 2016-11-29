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
  double sigma, x, x_proposed, u, acc_prob, s, sigma_prior, mean_prior, sigma_known, prior_ratio, log_lik_difference;
  int acc_count;
  
  static gsl_rng *restrict rP = NULL;
  
  if(rP == NULL) {  //set up random numbers generator
    gsl_rng_env_setup();
    rP = gsl_rng_alloc(gsl_rng_mt19937);
  }
  
  acc_count = 0;
  
  n = *nP;
  sigma = *sigmaP;
  sigma_prior = *sigma_priorP;
  mean_prior = *mean_priorP;
  sigma_known = *sigma_knownP;
  s = (double) *sP;
  x = 0.0;
  vec_xP[0] = x; // *(myPointer + index) and myPointer[index] are equivalent



  for (i=0; i<n; i++)
  {


    x_proposed = x + gsl_ran_gaussian(rP, sigma);  // random walk MH
    
   


    prior_ratio = pow(gsl_ran_gaussian_pdf(x_proposed - mean_prior, sigma_prior)/gsl_ran_gaussian_pdf(x - mean_prior, sigma_prior), (1.0/s)) ;
    printf("%lf prior ratios\n", prior_ratio);

     for (int j = 0; j < *data_lenP; ++j)
    {
      printf("Data 1: %lf\n", dataP[j]);

    }

    //can go paralel here, calc marginal liklihoods, then recombine with a product
    log_lik_difference = -1.0 * sum(squareVectElementwise(subtractConst(dataP, *data_lenP, x_proposed), *data_lenP), *data_lenP) * (1.0/(2.0*sigma_known*sigma_known)) 
                        + sum(squareVectElementwise(subtractConst(dataP, *data_lenP, x),*data_lenP), *data_lenP)* (1.0/(2.0*sigma_known*sigma_known));


    for (int j = 0; j < *data_lenP; ++j)
    {
      printf("Data 2: %lf\n", dataP[j]);

    }

    // for (int i = 0; i < *data_lenP; ++i)
    // {
    //   printf("Data: %lf\n", dataP[i]);

    // }
    
    // printf("%lf\n", sum(squareVectElementwise(subtractConst(dataP, *data_lenP, x_proposed), *data_lenP), *data_lenP) );
    // printf("%lf x proposed\n", x_proposed);
    // printf("%lf log lik diff\n", log_lik_difference);

    //back to series, and calculate acceptance
    acc_prob = min(1.0, prior_ratio * exp(log_lik_difference));
    //acc_prob = min(1.0, normalTargetDistribution_v2(&x_proposed,  dataP,  data_lenP,  mean_priorP, sigma_priorP, sigma_knownP, sP)/normalTargetDistribution_v2(&x,  dataP,  data_lenP,  mean_priorP, sigma_priorP, sigma_knownP, sP));
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

