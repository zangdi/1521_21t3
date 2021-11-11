#include <stdio.h>
#include <string.h>

#define MAX_LEN 4096

void search_string(FILE *stream, char *filename, char *term) {
    int line_number = 1;
    char line[MAX_LEN];

    while (fgets(line, MAX_LEN, stream) != NULL) {
        // if term is in line, strstr returns a pointer to where term is found in line
        // if term is not in line, strstr returns NULL
        if (strstr(line, term) != NULL) {
            printf("%s:%d: %s", filename, line_number, line);
        }

        line_number++;
    }
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <string> [files...]\n", argv[0]);
        return 1;
    }

    if (argc == 2) {
        search_string(stdin, "<stdin>", argv[1]);
    } else {
        for (int i = 2; i < argc; i++) {
            FILE *stream = fopen(argv[i], "r");
            if (stream == NULL) {
                perror(argv[i]);
                return 1;
            }

            search_string(stream, argv[i], argv[1]);
            fclose(stream);
        }
    }

    return 0;
}
