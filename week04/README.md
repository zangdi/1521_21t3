# Week 4 Tute

### 1. What are `mipsy`, `spim`, `qtspim` & `xspim`.

They are the different MIPS emulators available on CSE.

`mipsy` is a new one that's been developed my Zac who is a course admin for 1521.
It's got nice features to help debug your programs.
However, it is pretty new so there may be bugs.
If you encounter any bugs, please post them on the course forum

`spim` is the main MIPS emulator that will be in use.
Make sure your code works with `spim` because that is what it will be run on.

`qtspim` and `xspim` are GUI versions of `spim` and can be nice to visualise what is going on with your code.

___
### 2. The MIPS processor has 32 general purpose 32-bit registers, referenced as `$0 .. $31`. Some of these registers are intended to be used in particular ways by programmers and by the system. For each of the registers below, give their symbolic name and describe their intended use:

| part | number | symbol | use |
|:---:|:---:|:---:|:---|
| a. | `$0` | `$zero` | will always be 0 |
| b. | `$1` | `$at` | assembler uses it, don't touch it! |
| c. | `$2` | `$v0` | first (of two) value register which stores return value from syscall or function |
| d. | `$4` | `$a0` | first (of four) argument register for syscall or function |
| e. | `$8` | `$t0` | first (of ten) temporary register to store values which will change between function calls |
| f. | `$16` | `$s0` | first (of eight) saved register to store values which will stay the same between function calls |
| g. | `$26` | `$k0` | first (of two) kernel register which the kernel uses, don't touch it! |
| h. | `$29` | `$sp` | stack pointer, top of the stack, we'll look at it in more detail in the coming weeks |
| i. | `$31` | `$ra` | return address |

