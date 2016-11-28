#ifndef DISTRIBUTIONS_H
#define DISTRIBUTIONS_H
double betaTargetDistribution(double *restrict xP, double *restrict dataP, int *restrict data_lenP, double *restrict alpha_priorP, double *restrict beta_priorP);
double gammaTargetDistribution(double *restrict xP, int *restrict dataP, int *restrict data_lenP, double *restrict k_priorP, double *restrict theta_priorP);
#endif
