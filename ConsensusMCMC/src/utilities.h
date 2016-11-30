#ifndef UTILITIES_H
#define UTILITIES_H
double min(double a, double b);
double sum(double *v, int length_v);
int sumInt(int *v, int length_v);
void subtractConst(double *v, int length_v, double constant, double *v_result);
void squareVectElementwise(double *v, int length_v, double *v_result);
void divideVectElementwise(double *v, double *x, int length_v, double *result);
void subVectElementwise(double *v, double *x, int length_v, double *result);
#endif
