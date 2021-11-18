#include <stdio.h>
#include <stdlib.h>

#define PATHSIZE 1024

int main(void) {
    char *home = getenv("HOME");
    if (home == NULL) {
        printf("Could not find HOME environment variable\n");
        return 1;
    }

    char pathname[PATHSIZE];
    snprintf(pathname, PATHSIZE, "%s/.diary", home);

    FILE *stream = fopen(pathname, "r");
    if (stream == NULL) {
        perror(pathname);
        return 1;
    }

    int byte;
    while ((byte = fgetc(stream)) != EOF) {
        putchar(byte);
    }

    fclose(stream);
    return 0;
}