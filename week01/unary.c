#include <stdio.h>

int main() {
    int i = 0;
    int j = 0;

    printf("i = %d, j = %d\n", i, j);       // prints out i = 0, j = 0
    printf("i = %d, j = %d\n", ++i, j++);   // prints out i = 1, j = 0
    printf("i = %d, j = %d\n", i, j);       // prints out i = 1, j = 1

    return 0;
}
