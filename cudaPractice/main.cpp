#include <iostream>
#include <random>
#include <ctime>
#include "cuda.h"

int main(int argc, char *argv[])
{
    int b = std::time(nullptr);
    std::cout << "Hello Time: " << b << std::endl;

    int count;

    if(argc == 1)
    {
        count = 50;
    }
    else
    {
        std::cout << "No Count" << std::endl;
    }

    float ***A = (float***)malloc(sizeof(float**) * count);
    float ***B = (float***)malloc(sizeof(float**) * count);
    float ***C = (float***)malloc(sizeof(float**) * count);
    for(int i = 0; i < count; i++)
    {
        A[i] = (float**)malloc(sizeof(float*) * count);
        B[i] = (float**)malloc(sizeof(float*) * count);
        C[i] = (float**)malloc(sizeof(float*) * count);
        for(int j = 0; j < count; j++)
        {
            A[i][j] = (float*)malloc(sizeof(float) * count);
            B[i][j] = (float*)malloc(sizeof(float) * count);
            C[i][j] = (float*)malloc(sizeof(float) * count);
        }
    }

    std::default_random_engine e (b);
    std::default_random_engine c (b + 30000);
    std::uniform_real_distribution<float> d{1, 20};

    for(int i = 0; i < count; i++)
    {
        for(int j = 0; j < count; j++)
        {
            for(int k = 0; k < count; k++)
            {
                A[i][j][k] = d(e);
                B[i][j][k] = d(c);
            }
        }
    }

    callCuda(A, B, C, count);

    std::cout << A[count - 1][count - 1][count - 1] << std::endl;
    return 0;
}