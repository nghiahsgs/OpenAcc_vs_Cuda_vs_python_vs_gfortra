#include <stdio.h>
#include <time.h>
#include<math.h>
void load_matrix_from_file(FILE * file, int nb_rows,int nb_cols, double* mat){
        for(int i = 0; i < nb_rows; i++){
                for(int j = 0; j < nb_cols; j++){
                        //Use lf format specifier, %c is for character
                        //if (!fscanf(file, "%lf", &mat[i][j])){ 
                        int index=i*nb_cols + j;
                        if (!fscanf(file, "%lf", &mat[index])){
                                break;
                        }
                }
        }
}
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
__global__ void kernel_gpu(int N, double *A, double *B,  double *result){
        int r = blockIdx.x*blockDim.x+ threadIdx.x;
        int s = blockIdx.y*blockDim.y+ threadIdx.y;

        if(r < N && s<N){
                atomicAdd(result, A[r*N+s]+B[r*N+s]);
        }
}
int main(){
        int N=1000;
        double *h_A, *h_B, *h_result;
        double *d_A, *d_B, *d_result;

        //khai bao vung nho trong host
        h_A = (double*)malloc(N*N*sizeof(double));
        h_B = (double*)malloc(N*N*sizeof(double));
        h_result = (double*)malloc(sizeof(double));

        //khai bao vung nho trong device
        cudaMalloc(&d_A, N*N*sizeof(double));
        cudaMalloc(&d_B, N*N*sizeof(double));
        cudaMalloc(&d_result,sizeof(double));
        //load matrix from file
        FILE *file;
        file=fopen("matrix_1000_1000_001.txt", "r");
        load_matrix_2D_from_file(file, N, N,h_A);
        fclose(file);

        FILE *file2;
        file2=fopen("matrix_1000_1000_002.txt", "r");
        load_matrix_2D_from_file(file2, N,N,h_B);
        fclose(file2);

        //printf("gia tri A[500][500] la %f",h_A[500*100+500]);

        //====start log time
        clock_t begin=clock();

        cudaMemcpy(d_A, h_A, N*N*sizeof(double), cudaMemcpyHostToDevice);
        cudaMemcpy(d_B, h_B, N*N*sizeof(double), cudaMemcpyHostToDevice);

        //execute kernel
        int nb_hyper=8;
        dim3 nb_block(int(N/nb_hyper)+1,int(N/nb_hyper)+1,1);
        dim3 nb_thread_per_block(nb_hyper, nb_hyper,1);
        kernel_gpu<<<nb_block, nb_thread_per_block>>>(N, d_A, d_B, d_result);

        //copy result from device to host
        cudaMemcpy(h_result, d_result, sizeof(double), cudaMemcpyDeviceToHost);

        //====end log time
        clock_t end = clock();
        double time_spent=(double) (end-begin)/CLOCKS_PER_SEC;
        
        printf("Total time:%f\n",time_spent);
        printf("result :%f\n",h_result[0]/(N*N));

        return 0;
}

