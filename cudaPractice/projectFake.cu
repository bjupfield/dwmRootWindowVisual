#include <iostream>
#include <cuda.h>
#include "cuda_runtime.h"

using namespace std;

#define gpuErrchk(ans) { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, const char *file, int line, bool abort=true)
{
   if (code != cudaSuccess) 
   {
      fprintf(stderr,"GPUassert: %s %s %d\n", cudaGetErrorString(code), file, line);
      if (abort) exit(code);
   }
}
__global__ void AddInts(int* a, int*b)
{
    a[0] += b[0];
}
int main()
{
    int a = 5;
    int b = 9;

    int *d_a, *d_b;

    cudaMalloc(&d_a, sizeof(int));
    cudaMalloc(&d_b, sizeof(int));

    cudaMemcpy(d_a, &a, sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, &b, sizeof(int), cudaMemcpyHostToDevice);

    AddInts<<<1, 1>>>(d_a, d_b);

    gpuErrchk(cudaPeekAtLastError());

    cudaMemcpy(&a, d_a, sizeof(int), cudaMemcpyDeviceToHost);

    cudaDeviceSynchronize();

    cout << "The answer is " << a << endl;

    cudaFree(d_a);
    cudaFree(d_b);

    return 0;
}