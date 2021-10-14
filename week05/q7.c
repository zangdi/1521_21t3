#include <stdio.h>

int main(void) {
    int i;
    int numbers[10] = {0};

    i = 0;
loop1:
    if (i >= 10) goto end1;

    scanf("%d", &numbers[i]);
    i++;

    goto loop1;

end1:
    i = 9;

loop2:
    if (i < 0) goto end2;
    
    printf("%d", numbers[i]);
    printf("\n");
    i--;

    goto loop2;

end2:
    return 0;
}