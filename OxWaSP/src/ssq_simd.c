#include <stdlib.h>
#include <immintrin.h>

// THIS WILL SEGFAULT WHEN CALLED FROM R ... DO YOU KNOW WHY?!?
void sumSumSq_SIMD(double *restrict x, double *restrict y, double *restrict sum, double *restrict sumsq, int *restrict sz) {
  __m256d *xV, *yV, tV, sumV, sumSqV;
  xV = (__m256d*) x;
  yV = (__m256d*) y;
  sumV = _mm256_set_pd(0.0, 0.0, 0.0, 0.0);
  sumSqV = _mm256_set_pd(0.0, 0.0, 0.0, 0.0);
  
  for(int i=0; i<(*sz)/4; ++i) {
    tV = _mm256_sub_pd(xV[i], yV[i]);
    sumV = _mm256_add_pd(sumV, tV);
    sumSqV = _mm256_add_pd(sumSqV, _mm256_mul_pd(tV, tV));
  }
  
  double t1[]={0.0,0.0,0.0,0.0};
  _mm256_store_pd(t1, sumV);
  *sum = t1[0]+t1[1]+t1[2]+t1[3];
  
  double t2[]={0.0,0.0,0.0,0.0};
  _mm256_store_pd(t2, sumSqV);
  *sumsq = t2[0]+t2[1]+t2[2]+t2[3];
}

// THIS WILL SEGFAULT WHEN CALLED FROM R ... DO YOU KNOW WHY?!?
void sumSumSq_SIMD_omp(double *restrict x, double *restrict y, double *restrict sum, double *restrict sumsq, int *restrict sz) {
  double sum2=0.0, sumsq2=0.0;
  
  __m256d *xV, *yV;
  xV = (__m256d*) x;
  yV = (__m256d*) y;
  #pragma omp parallel reduction(+:sum2, sumsq2)
  {
    double t[]={0.0,0.0,0.0,0.0};
    __m256d tV, sumV, sumSqV;
    sumV = _mm256_set_pd(0.0, 0.0, 0.0, 0.0);
    sumSqV = _mm256_set_pd(0.0, 0.0, 0.0, 0.0);
    #pragma omp for schedule(static)
    for(int i=0; i<(*sz)/4; ++i) {
      tV = _mm256_sub_pd(xV[i], yV[i]);
      sumV = _mm256_add_pd(sumV, tV);
      sumSqV = _mm256_add_pd(sumSqV, _mm256_mul_pd(tV, tV));
    }
    _mm256_store_pd(t, sumV);
    sum2 = t[0]+t[1]+t[2]+t[3];
    _mm256_store_pd(t, sumSqV);
    sumsq2 = t[0]+t[1]+t[2]+t[3];
  }
  *sum = sum2;
  *sumsq = sumsq2;
}
