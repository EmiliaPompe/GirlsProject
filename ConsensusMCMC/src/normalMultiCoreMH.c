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
  
  int n, i, num_cores, k, remainder;
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
    
    // //split the data
    num_cores = 8;
    omp_set_num_threads(num_cores);  // 8 local machine. OxWaSP servers have 48 so can change this when on multiple machines
    //printf("%d\n", omp_get_max_threads( ));   // To check what's available
    
    
    remainder = *data_lenP % num_cores; // the amount of data remaining if split data equally across cores
    k = (*data_lenP - remainder) / num_cores; // how much data on each core (the last will take remainder)
    printf("Remainder %i\n", remainder);

    #pragma omp parallel 
      {
        int thread_data_len;
        double *thread_dataP, thread_log_lik_difference;
        int thread_num = omp_get_thread_num();
        thread_dataP = dataP + thread_num*k;

        // Initialise arrays to store liklihood calc intermediary results
        double thread_result1[thread_data_len], thread_result2[thread_data_len];
        double thread_result3[thread_data_len], thread_result4[thread_data_len];

        if (thread_num == num_cores-1)
        {
          printf("Here");
          thread_data_len = k+remainder; //put the extra data on the last thread
        } else {
          thread_data_len = k;
        }

        subtractConst(thread_dataP, thread_data_len, x_proposed, thread_result1);
        squareVectElementwise(thread_result1, thread_data_len, thread_result2);

        subtractConst(thread_dataP, thread_data_len, x, thread_result3);
        squareVectElementwise(thread_result3, thread_data_len, thread_result4);
        
        thread_log_lik_difference = (-1.0) * sum(thread_result2, *data_lenP) * (1.0/(2.0*sigma_known*sigma_known)) 
        + sum(thread_result4, *data_lenP) * (1.0/(2.0*sigma_known*sigma_known));

       // printf("Core index: %i thread_data_len: %i Log lik diff: %lf\n", thread_num, thread_data_len, thread_log_lik_difference);

        if (thread_num == 7){
          for (int i = 0; i < thread_data_len; i++)
            {
              printf("%lf\n", thread_dataP[i]);
            }
        }
       

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
  //printf("Acceptance rate: %lf\n", (float) (acc_count)/n);
}