Refer to the [SPIM guide](https://cgi.cse.unsw.edu.au/~cs1521/21T3/resources/spim-guide.html) for more details.

___
### 3. Translate this C program to MIPS assembler
```C
// print the square of a number
#include <stdio.h>

int main(void) {
    int x, y;
    printf("Enter a number: ");
    scanf("%d", &x);
    y = x * x;
    printf("%d\n", y);
    return 0;
}
```
### Store variable x in register $t0 and store variable y in register $t1.

MIPS
```
        .text
main:
        li              $v0, 4          # store 4 into $v0
        la              $a0, prompt     # put address of prompt into $a0
        syscall                         # print prompt string

        li              $v0, 5          # store 5 into $v0
        syscall                         # read in integer
        
        move            $t0, $v0        # store x in $t0
        mul             $t1, $t0, $t0   # y = x*x

        li              $v0, 1          # indicate print int
        move 	        $a0, $t1        # store y in $a0 to print
        syscall

        li              $v0, 11         # indicate print character
        li              $a0, '\n'
        syscall

        li              $v0, 0          # store 0 as return value
        jr              $ra             # return;

        .data
prompt:
        .asciiz "Enter a number: "

```

___
### 4. Translate this C program so it uses goto rather than if/else.
### Then translate it to MIPS assembler.
``` C
#include <stdio.h>

int main(void) {
    int x, y;
    printf("Enter a number: ");
    scanf("%d", &x);

    if (x > 46340) {
        printf("square too big for 32 bits\n");
    } else {
        y = x * x;
        printf("%d\n", y);
    }

    return 0;
}
```

Translated C
``` C
#include <stdio.h>

int main(void) {
    int x, y;
    printf("Enter a number: ");
    scanf("%d", &x);

    if (x <= 46340) goto square;
    
    printf("square too big for 32 bits\n");
    goto end;

square:
    y = x * x;
    printf("%d", y);
    printf("\n");

end:
    return 0;
}
```


MIPS
```
        .text
main:
        li              $v0, 4          # store 4 into $v0
        la              $a0, prompt     # put address of prompt into $a0
        syscall                         # print prompt string

        li              $v0, 5          # store 5 into $v0
        syscall                         # read in integer

        move 	        $t0, $v0        # store x in $t0
        
        ble             $t0, 46340, square      # if (x <= 463460) goto square;

        li              $v0, 4
        la              $a0, big_string
        syscall                         # printf("square too big...");

        b		end

square:
        mul             $t1, $t0, $t0   # y = x*x

        li              $v0, 1          # indicate print int
        move 	        $a0, $t1        # store y in $a0 to print
        syscall

        li              $v0, 11         # indicate print character
        li              $a0, '\n'
        syscall

end:
        li              $v0, 0          # store 0 as return value
        jr              $ra             # return;

        .data
prompt:
        .asciiz "Enter a number: "

big_string:
        .asciiz "square too big for 32 bits\n"
```

___
### 5.Translate this C program so it uses goto rather than if/else.
### Then translate it to MIPS assembler.
``` C
#include <stdio.h>

int main(void) {
    int x;
    printf("Enter a number: ");
    scanf("%d", &x);

    if (x > 100 && x < 1000) {
        printf("medium\n");
    } else {
        printf("small/big\n");
    }
}
```
### Consider this alternate version of the above program, use its approach to produce simpler MIPS assembler.
``` C
#include <stdio.h>

int main(void) {
    int x;
    printf("Enter a number: ");
    scanf("%d", &x);

    char *message = "small/big\n";
    if (x > 100 && x < 1000) {
        message = "medium";
    }

    printf("%s", message);
}
```

Translated C
``` C
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
```

MIPS
```
        .text
main:
        li              $v0, 4          # indicate print string
        la              $a0, prompt     # load address of prompt into $a0
        syscall                         # printf("Enter ...");

        li              $v0, 5          # indicate read integer
        syscall 
        move 	        $t0, $v0        # scanf("%d", &x);
                                        # store x in register $t0

        la              $t1, small_big  # store message in $t1
        
        ble             $t0, 100, do_print      # if $t0 <= 100 then goto do_print
        bge             $t0, 1000, do_print     # if $t0 >= 1000 then goto do_print
        
        la              $t1, medium     # set message to medium
        
do_print:
        li              $v0, 4          # indicate print string
        move 	        $a0, $t1
        syscall

        li              $v0, 0
        jr              $ra             # return 0;

        .data
prompt:
        .asciiz "Enter a number: "

small_big:
        .asciiz "small/big\n"

medium:
        .asciiz "medium\n"
```


### 6. Translate this C program so it uses goto rather than if/else.
### Then translate it to MIPS assembler.
``` C
#include <stdio.h>

int main(void) {
    for (int x = 24; x < 42; x += 3) {
        printf("%d\n",x);
    }
}
```

Translated C
``` C
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
```

MIPS
```
        .text
main:
        li              $t0, 24                 # store x = 24 int $t0

loop:
        bge             $t0, 42, end            # if (x >= 42) goto end;

        li              $v0, 1                  # number for print integer
        move 	        $a0, $t0
        syscall                                 # printf("%d", x);

        li              $v0, 11                 # number for print character
        li              $a0, '\n'
        syscall                                 # print("\n");

        addi	        $t0, $t0, 3             # x = x + 3;

        j               loop

end:
        li              $v0, 0
        jr              $ra                     # return 0;

```

___
### 7. Translate this C program so it uses goto rather than if/else.
### Then translate it to MIPS assembler.
``` C
// print a triangle
#include <stdio.h>

int main (void) {
    for (int i = 1; i <= 10; i++) {
        for (int j = 0; j < i; j++) {
            printf("*");
        }
        printf("\n");
    };
    return 0;
}
```

Translated C
```C
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
```

MIPS
```
        .text
main:
        li              $t0, 1                  # store i = 1 in $t0

loop0:
        bgt             $t0, 10, end0           # if (i > 10) goto end0;
        li              $t1, 0                  # store j = 0 in $t1

loop1:
        bge             $t1, $t0, end1          # if (j >= i) goto end1;

        li              $v0, 11                 # print character
        li              $a0, '*'
        syscall                                 # printf("*");
        
        addi            $t1, $t1, 1             # j = j + 1;

        b               loop1

end1:
        li              $v0, 11                 # print character
        li              $a0, '\n'
        syscall                                 # printf("*");

        addi            $t0, $t0, 1             # i = i + 1;

        b               loop0

end0:
        li              $v0, 0
        jr              $ra                     # return 0;
```