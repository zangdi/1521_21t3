#include <stdio.h>

int main(void) {
    int x, y;
    printf("Enter a number: ");
    scanf("%d", &x);

    if (x <= 463460) goto square;
    
    printf("square too big for 32 bits\n");
    goto end;

square:
    y = x * x;
    printf("%d", y);
    printf("\n");

end:
    return 0;
}
