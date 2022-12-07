#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>

#include "support.h"
//Error handling using functions of the CUDA runtime API
void cudaCheckError() {                                                              
  cudaError_t e=cudaGetLastError();                                                   
  if(e!=cudaSuccess) {                                                                
      printf("Cuda failure %s:%d: '%s'\n",__FILE__,__LINE__,cudaGetErrorString(e));   
      cudaDeviceReset();                                                              
      exit(EXIT_FAILURE);                                                             
  }                                                                                   
}

//This macro checks malloc() and cudaMalloc() return values
void Check_Allocation_Return_Value(double *a){   
  if(a==NULL) {                           
  printf("Allocation Error\n");           
  cudaDeviceReset();                      
  exit(EXIT_FAILURE);                     
  }                                       
}
void verify(double *hA, double *hB, double *hC, unsigned int m) {

    printf("Check results...\n");
    int i,j,k;
    int N = m;
    double res; 
    for(i=0;i<N;i++){
        for(j=0;j<N;j++){
            res=0;
            for(k=0;k<N;k++){
                res+=hA[i*N+k]*hB[k*N+j];
            }
            
           //printf("%8.3f ",res);
           if(res != hC[i*N+j]){
                printf("NOT OK i:%d, j:%d\n",i,j);
                printf("true value:%f - computed value:%f\n\n",res,hC[i*N+j]);
           }
        }
        //printf("\n");
    }
  printf("TEST PASSED");

}

void startTime(Timer* timer) {
    gettimeofday(&(timer->startTime), NULL);
}

void stopTime(Timer* timer) {
    gettimeofday(&(timer->endTime), NULL);
}

float elapsedTime(Timer timer) {
    return ((float) ((timer.endTime.tv_sec - timer.startTime.tv_sec) \
                + (timer.endTime.tv_usec - timer.startTime.tv_usec)/1.0e6));
}

