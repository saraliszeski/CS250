#include <stdio.h>
int main() 
{
    char str[80];
    int g;
    int i;
    float x;

    printf("What's the last name of your favorite basketball player? \n");
    scanf("%s", str);
    printf("\n How tall is your player?");
    scanf("%d", &g);
    printf("\n What's their average ppg?");
    scanf("%d", &i);

    x = (float)(i/g);

    printf(" %s scored an average of %f points per inch", str, x);

    return 0;
}


