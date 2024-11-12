#include  <iostream>
#include <stdio.h>


#define gpuMac(ans) { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, char *file, int line, bool abort=true)
{
    //printf(cudaGetErrorString(code));
   if (code != cudaSuccess)
   {
      fprintf(stderr,"GPUassert: %s %s %d\n", cudaGetErrorString(code), file, line);
      if (abort) exit(code);
   }
}
__global__ void VectorFake(cudaPitchedPtr a, cudaPitchedPtr b, cudaPitchedPtr ret, int count)
{
    if(threadIdx.x == 49 && threadIdx.y == 49 && threadIdx.z == 49)
    {
    }
    return;
}
__global__ void fake(float* b, int count)
{
    b[count - 1] = 0.2f;
}
__global__ void VecAdd(float* A, float* B, float* C, int N)
{
    int i = blockDim.x * blockIdx.x + threadIdx.x;
    if (i < N)
        C[i] = A[i] + B[i];
}
__global__
void add(int n, float *x, float *y)
{
  for (int i = 0; i < n; i++)
    y[i] = x[i] + y[i];
}
extern "C" void callCuda(float*** a, float*** b, float*** ret, int count);

void callCuda(float*** a, float*** b, float*** ret, int count)//=>count is dimesnion of 3d cube
{
    // //assume that the size of a,b, ret are equal to count * count * count


    // //I accidentally deleted this file with a move operation, it will now be simpler and worse

    // cudaExtent extent{count * sizeof(float), count, count};

    // //long allocation process, hope it works lol
    // cudaPitchedPtr cudaA;
    // cudaPitchedPtr cudaB;
    // cudaPitchedPtr cudaRet;
    // cudaMalloc3D(&cudaA, extent);
    // cudaMalloc3D(&cudaB, extent);
    // cudaMalloc3D(&cudaRet, extent);

    // cudaMemcpy3DParms cudaAParms = {0};
    // cudaMemcpy3DParms cudaBParms = {0};

    // cudaAParms.srcPtr = make_cudaPitchedPtr(a, extent.width, extent.depth, extent.height);
    // cudaAParms.dstPtr = cudaA;
    // cudaAParms.extent = extent;
    // cudaAParms.kind = cudaMemcpyHostToDevice;

    // cudaAParms.srcPtr = make_cudaPitchedPtr(b, extent.width, extent.depth, extent.height);
    // cudaAParms.dstPtr = cudaB;
    // cudaAParms.extent = extent;
    // cudaAParms.kind = cudaMemcpyHostToDevice;

    // cudaMemcpy3D(&cudaAParms);
    // cudaMemcpy3D(&cudaBParms);

    // dim3 threadDim(8,8,8);
    // //thread blocks can support a maximum of 1024 threads at once, so the
    // //cube processing has to be constrained to these dimesnions
    // //processing with 8,8,8 as that is maximum even cube within 1024 that is
    // //a multiple of 2


    // dim3 cubeDim((count + threadDim.x - 1)/ threadDim.x, (count + threadDim.y - 1) / threadDim.y, (count + threadDim.z - 1) / threadDim.z);
    // //cuda extent is defined weirldy where the width element is quote:
    // //Width in elements when referring to array memory, in bytes when referring to linear memory
    // //and height and depth are both just refering to elelment count
    // //so width, the first elemenet must be multiplied by the variable size

    // VectorFake<<<cubeDim, threadDim>>>(cudaA, cudaB, cudaRet, count);

    // ret = (float***)cudaRet.ptr;//hopefully this works

    // std::cout << "HI FROM GPU!" << std::endl;

    // float* e;

    // cudaMalloc(&e, sizeof(float) * count);
    // cudaMemcpy(e, a[count - 1][count - 1], sizeof(float) * count, cudaMemcpyHostToDevice);

    // fake<<<1, 1>>>(e, count);

    // cudaDeviceSynchronize();

    // cudaMemcpy(a[count - 1][count - 1], e, sizeof(float)* count, cudaMemcpyDeviceToHost);

    // cudaDeviceSynchronize();

    // std::cout << a[count - 1][count - 1][count - 1] << std::endl;
    // //std::cout << e[0] << std::endl;

    int N = 1<<20;
    float *x, *y;

    cudaDeviceSynchronize();

    // Allocate Unified Memory – accessible from CPU or GPU
    cudaMallocManaged(&x, N*sizeof(float));
    cudaMallocManaged(&y, N*sizeof(float));

    // initialize x and y arrays on the host
    for (int i = 0; i < N; i++) {
        x[i] = 1.0f;
        y[i] = 2.0f;
    }

    // Run kernel on 1M elements on the GPU
    add<<<1, 1>>>(N, x, y);

    // Wait for GPU to finish before accessing on host
    cudaDeviceSynchronize();

    // Check for errors (all values should be 3.0f)
    float maxError = 0.0f;
    for (int i = 0; i < 100; i++)
        maxError = fmax(maxError, fabs(y[i]-3.0f));
    std::cout << "Max error: " << maxError << std::endl;

    // Free memory
    cudaFree(x);
    cudaFree(y);

    return;
}