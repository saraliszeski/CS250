#include "stdio.h"
#include "stdlib.h"
int foo(int N){
        int k;
        int* k_ptr;
        k_ptr = (int*)malloc(5*sizeof(int));

        // base case!!!
        if (N==0){
            return 5;
        }

        else {
            k = 4*(N+1) + (2* foo(N-1)) -2;
        }
        return k;
    }

int main( int argc, char* argv[]){
    

    int N;
    int* N_ptr;
    char *a;
    int g;

    a = argv[1];
    N_ptr = (int*)malloc(8*sizeof(int));
    N_ptr =&N;
    N = atoi(a);
    g = foo(N);




    printf("%d", g);
    return 0;
}


    