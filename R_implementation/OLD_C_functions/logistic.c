#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include "utilities.h"
#include "distributions_v2.h"

void logisticRegressionMH(double *restrict dataP, int *restrict data_lenP,  double *restrict sigmaP, double *restrict mean_priorP, double *restrict sigma_priorP, int *restrict sP, double *restrict matrix_xP) // here we have matrix_x instead of vec
{

  int n, i;
  double sigma, x, x_proposed, u, acc_prob, s, sigma_prior, mean_prior,  prior_ratio, log_lik_difference;
  int acc_count;
  double z[4,3] = {{1,0,2}, // z keeps our fake data (matrix)
                   {1,0,1},
                   {1,1,0},
                   {1,0,1}};

  static gsl_rng *restrict rP = NULL;

  if(rP == NULL) {  //set up random numbers generator
    gsl_rng_env_setup();
    rP = gsl_rng_alloc(gsl_rng_mt19937);
  }

  acc_count = 0;

  n = *nP;
  //sigma = *sigmaP;
  sigma_prior = *sigma_priorP;
  mean_prior = *mean_priorP;

  s = (double) *sP;
  x = 4.0;
  vec_xP[0] = x; // *(myPointer + index) and myPointer[index] are equivalent
  for (i=1; i<n; i++)
  {
    //x_proposed = x + gsl_ran_gaussian(rP, sigma);  // random walk MH
     gsl_ran_multivariate_gaussian (const gsl_rng * r, const gsl_vector * mu, const gsl_matrix * L, gsl_vector * result); //remember about cholesky factorization

    prior_ratio = pow(gsl_ran_multivariate_gaussian_pdf (const gsl_vector * x, const gsl_vector * mu, const gsl_matrix * L, double * result, gsl_vector * work)(x_proposed - mean_prior, sigma_prior)/gsl_ran_gaussian_pdf(x - mean_prior, sigma_prior), (1.0/s)) ;
    //can go paralel here, calc marginal liklihoods, then recombine with a product
    //change log_lik completely; remember about the dpt product gsl_blas_sdsdot
    log_lik_difference = sum(squareVectElementwise(subtractConst(dataP, *data_lenP, x_proposed), *data_lenP), *data_lenP)* (-1.0/(sigma_known*sigma_known)) - sum(squareVectElementwise(subtractConst(dataP, *data_lenP, x),*data_lenP), *data_lenP)* (-1.0/(sigma_known*sigma_known));
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

