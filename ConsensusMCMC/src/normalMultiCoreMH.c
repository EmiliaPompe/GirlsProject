#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include <omp.h>
#include "utilities.h"
#include "distributions_v2.h"

void NormalMultiCoreMH(double *restrict dataP, int *restrict data_lenP,  int *restrict nP, double *restrict sigmaP, double *restrict mean_priorP, double *restrict sigma_priorP, double *restrict sigma_knownP, int *restrict sP, double *restrict x_0P, double *restrict vec_xP)
{

  int n, i;
  double sigma, x, x_proposed, u, acc_prob, s, sigma_prior, mean_prior, sigma_known, prior_ratio, log_lik_difference;
  int acc_count;
  double v_result_x_proposed[*data_lenP], v_result2_x_proposed[*data_lenP];
  double v_result_x[*data_lenP], v_result2_x[*data_lenP];
  
  static gsl_rng *restrict rP = NULL;
  
  if(rP == NULL) {  //set up random numbers generator
    
    gsl_rng_env_setup();
    rP = gsl_rng_alloc(gsl_rng_mt19937);
    gsl_rng_set (rP, (unsigned long int) *dataP);
  }
  
  acc_count = 0;
  
  n = *nP;
  sigma = *sigmaP;
  sigma_prior = *sigma_priorP;
  mean_prior = *mean_priorP;
  sigma_known = *sigma_knownP;
  s = (double) *sP;
  x = *x_0P;
  vec_xP[0] = x; // *(myPointer + index) and myPointer[index] are equivalent

  for (i=1; i<n+1; i++)
  {

    x_proposed = x + gsl_ran_gaussian(rP, sigma);  // random walk MH
    
    prior_ratio = pow(gsl_ran_gaussian_pdf(x_proposed - mean_prior, sigma_prior)/gsl_ran_gaussian_pdf(x - mean_prior, sigma_prior), (1.0/s)) ;

    subtractConst(dataP, *data_lenP, x_proposed, v_result_x_proposed);
    squareVectElementwise(v_result_x_proposed, *data_lenP, v_result2_x_proposed);
     
    subtractConst(dataP, *data_lenP, x, v_result_x);
    squareVectElementwise(v_result_x, *data_lenP, v_result2_x);

    log_lik_difference = (-1.0) * sum(v_result2_x_proposed, *data_lenP) * (1.0/(2.0*sigma_known*sigma_known)) 
                          + sum(v_result2_x, *data_lenP) * (1.0/(2.0*sigma_known*sigma_known));
     
    
    #pragma omp parallel
                          {
                            printf("Thread number is %i\n", omp_get_thread_num());
                          }
    

    //can go paralel here, calc marginal liklihoods, then recombine with a product
    //back to series, and calculate acceptance

    acc_prob = min(1.0, prior_ratio * exp(log_lik_difference));
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

