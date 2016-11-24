export void sumSumSq_ispc(uniform double x[], uniform double y[], uniform double sum[], uniform double sumsq[], uniform int sz[]) {
  *sum = *sumsq = 0.0;
  double s = 0.0, ss = 0.0;
  foreach(i=0 ... *sz) {
    s += x[i] - y[i];
    ss += (x[i] - y[i]) * (x[i] - y[i]);
  }
  *sum = reduce_add(s);
  *sumsq = reduce_add(ss);
}
