#include <gsl/gsl_rng.h>

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
