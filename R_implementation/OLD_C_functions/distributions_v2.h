#ifndef DISTRIBUTIONS_V2_H
#define DISTRIBUTIONS_V2_H
double gammaTargetDistribution_v2(double *restrict xP,  int *restrict dataP, int *restrict data_lenP, double *restrict k_priorP, double *restrict theta_priorP, int *restrict sP);
double normalTargetDistribution_v2(double *restrict xP, double *restrict dataP, int *restrict data_lenP, double *restrict mean_priorP, double *restrict sigma_priorP, double *restrict sigma_knownP, int *restrict sP);
double betaTargetDistribution_v2(double *restrict xP, double *restrict dataP, int *restrict data_lenP, double *restrict alpha_priorP, double *restrict beta_priorP, int *restrict sP);
#endif
