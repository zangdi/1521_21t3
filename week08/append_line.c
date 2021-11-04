#include <stdio.h>

#define MAX_SIZE 1000

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        return 1;
    }

    FILE *stream = fopen(argv[1], "a");
    if (stream == NULL) {
        perror(argv[1]);
        return 1;
    }

    char line[MAX_SIZE];
    fgets(line, MAX_SIZE, stdin);
    fprintf(stream, "%s", line);

    fclose(stream);
    return 0;
}
