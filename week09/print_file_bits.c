#include <stdio.h>
#include <stdint.h>

int main(int argc, char *argv[]) {
    for (int i = 1; i < argc; i++) {
        FILE *stream = fopen(argv[i], "r");
        if (stream == NULL) {
            perror(argv[i]);
            return 1;
        }

        int num;
        while (fscanf(stream, "%d", &num) == 1) {
            // want it to be signed and 8 bits so use int8_t
            int8_t new_num = num & 0xFF;
            printf("%d\n", new_num);
        }
    }

    return 0;
}
