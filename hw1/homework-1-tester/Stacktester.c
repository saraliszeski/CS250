#include <stdbool.h>
#include "stdio.h"
#include "stdlib.h"
#include <string.h>

struct node {
    char* data;
    struct node* left;
    struct node* right;
};

struct stack{
    int top;
    struct node* mynode;
};

struct node makenode(char* data){
    struct node* node = (struct node*)malloc(sizeof(struct node));
    node->data = (char*)malloc(20*sizeof(char));
    node->data = data;
    node->left=NULL;
    node->right=NULL;
    return(*node);
};

void push(char* data, struct stack* mystack){
    mystack->mynode[mystack->top+1]= makenode(data);
    mystack->top+=1;
};

void makestack(struct stack* mystack){
    mystack->top =-1;
    struct node* mynode  = (struct node*)malloc(20*sizeof(struct node));
    mystack ->mynode = mynode;
   

};

bool checkifempty(struct stack* mystack){
    if (mystack->top==-1){
        return true;
    }
};

struct node pop(struct stack* mystack){
    
    int temp = mystack->top;
    mystack->top--;
    printf("%s\n",mystack->mynode[temp].data);

    return (mystack->mynode[temp]);
};

int main(){
    /*initialize array of nodes*/
    struct stack* mystack;
    mystack = (struct stack*)malloc(sizeof(struct stack));
    
    makestack(mystack);
    char* p = (char*)"working";
    char* d = (char*)"fucking";
    char* e = (char*)"is";
    char* k = (char*)"stack";
    char* l = (char*)"my";
    push(p, mystack);
    push(d, mystack);
    push(e, mystack);
    push(k, mystack);
    push(l, mystack);
    pop(mystack);
    pop(mystack);
    pop(mystack);
    pop(mystack);
    pop(mystack);
    checkifempty(mystack);

}