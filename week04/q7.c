// print a triangle
#include <stdio.h>

// using while loop
// int main (void) {
//     int i = 1;
//     while (i <= 10) {
//         int j = 0;
//         while (j < i) {
//             printf("*");
//             j++;
//         }

//         printf("\n");
//         i++;
//     }

//     return 0;
// }

// using goto
int main(void) {
    int i = 1;

loop0:
    if (i > 10) goto end0;
    
    int j = 0;

loop1:
    if (j >= i) goto end1;

    printf("*");
    j = j + 1;

    goto loop1;

end1:
    printf("\n");
    i = i + 1;

    goto loop0;

end0:
    return 0;
}
