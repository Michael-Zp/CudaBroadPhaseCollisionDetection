
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>


__global__ void VecAdd(const float* A, const float* B, float* C)
{
	int i = blockDim.x * blockIdx.x + threadIdx.x;
	C[i] = A[i] + B[i];
}


int main()
{
	cudaError_t err = cudaSuccess;

	float A[3] = { 1, 2, 3 };
	float B[3] = { 6, 2, 1 };
	float C[3];

	float size = 3 * sizeof(float);

	float *d_A = NULL;
	err = cudaMalloc((void **)&d_A, size);
	err = cudaMemcpy(d_A, A, size, cudaMemcpyHostToDevice);

	float *d_B = NULL;
	err = cudaMalloc((void **)&d_B, size);
	err = cudaMemcpy(d_B, B, size, cudaMemcpyHostToDevice);

	float *d_C = NULL;
	err = cudaMalloc((void **)&d_C, size);

	VecAdd << <3, 1 >> > (d_A, d_B, d_C);

	err = cudaMemcpy(C, d_C, size, cudaMemcpyDeviceToHost);

	printf("A = (%f, %f, %f)", A[0], A[1], A[2]);
	printf("B = (%f, %f, %f)", B[0], B[1], B[2]);
	printf("C = (%f, %f, %f)", C[0], C[1], C[2]);

	cudaFree(d_A);
	cudaFree(d_B);
	cudaFree(d_C);


	return err;
}