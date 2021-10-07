#include <stdio.h>

// using while loop
// int main(void) {
//     int x = 24;
//     while (x < 42) {
//         printf("%d\n", x);
//         x = x + 3;
//     }
// }

// using goto
int main(void) {
    int x = 24;

loop:
    if (x >= 42) goto end;

    printf("%d", x);
    printf("\n");

    x = x + 3;
    
    goto loop;

end:
    return 0;
}
