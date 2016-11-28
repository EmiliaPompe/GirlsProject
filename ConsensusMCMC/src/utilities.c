
double min(double a, double b)
{
  if (a < b)
    return(a);
  else
    return(b);   
}


double sum(double *v, int length_v)
{
  int i;
  double sum_val=0.0; 
  
  for (i=0; i<length_v; i++){
    sum_val += v[i];
  }
  return(sum_val);
}

int sumInt(int *v, int length_v){
  
  int i, sum_val=0;
  for (i=0; i<length_v; i++){
    sum_val += v[i];
  }
  return(sum_val);
  
}


double * subtractConst(double *v, int length_v, double constant)
{
  int i;
  
  for (i=0; i<length_v; i++){
    v[i] -= constant;
  }
  return(v);
}

double * squareVectElementwise(double *v, int length_v)
{
  int i;
  
  for (i=0; i<length_v; i++){
    v[i] = v[i]*v[i];
  }
  return(v);
}


