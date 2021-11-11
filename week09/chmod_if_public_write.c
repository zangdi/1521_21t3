#include <stdio.h>
#include <sys/stat.h>
#include <sys/types.h>

int main(int argc, char *argv[]) {
    for (int i = 1; i < argc; i++) {
        struct stat info;

        // stat grabs the information about argv[i] and puts it in the info struct
        // we want the address of info so that stat can change its data
        int success = stat(argv[i], &info);
        // stat return 0 if it is successful, -1 if it isn't
        if (success == -1) {
            perror(argv[i]); // <filename>: <reason why it failed>
            return 1;
        }

        mode_t mode = info.st_mode;
        // checks if others can write bit is set in mode
        if (mode & S_IWOTH) {
            // unsets the others can write bit in mode
            mode_t new_mode = mode ^ S_IWOTH;

            // chmod return 0 if it is successful, -1 if is isn't
            int chmod_success = chmod(argv[i], new_mode);
            if (chmod_success == -1) {
                perror(argv[i]);
                return 1;
            }

            printf("removing public write from %s\n", argv[i]);
        } else {
            printf("%s is not publically writable\n", argv[i]);
        }
    }

    return 0;
}
