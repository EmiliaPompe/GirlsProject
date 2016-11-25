#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>

void rng(int *restrict n, double *restrict res) {
  static gsl_rng *restrict r = NULL;
  
  if(r == NULL) { // First call to this function, setup RNG
    gsl_rng_env_setup();
    r = gsl_rng_alloc(gsl_rng_mt19937);
  }
  
  for(size_t i=0; i<*n; ++i) {
    res[i] = gsl_rng_uniform(r);
  }
}

double min(double a, double b)
{
  if (a < b)
    return(a);
  else
    return(b);   
}

void BetaMH(long *restrict nP, double *restrict sigmaP, double *restrict alpha_priorP, double *restrict beta_priorP, double *restrict vec_xP)
{
  static gsl_rng *restrict rP = NULL;
  
  if(rP == NULL) { // First call to this function, setup RNG
    gsl_rng_env_setup();
    rP = gsl_rng_alloc(gsl_rng_mt19937);
  }
  
  long n, i;
  double sigma, x, x_proposed, u, acc_prob, alpha_post, beta_post, alpha_prior, beta_prior;
  int num_successes = 1, num_failures = 9;
  
  alpha_prior = *alpha_priorP;
  beta_prior = *beta_priorP;
  alpha_post = alpha_prior + (double) num_successes;
  beta_post = beta_prior + (double) num_failures;

  n = *nP;
  sigma = *sigmaP;
  x = 0.1;
  vec_xP[0] = x; // *(myPointer + index) and myPointer[index] are equivalent
  for (i=1; i<n; i++)
  {
    x_proposed = x + gsl_ran_gaussian(rP, sigma);
    acc_prob = min(1.0, gsl_ran_beta_pdf(x_proposed, alpha_post, beta_post)/gsl_ran_beta_pdf(x, alpha_post, beta_post));
    u = gsl_ran_flat(rP,0.0,1.0);
    
    if (u < acc_prob)
    {
      x = x_proposed;
    }
      
    vec_xP[i] = x;
  }
}