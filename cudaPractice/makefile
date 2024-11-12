main : cuda.o main.o
	nvcc -ccbin g++ cuda.o main.cpp -o main -L/opt/cuda/targets/x86_64-linux/lib --threads 0 -gencode arch=compute_50,code=sm_50 -lcuda -lcudart 
	rm cuda.o main.o
cuda.o :
	nvcc -ccbin g++ -m64 --threads 0 -o cuda.o -c cuda.cu
main.o :
	nvcc -ccbin g++ -L/opt/cuda/targets/x86_64-linux/lib --threads 0 -o main.o -c main.cpp

clean:
	rm -f main main.o temp.o cuddo


dream:
	nvcc -dlink cuda.o -lcudart -lcuda -L/opt/cuda/targets/x86_64-linux/lib -o temp.o