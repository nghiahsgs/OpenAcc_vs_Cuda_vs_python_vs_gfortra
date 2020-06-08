#include <stdio.h>
#include <time.h>
#include<math.h>
void load_matrix_2D_from_file(FILE * file, int nb_rows,int nb_cols, double* matrix){
        for(int i = 0; i < nb_rows; i++){
                for(int j = 0; j < nb_cols; j++){
                        int index=i*nb_cols + j;
                        if (!fscanf(file, "%lf", &matrix[index])){
                                break;
                        }
                }
        }
}
void load_matrix_1D_from_file(FILE * file, int n, double* matrix){
                for(int j = 0; j < n; j++){
                        if (!fscanf(file, "%lf", &matrix[j])){
                                break;
                        }
                }
}
__global__ void kernel_gpu(int N, double *C, double *B, double *E,  double *result){
        int r = blockIdx.x*blockDim.x+ threadIdx.x;
        int s = blockIdx.y*blockDim.y+ threadIdx.y;
        int q = blockIdx.z*blockDim.z+ threadIdx.z;

        if(r < N && s<N && q<N){
                atomicAdd(result, C[r*N+s]*B[s*N+q]*(cos(E[q]-E[r])-cos(E[s]-E[q]))/(10+E[s]-E[q]/2-E[r]/2));
        }
}
int main(){
        int N=2000;
        double *h_C, *h_B,*h_E, *h_result;
        double *d_C, *d_B,*d_E, *d_result;

        //====start log time
        clock_t begin=clock();

        //khai bao vung nho trong host
        h_C = (double*)malloc(N*N*sizeof(double));
        h_B = (double*)malloc(N*N*sizeof(double));
        h_E = (double*)malloc(N*sizeof(double));
        h_result = (double*)malloc(sizeof(double));

        //khai bao vung nho trong device
        cudaMalloc(&d_C, N*N*sizeof(double));
        cudaMalloc(&d_B, N*N*sizeof(double));
        cudaMalloc(&d_E, N*sizeof(double));
        cudaMalloc(&d_result,sizeof(double));

        //load matrix from file
        FILE *file;
        file=fopen("matrix_2000_2000_001.txt", "r");
        load_matrix_2D_from_file(file, N, N,h_C);
        fclose(file);

        FILE *file2;
        file2=fopen("matrix_2000_2000_002.txt", "r");
        load_matrix_2D_from_file(file2, N,N,h_B);
        fclose(file2);

        FILE *file3;
        file3=fopen("matrix_2000_1_001.txt", "r");
        load_matrix_1D_from_file(file3, N,h_E);
        fclose(file3);

        //printf("h_C[500][500] : %f \n",h_C[500*1000+500]);
        //printf("h_B[500][500] : %f \n",h_B[500*1000+500]);
        //printf("h_E[500] : %f\n",h_E[999]);
        cudaMemcpy(d_C, h_C, N*N*sizeof(double), cudaMemcpyHostToDevice);
        cudaMemcpy(d_B, h_B, N*N*sizeof(double), cudaMemcpyHostToDevice);
        cudaMemcpy(d_E, h_E, N*sizeof(double), cudaMemcpyHostToDevice);

        //execute kernel
        int nb_hyper=8;
        dim3 nb_block(int(N/nb_hyper)+1,int(N/nb_hyper)+1,int(N/nb_hyper)+1);
        dim3 nb_thread_per_block(nb_hyper, nb_hyper,nb_hyper);
        kernel_gpu<<<nb_block, nb_thread_per_block>>>(N, d_C, d_B,d_E, d_result);
 	
	//copy result from device to host
        cudaMemcpy(h_result, d_result, sizeof(double), cudaMemcpyDeviceToHost);

        //====end log time
        clock_t end = clock();
        double time_spent=(double) (end-begin)/CLOCKS_PER_SEC;

        printf("Total time:%f\n",time_spent);
        printf("result :%f\n",h_result[0]);

        return 0;
}
