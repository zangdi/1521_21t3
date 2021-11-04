#include <stdio.h>

#define MAX_SIZE 1000

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        return 1;
    }

    FILE *stream = fopen(argv[1], "r");
    if (stream == NULL) {
        perror(argv[1]);
        return 1;
    }

    char line[MAX_SIZE];
    fgets(line, MAX_SIZE, stream);
    printf("%s", line);

    fclose(stream);
    return 0;
}
