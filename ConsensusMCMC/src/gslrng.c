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

void metropolis_hastings(long *nP, double *alphaP, double *vec_x)
{
  static gsl_rng *restrict r = NULL;
  
  if(r == NULL) { // First call to this function, setup RNG
    gsl_rng_env_setup();
    r = gsl_rng_alloc(gsl_rng_mt19937);
  }
  
  long n,i;
  double alpha, x, x_proposed, u, acc_prob;

  n = *nP;
  alpha = *alphaP;
  x = 0.0;
  vec_x[0] = x;
  for (i=1; i<n; i++)
  {
    x_proposed = x + gsl_ran_flat(r,-alpha,alpha);
    acc_prob = min(1.0, gsl_ran_ugaussian_pdf(x_proposed)/gsl_ran_ugaussian_pdf(x));
    u = gsl_ran_flat(r,0.0,1.0);
    if (u < acc_prob)
      x = x_proposed;
    vec_x[i] = x;
  }
}