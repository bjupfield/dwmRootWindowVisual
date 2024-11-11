main : cuda.o main.o
	g++ cuda.o temp.o main.cpp -o main -L/opt/cuda/targets/x86_64-linux/lib -lcuda -lcudart 
	rm cuda.o main.o
cuda.o :
	nvcc -c  cuda.cu -o cuda.o
	nvcc -dlink cuda.o -lcudart -lcuda -L/opt/cuda/targets/x86_64-linux/lib -o temp.o
main.o :
	g++ -L/opt/cuda/targets/x86_64-linux/lib -c main.cpp