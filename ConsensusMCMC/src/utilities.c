
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


void subtractConst(double *v, int length_v, double constant, double *v_result)
{
  //double v_result[length_v];
  
  for (int i=0; i<length_v; i++){
    v_result[i] = v[i] - constant;
  }
}

void squareVectElementwise(double *v, int length_v, double *v_result)
{
  //double v_result[length_v];

  for (int i=0; i<length_v; i++){
     v_result[i] = v[i] * v[i];
  }

}

//#include <stdio.h>
//
//int main(void)
//{
//  double vect[6] = {1.0,2.0,4.0,0.6,9.0,5.0};
//  //resultP = sum(squareVectElementwise(subtractConst(vect, 6, 3.0), 6),6);
//  double vresP[6];
//  double vresP2[6];
//
//  subtractConst(vect, 6, 3.0, vresP);
// squareVectElementwise(vresP, 6, vresP2);
//
//
//
//  for (int i = 0; i < 6; i++)
//  {
//    printf("%lf\n", vresP2[i]); 
//  }
//  
//  return 0;
//}
