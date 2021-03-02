#include <stdbool.h>
#include "stdio.h"
#include "stdlib.h"
#include <string.h>


struct node {
    char data[50];
    struct node* left;
    struct node* right;
};

struct node* makenode(char* data){
    struct node* node = (struct node*)malloc(sizeof(struct node));
    strcpy(node->data, data);
    node->left= NULL;
    node->right=NULL;
    return(node);
};

void searchtree(char* infecter, struct node* starter, struct node* infectee){
    /*when you find a math, assign infectee as its child*/
    bool hasswitched = false;
    if (strcmp(starter->data, infecter)==0){
        if (starter->left==NULL){
            /*printf("adding leftnode %s to %s\n", infectee->data, starter->data);*/
            starter->left = infectee;
            return;
        }
        else if (starter->right==NULL){
               int comp = strcmp(starter->left->data, infectee->data);

               if (comp >0){
                   struct node* temp = starter->left;
                   starter->left=infectee;
                   starter->right = temp;
                   /*printf("switched left to right\n");
                   printf("new left: %s  new right: %s \n", starter->left->data, starter->right->data);*/
                   hasswitched=true;
               }
               else{
                    starter->right = infectee;
               }
            /*printf("adding right\n");*/

            return;
        }
    }
    /*if it's not at that node, move to the next one*/
    if (starter->left!=NULL){
        if (hasswitched){
            searchtree(infecter, starter->right, infectee);
        }
        else {searchtree(infecter, starter->left, infectee);
        }
        }
    if (starter->right!=NULL){
        if (hasswitched){
            searchtree(infecter, starter->left, infectee);
        }
           else{ searchtree(infecter, starter->right, infectee);
           }
        }
}

void print(struct node* tobeprinted){
    printf("%s\n", tobeprinted->data);
    if (tobeprinted->left != NULL){
    print(tobeprinted->left);}
    if (tobeprinted->right != NULL){
    print(tobeprinted->right);}
    return;
}

void freemytree(struct node* tbf){
/*if node has no children, free it*/
if (tbf->left!= NULL){
    freemytree(tbf->left);
}
if (tbf->right!= NULL){
    freemytree(tbf->right);
}
free(tbf);
}

int main(int argc, char* argv[]){
    /*
    read the infectee 
    create a new node with it
    read in infector
    create a new node with it 
    attach infectee to infector
    reset
    now that you have these two:
    take next string, make it into a node
    search TREE for INFECTER:
    attach the new node to that node
    continue until there is no infector
    */

   FILE *myfile = fopen(argv[1], "r");
    if (myfile == NULL){
        perror("Can't open file!!");
        exit(1);
    }

    int count =0;
    char str[16] = "DONE";
    struct node* startpt;
    int start= 1;
    /*struct node* infecter;*/
    struct node* infectee; 

   while(1){

       char buff[50];
       fscanf(myfile, "%s", buff);

       /*assign starting point node if is the first read in*/
       if (start==2){
           startpt= makenode(buff);
           start++;
       }

    if (strcmp(buff,str)==0){
       break;
   }
    if (count == 0){
        infectee = makenode(buff);
        count++;
        start++;
    }

    else if (count == 1){
        char* infecter=(char*)malloc(50*sizeof(char));
        infecter = strcpy(infecter, buff);
        /*infecter = makenode(buff);*/
        count =0;
        searchtree(infecter, startpt, infectee);
        free(infecter);
   } 
   } 
    fclose(myfile);
    print(startpt);
    freemytree(startpt);

    return 0;
} 
