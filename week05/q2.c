#include <stdio.h>


int main(void) {
    int i = 0;

loop:
    i++;

    printf("%d", i);
    printf("\n");

    if (i < 10) goto loop;

    return 0;
}