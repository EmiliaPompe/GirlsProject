#include <cblas.h>

void matmul(double *A, double *B, int *rA, int *cArB, int *cB, double *res) {
  cblas_dgemm(CblasColMajor, CblasNoTrans, CblasNoTrans, *rA, *cB, *cArB, 1.0, A, *rA, B, *cArB, 0.0, res, *rA);
}
