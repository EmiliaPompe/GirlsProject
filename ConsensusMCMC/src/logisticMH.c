#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include <cblas.h>
#include "utilities.h"
#include <sys/time.h>

void LogisticMH(int *restrict dataP, double *restrict zP, int *restrict data_lenP, int *restrict ncolP, int *restrict n_iterP, double *restrict sigmaP, double *restrict sigma_priorP, double *restrict mean_priorP, int *restrict sP, double *restrict x_0P, double *restrict vec_xP)
{
  // They will be arguments of the function in the future (or rather pointers to them)
  //int data_len =5;
  //int ncol = 2;
  //double sigma[2], sigma_prior[2], mean_prior[2], x[2];
  //int data[5] = {1,0,1,0,0};
  //double sigma[2] = {0.1, 0.15}; //diagonal elements of the matrix Sigma for MH algorithm
  //double mean_prior[2] = {0.0, 0.0};
  //double sigma_prior[2] = {1.0,  0.1};// diagonal elements of the matrix Sigma_prior
  //double s =1.0; //nr of servers  TO DO: change it later to int
  //int n_iter = 10; // nr of iterations
  //double result; // TO DO now set (result will be a matrix)
  //double x[2] = {1.0,0.5}; //initial value
  //double vec_xP[ncol*(n_iter+1)]; // here we store our anser - a very long vector, then we create a matrix out of it

  int data_len = *data_lenP;
  int ncol = *ncolP;
  int n_iter = *n_iterP;
  double s = *sP;
  
  //They will not be arguments
  double u, acc_prob, prior_ratio, log_lik_difference, dot_prod_x_proposed, dot_prod_x;
  double x_proposed[ncol], x[ncol], result_divide_x_proposed[ncol], result_divide_x[ncol], result_subtract_x_proposed[ncol], result_subtract_x[ncol];
  double *aux_zP; // created in order to move along z
  int acc_count=0;

  //double z[10] = {1.0,0.5, // Z keeps our fake data (matrix)
  //                          1.0,0.0,
  //                          1.0,1.0,
  //                          1.0,0.0,
  //                          1.0,0.1};

  static gsl_rng *restrict rP = NULL;
  
  if(rP == NULL) {  //set up random numbers generator

    time_t epoch_time;
    epoch_time = time( NULL );

    struct timeval tv;
    gettimeofday(&tv,NULL);

    gsl_rng_env_setup();
    rP = gsl_rng_alloc(gsl_rng_mt19937);
    gsl_rng_set (rP, (unsigned long int) 1000000*tv.tv_sec+tv.tv_usec);
  }

 // an example how to do dot product
 //double try1[3] = {1.0,2.0, 3.0};
 //double try2[3] = {1.0,2.0, 5.0};
 //double result2;
 //result2 = cblas_ddot(3, try1, 1, try2,1);
 //printf("dot product %lf\n", result2);


  for(int j=0; j<ncol; j++){  //store the first ncol initial values
    x[j]=x_0P[j];
    vec_xP[j] = x[j]; 
  }  
  
  for (int i=1; i<=n_iter; i++)  //MCMC loop
    {
       
       for(int j=0; j<ncol; j++){
          x_proposed[j] = x[j] + gsl_ran_gaussian(rP, sigmaP[j]);  // random walk MH
         }
    
       //subract the mean and divide by sigma prior
       subVectElementwise(x_proposed, mean_priorP, ncol, result_subtract_x_proposed);
       subVectElementwise(x, mean_priorP, ncol, result_subtract_x);
       
       divideVectElementwise(result_subtract_x_proposed, sigma_priorP, ncol, result_divide_x_proposed);
       divideVectElementwise(result_subtract_x, sigma_priorP, ncol, result_divide_x);
       
       prior_ratio = pow(exp(-0.5*cblas_ddot(ncol,result_divide_x_proposed , 1, result_divide_x_proposed,1) + 0.5*cblas_ddot(ncol,result_divide_x , 1, result_divide_x,1)), (1.0/s)) ;
       
       log_lik_difference = 0.0; // we set log_lik_sum to 0 before each iteration
       aux_zP = zP;
       
       for(int j=0; j<data_len; j++){
         
         dot_prod_x_proposed = cblas_ddot(ncol, aux_zP , 1, x_proposed, 1);
         dot_prod_x = cblas_ddot(ncol, aux_zP , 1, x, 1);
         
         if(dataP[j]==1){ // when a success in data
           log_lik_difference +=  - log(1.0 + exp(-dot_prod_x_proposed)) + log(1.0 + exp(-dot_prod_x));
         } else {    // when a failure in data
           log_lik_difference += log(exp(-dot_prod_x_proposed)/(1.0 + exp(-dot_prod_x_proposed))) - log(exp(-dot_prod_x)/(1.0 + exp(-dot_prod_x)));
         }
         
         aux_zP += ncol;
       }
       
      
       acc_prob = min(1.0, prior_ratio * exp(log_lik_difference));
       u = gsl_ran_flat(rP,0.0,1.0);
        if (u < acc_prob)
        {
          for(int j=0; j<ncol; j++){
             x[j] = x_proposed[j];
            }  
         acc_count++;
        }
        
        for(int j=0; j<ncol; j++){
          vec_xP[i*ncol+j] = x[j];
        }  
  }
  printf("Acceptance rate: %lf\n", (float) acc_count/n_iter);
}

