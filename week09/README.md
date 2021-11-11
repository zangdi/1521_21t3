# Week 9 Tute


### 4. The `stat()` and `lstat()` functions both take an argument which is a pointer to a struct stat object, and fill it with the meta-data for a named file.

### On Linux, a `struct stat` contains the following fields (among others, which have omitted for simplicity):
``` C
struct stat {
    ino_t st_ino;         /* inode number */
    mode_t st_mode;       /* protection */
    uid_t st_uid;         /* user ID of owner */
    gid_t st_gid;         /* group ID of owner */
    off_t st_size;        /* total size, in bytes */
    blksize_t st_blksize; /* blocksize for filesystem I/O */
    blkcnt_t st_blocks;   /* number of 512B blocks allocated */
    time_t st_atime;      /* time of last access */
    time_t st_mtime;      /* time of last modification */
    time_t st_ctime;      /* time of last status change */
};
```

### Explain what each of the fields represents (in more detail than given in the comment!) and give a typical value for a regular file which appears as follows:
``` sh
$ ls -ls stat.c
8 -rw-r--r--  1 jas  cs1521  1855  Sep  9 14:24 stat.c
```
### Assume that `jas` has user id 516, and the `cs1521` group has group id 36820.


___
### 5. Consider the following (edited) output from the command `ls -l ~cs1521`:
``` sh
drwxr-x--- 11 cs1521 cs1521 4096 Aug 27 11:59 17s2.work
drwxr-xr-x  2 cs1521 cs1521 4096 Aug 20 13:20 bin
-rw-r-----  1 cs1521 cs1521   38 Jul 20 14:28 give.spec
drwxr-xr-x  3 cs1521 cs1521 4096 Aug 20 13:20 lib
drwxr-x--x  3 cs1521 cs1521 4096 Jul 20 10:58 public_html
drwxr-xr-x 12 cs1521 cs1521 4096 Aug 13 17:31 spim
drwxr-x---  2 cs1521 cs1521 4096 Sep  4 15:18 tmp
lrwxrwxrwx  1 cs1521 cs1521   11 Jul 16 18:33 web -> public_html
```
### a) Who can access the `17s2.work` directory?
Everyone in `cs1521` group

### b) What operations can a typical user perform on the public_html directory?
They can `cd` into the directory and access file within the directory if they know it, but they cannot list the files in that directory.

### c) What is the file web?
`web` is a symbolic link to `public_html`

### d) What is the difference between `stat("web", &info)` and `lstat("web", &info`)?
### (where info is an object of type (`struct stat`))
`stat` will contain the information about the `public_html` directory, but `lstat` will contain the information about `web` itself

___
### 6. Write a C program, chmod_if_public_write.c, which is given 1+ command-line arguments which are the pathnames of files or directories
### If the file or directory is publically-writeable, it should change it to be not publically-writeable, leaving other permissions unchanged.

### It also should print a line to stdout as in the example below
``` C
$ dcc chmod_if_public_write.c -o chmod_if_public_write
$ ls -ld file_modes.c file_modes file_sizes.c file_sizes
-rwxr-xrwx 1 z5555555 z5555555 116744 Nov  2 13:00 file_sizes
-rw-r--r-- 1 z5555555 z5555555    604 Nov  2 12:58 file_sizes.c
-rwxr-xr-x 1 z5555555 z5555555 222672 Nov  2 13:00 file_modes
-rw-r--rw- 1 z5555555 z5555555   2934 Nov  2 12:59 file_modes.c
$ ./file_modes file_modes file_modes.c file_sizes file_sizes.c
removing public write from file_sizes
file_sizes.c is not publically writable
file_modes is not publically writable
removing public write from file_modes.c
$ ls -ld file_modes.c file_modes file_sizes.c file_sizes
-rwxr-xr-x 1 z5555555 z5555555 116744 Nov  2 13:00 file_sizes
-rw-r--r-- 1 z5555555 z5555555    604 Nov  2 12:58 file_sizes.c
-rwxr-xr-x 1 z5555555 z5555555 222672 Nov  2 13:00 file_modes
-rw-r--r-- 1 z5555555 z5555555   2934 Nov  2 12:59 file_modes.c
```
### Make sure you handle errors.

```C
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
```

___
### 7. Write a C program, fgrep.c, which is given 1+ command-line arguments which is a string to search for.
### If there is only 1 command-line argument it should read lines from stdin and print them to stdout iff they contain the string specified as the first command line argumenbt.

### If there are 2 or more command line arguments, it should treat arguments after the first as fiilenames and print any lines they contain which contain the string specified as the first command line arguments.

### When printing lines your program should prefix them with a line number.

### It should print suitable error messages if given an incorrect number of arguments or if there is an error opening a file.

``` C
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
```

___
### 8. Write a C program, `print_file_bits.c`, which given as a command line arguments the name of a file contain 32-bit hexadecimal numbers, one per line, prints the low (least significant) bytes of each number as a signed decimal number (-128..127).

```C
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
```
