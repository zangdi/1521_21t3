#include <stdio.h>

int main(void) {
    int x;
    printf("Enter a number: ");
    scanf("%d", &x);

    char *message = "small/big\n";

    if (x <= 100) goto do_print;
    if (x >= 1000) goto do_print;

    message = "medium";

do_print:
    printf("%s", message);
}
