# Week 5 Tute

## Assignment 1
Reminder that [assignment 1](https://cgi.cse.unsw.edu.au/~cs1521/21T3/assignments/ass1/index.html) is out!

Look at week07 for example of using MIPS functions
___
### 2. Translate the following do-while loop to MIPS assembly.
``` C
#include <stdio.h>

int main(void) {
	int i = 0;

	do {
		i++;

		printf("%d", i);
		printf("\n");
	} while (i < 10);

	return 0;
}
```


___
### 3. If the data segment of a particular MIPS program starts at the address 0x10000020, then what addresses are the following labels associated with, and what value is stored in each 4-byte memory cell?
``` assembly
    .data
a:  .word   42
b:  .space  4
c:  .asciiz "abcde"
    .align  2
d:  .byte   1, 2, 3, 4
e:  .word   1, 2, 3, 4
f:  .space  1
```


| Label | Address | Contents |
|:---:|:---:|:---:|
| a | 0x10000020 | 42 |
| b | 0x10000024 | ??? |
| c | 0x10000028 | 'a', 'b', 'c', 'd' |
|   | 0x1000002C | 'e', ? ? ? |
| d | 0x10000030 | 1, 2, 3, 4 |
| e | 0x10000034 | 1 |
|   | 0x10000038 | 2 |
|   | 0x1000003C | 3 |
|   | 0x10000040 | 4 |
| f | 0x10000044 | ? ??? |



___
### 4. Give MIPS directives to represent the following variables:
### Assume that we are placing the variables in memory, at an appropriately-aligned address, and with a label which is the same as the C variable name.
| part | C | MIPS |
|:---:|:---|:---|
| a | `int u;` | `u:    .space 4`
| b | `int v = 42;` | `v:   .word 42`
| c | `char w;` | `w:   .space 1`
| d | `char x = 'a';` | `x:     .byte 'a'`
| e | `double y;` | `y:     .space 8`
| f | `int z[20];` | `z:    .space 80`


___
### 5. Consider the following memory state:
```
Address       Data Definition
0x10010000    aa:  .word 42
0x10010004    bb:  .word 666
0x10010008    cc:  .word 1
0x1001000C         .word 3
0x10010010         .word 5
0x10010014         .word 7
```
### What address will be calculated, and what value will be loaded into register $t0, after each of the following statements (or pairs of statements)?


#### a)
```
la   $t0, aa
```
$t0 = 0x10010000


#### b)
```
lw   $t0, bb
```
$t0 = 666

#### c)
```
lb   $t0, bb
```
depends on the system, but either top byte or bottom byte

#### d)
```
lw   $t0, aa+4
```
$t0 = 666

#### e)
```
la   $t1, cc
lw   $t0, ($t1)
```
$t1 = 0x10010008

$t0 = 1


#### f)
```
la   $t1, cc
lw   $t0, 8($t1)
```
$t0 = 5

#### g)
```
li   $t1, 8
lw   $t0, cc($t1)
```
$t0 = 5


#### h)
```
la   $t1, cc
lw   $t0, 2($t1)
```
fail because it's misaligned

___
### 7. Translate this C program to MIPS assembler
``` C
#include <stdio.h>

int main(void) {
    int i;
    int numbers[10] = {0};

    i = 0;
    while (i < 10) {
        scanf("%d", &numbers[i]);
        i++;
    }

    i = 9;
    while (i >= 0) {
        printf("%d", numbers[i]);
        printf("\n");
        i--;
    }
}
```

MIPS
```
        .text
main:
        li      $t0, 0                  # store i in $t0

loop1:
        bge     $t0, 10, end1

        li      $v0, 5                  # syscall number for read integer
        syscall                         # scanf -> integer stored in $v0

        mul     $t1, $t0, 4             # stores offset above numbers (i * 4)
        sw      $v0, numbers($t1)       # numbers[i] = $v0

        addi    $t0, $t0, 1             # i++

        b       loop1

end1:

        li      $t0, 9                  # i = 9
loop2:
        bltz    $t0, end2               # if (i < 0) goto end2
        # blt   $t0, 0, end2

        mul     $t1, $t0, 4             # how much higher &numbers[i] is than &numbers[0]
        lw      $a0, numbers($t1)       # store numbers[i] in $a0 as an argument

        li      $v0, 1                  # syscall number to print integer
        syscall                         # printf("%d", numbers[i])

        li      $v0, 11                 # syscall number to print character
        li      $a0, '\n'               # '\n' as argument to print
        syscall                         # printf("\n")

        addi    $t0, $t0, -1            # i--

        b       loop2

end2:
        li      $v0, 0
        jr      $ra


        .data
numbers:
        .word   0, 0, 0, 0, 0, 0, 0, 0, 0, 0
```

___
### 13. Implement the following C code in MIPS assembly instructions, assuming that the variables x and y are defined as global variables (within the .data region of memory):
``` C
long x;     // assume 8 bytes
int  y;     // assume 4 bytes

scanf("%d", &y);

x = (y + 2000) * (y + 3000);
```
Assume that the product might require more than 32 bits to store.

MIPS
```
        .text
main:
        li      $v0, 5                  # syscall number for read integer
        syscall                         # scanf("%d" -> store number in $v0

        sw      $v0, y                  # stores number read in into y

        addi    $t0, $v0, 2000          # stores y + 2000 in $t0
        addi    $t1, $v0, 3000          # stores y + 3000 in $t1

        mult    $t0, $t1                # multiply large values in $t0 and $t1
                                        # result store in (hi, lo)

        mfhi    $t0                     # grab value out of hi register, store in $t0
        sw      $t0, x                  # place high bits in top 4 bytes of x

        mflo    $t0                     # grab value out of lo register, store in $t0
        sw      $t0, x+4                # place lo bits in bottom 4 bytes of x

                                        # store value into x

        .data
x:
        .space 8
y:
        .space 4

```


___
### 2D Arrays


```
int arr2d[3][7];

{ 0,  1,  2,  3,  4,  5,  6},
{ 7,  8,  9, 10, 11, 12, 13},
{14, 15, 16, 17, 18, 19, 20}

int arr1d[21];

{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20};

arr2d[1][2] = arr1d[9] => 9 = 1 * 7 + 2



int b[ROW][COL];
b[i][j] => ((i * COL) + j)th index of 1d equivalent
```


___
### 15. Translate this C program to MIPS assembler.
``` C
#include <stdio.h>

char flag[6][12] = {
    {'#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'},
    {'#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'},
    {'.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'},
    {'.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'},
    {'#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'},
    {'#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'}
};

int main(void) {
    for (int row = 0; row < 6; row++) {
        for (int col = 0; col < 12; col++)
            printf ("%c", flag[row][col]);
        printf ("\n");
    }

}
```

```
flag[0][0] => 1d equivalent: flag2[0]
flag[1][0] => 1d equivalent: flag2[12]
flag[2][0] => 1d equivalent: flag2[24]
flag[1][1] => 1d equivalent: flag2[13]
flag[2][7] => 1d equivalent: flag2[31] -> 2 * 12 + 7 = 31
```

MIPS
```
        .text
main:
        li      $t0, 0                  # store row in $t0

loop1:
        bge     $t0, 6, end1

        li      $t1, 0                  # store col in $t1

loop2:
        bge     $t1, 12, end2

        # remember that flattened index of arr[i][j] is ((i * COL) + j)
        mul     $t2, $t0, 12            # store start of ith row in $t2
        add     $t3, $t2, $t1           # store index of flattened version of flag in $t3

        lb      $a0, flag($t3)          # store flag[row][col] as argument in $a0
        li      $v0, 11                 # syscall number for printing character
        syscall                         # printf("%c", flag[row][col])

        addi    $t1, $t1, 1             # coll++

        b       loop2

end2:
        li      $v0, 11                 # syscall number for printing character
        li      $a0, '\n'               # load newline character into $a0
        syscall                         # printf("\n")

        addi    $t0, $t0, 1             # row++

        b       loop1

end1:
        li      $v0, 0
        jr      $ra                     # return 0;


        .data
flag:
        .byte   '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'
        .byte   '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'
        .byte   '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
        .byte   '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
        .byte   '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'
        .byte   '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'
```
