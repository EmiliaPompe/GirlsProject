#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include <cblas.h>


int main(void) // here we have matrix_x instead of vec
{


  // They will be arguments of the function in the future (or rather pointers to them)
  int data[5] = {1,0,1,0,0};
  int data_len =5;
  double sigma_matrix[4] = {1.0,0.0,0.0,1.0}; //for MH algorithm
  double mean_prior[2] = {0.0, 0.0};
  double sigma_prior[4] = {1.0, 0.0, 0.0, 1.0};
  double s =1.0; //nr of servers  TO DO: change it later to int
  int n = 10; // nr of iterations
  double result; // TO DO now set (result will be a matrix)
  double x_0[2] = {1.0,0.5};
 
  
  //They will not be arguments
  int i;
  double sigma, x, x_proposed, u, acc_prob,   prior_ratio, log_lik_difference;  
  int acc_count=0;
   
  x=0.0;
  
  
  double z[10] = {1.0,0.5, // z keeps our fake data (matrix)
                  1.0,0.0,
                  1.0,1.0,
                  1.0,0.0,
                  1.0,0.1};

  static gsl_rng *restrict rP = NULL;

  if(rP == NULL) {  //set up random numbers generator
    gsl_rng_env_setup();
    rP = gsl_rng_alloc(gsl_rng_mt19937); // TO DO: set seed
  }

 
 double try1[3] = {1.0,2.0, 3.0};
 double try2[3] = {1.0,2.0, 5.0}; 
 double result2;
 result2 = cblas_ddot(3, try1, 1, try2,1);
 printf("dot product %lf\n", result2);


  //vec_xP[0] = x; // *(myPointer + index) and myPointer[index] are equivalent
  //for (i=1; i<n; i++)
  //{
    //x_proposed = x + gsl_ran_gaussian(rP, sigma);  // random walk MH
     //gsl_ran_multivariate_gaussian (const gsl_rng * r, const gsl_vector * mu, const gsl_matrix * L, gsl_vector * result); //remember about cholesky factorization

   // prior_ratio = pow(gsl_ran_multivariate_gaussian_pdf (const gsl_vector * x, const gsl_vector * mu, const gsl_matrix * L, double * result, gsl_vector * work)(x_proposed - mean_prior, sigma_prior)/gsl_ran_gaussian_pdf(x - mean_prior, sigma_prior), (1.0/s)) ;
    //can go paralel here, calc marginal liklihoods, then recombine with a product
    //change log_lik completely; remember about the dpt product gsl_blas_sdsdot
    //log_lik_difference = sum(squareVectElementwise(subtractConst(dataP, *data_lenP, x_proposed), *data_lenP), *data_lenP)* (-1.0/(sigma_known*sigma_known)) - sum(squareVectElementwise(subtractConst(dataP, *data_lenP, x),*data_lenP), *data_lenP)* (-1.0/(sigma_known*sigma_known));
    //back to series, and calculate acceptance
    //acc_prob = min(1.0, prior_ratio * exp(log_lik_difference));
    //acc_prob = min(1.0, normalTargetDistribution_v2(&x_proposed,  dataP,  data_lenP,  mean_priorP, sigma_priorP, sigma_knownP, sP)/normalTargetDistribution_v2(&x,  dataP,  data_lenP,  mean_priorP, sigma_priorP, sigma_knownP, sP));
    //u = gsl_ran_flat(rP,0.0,1.0);
    //if (u < acc_prob)
    //{
      //x = x_proposed;
      //acc_count++;
    //}

    //vec_xP[i] = x;
  //}
  //printf("Acceptance rate: %lf\n", (float) acc_count/n);
  return(0);
}

