__global__ void VecAddGPU(float* a, float* b, float* c) {
  int k = blockIdx.x * blockDim.x + threadIdx.x;
  c[k] = a[k] + b[k];
}

extern "C" {
  #include <stdio.h>
  
  void VecAdd(float* a, float* b, float* c, int* n) {
    if((*n)%20 != 0) {
      printf("This toy example requires the vector length to be a multiple of 20.\n");
      return;
    }

    float *a_GPU, *b_GPU, *c_GPU;

    cudaMalloc(&a_GPU, *n*sizeof(float));
    cudaMalloc(&b_GPU, *n*sizeof(float));
    cudaMalloc(&c_GPU, *n*sizeof(float));

    cudaMemcpy(a_GPU, a, *n*sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(b_GPU, b, *n*sizeof(float), cudaMemcpyHostToDevice);

    VecAddGPU<<<20,(*n)/20>>>(a_GPU, b_GPU, c_GPU);
    cudaThreadSynchronize();

    cudaMemcpy(c, c_GPU, *n*sizeof(float), cudaMemcpyDeviceToHost);

    cudaFree(a_GPU);
    cudaFree(b_GPU);
    cudaFree(c_GPU);
  }
}
