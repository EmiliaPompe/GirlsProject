
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