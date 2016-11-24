#include <stdlib.h>
#include <omp.h>

void sumSumSq_naive(double *x, double *y, double *sum, double *sumsq, int *sz) {
  *sum = *sumsq = 0.0;
  for(int i=0; i<*sz; ++i) {
    *sum += x[i] - y[i];
    *sumsq += (x[i] - y[i]) * (x[i] - y[i]);
  }
}

void sumSumSq_naive_restrict(double *restrict x, double *restrict y, double *restrict sum, double *restrict sumsq, int *restrict sz) {
  *sum = *sumsq = 0.0;
  for(int i=0; i<*sz; ++i) {
    *sum += x[i] - y[i];
    *sumsq += (x[i] - y[i]) * (x[i] - y[i]);
  }
}

void sumSumSq_naive_restrict_omp(double *restrict x, double *restrict y, double *restrict sum, double *restrict sumsq, int *restrict sz) {
  double s=0.0, ss=0.0;
  
  #pragma omp parallel for reduction(+:s,ss), schedule(static)
  for(int i=0; i<*sz; ++i) {
    s += x[i] - y[i];
    ss += (x[i] - y[i]) * (x[i] - y[i]);
  }
  
  *sum = s;
  *sumsq = ss;
}
