# Week 7 Tute

### 2. Give MIPS directives to represent the following variables:
### Assume that we are placing the variables in memory, at an appropriately aligned address, and with a label which is the same as the C variable name.

#### a) 
``` C
int v0;
```

```
v0:
        .space 4
```


#### b)
``` C
int v1 = 42;
```

```
v1:
        .word 42
```


#### c)
``` C
char v2;
```

```
v2:
        .space 1
```


#### d)
``` C
char v3 = 'a';
```

```
v3:
        .byte 'a'
```


#### e)
``` C
double v4;
```

```
v4:
        .space 8
```


#### f)
``` c
int v5[20];
```

```
v5:
        .space 80
```


#### g)
``` C
int v6[10][5];
```

```
v6:
        .space 200
```

#### h)
``` C
struct { int x; int y; } v7;
```

```
v7:
        .space 8
```


#### i)
``` C
struct { int x; int y; } v8[4];
```

```
v8:
        .space 32
```


#### j)
``` C
struct { int x; int y; } *v9[4];
```

```
v9:
        .space 16
```

___

### 3. Translate this C program to MIPS assembler.
``` C
int max(int a[], int length) {
    int first_element = a[0];
    if (length == 1) {
        return first_element;
    } else {
        // find max value in rest of array
        int max_so_far = max(&a[1], length - 1);
        if (first_element > max_so_far) {
            max_so_far = first_element;
        }

        return max_so_far;
    }
}
```

MIPS
```
        .text
max:
max__prologue:
        addiu   $sp, $sp, -8            # allocate space to store $ra, $s0
        sw      $ra, 0($sp)             # save $ra onto stack
        sw      $s0, 4($sp)             # save $s0 onto stack

max__body:
        lw      $s0, ($a0)              # store first_element in $s0

        beq     $a1, 1, first_element   # if (length == 1) goto first_element;

        addi    $a0, $a0, 4             # store &a[1] in $a0
        addi    $a1, $a1, -1            # store length - 1 in $a1
        jal     max                     # max_so_far is stored in $v0

        ble     $s0, $v0, max__epilogue

        move    $v0, $s0                # max_so_far = first_element
        j       max__epilogue

first_element:
        move    $v0, $s0                # store first_element in return register

max__epilogue:
        lw      $s0, 4($sp)             # reloading $s0 from stack
        lw      $ra, 0($sp)             # reloading $ra from stack
        addiu   $sp, $sp, 8             # place stack back to before $ra and $s0 was stored

        jr      $ra                     # return
```

___
## MIPS Functions
```
$t0 - $t7 -> can be overwritten during function calls
$s0 - $s7 -> won't be overwritten during function calls, but maintain them in your functions
$ra -> save the return address before you call a function

$sp -> keeps track of the top of the stack
need to subtract from the stack pointer to allocate space to store things


$a0-$a3 -> first 4 arguments
$v0, $v1 -> return results placed in these registers
```
___
### 4. Translate this C program to MIPS assembler using normal function calling conventions.
### `sum2` is a very simple function but don't rely on this when implementing `sum4`.
``` C
// sum 4 numbers using function calls

#include <stdio.h>

int sum4(int a, int b, int c, int d);
int sum2(int x, int y);

int main(void) {
    int z = sum4(11, 13, 17, 19);
    printf("%d\n", z);
    return 0;
}

int sum4(int a, int b, int c, int d) {
    int e = sum2(a, b);
    int f = sum2(c, d);
    return sum2(e, f);
}

int sum2(int x, int y) {
    return x + y;
}
```

MIPS
```
        .text
main:
# does the save of the $ra and $s0-$s7 that we use
main__prologue:
        addiu   $sp, $sp, -4            # create space to store $ra
        sw      $ra, 0($sp)             # store $ra onto the stack

# actual logic for main
main__body:
        li      $a0, 11                 # place 11 into argument 1
        li      $a1, 13                 # place 13 into argument 2
        li      $a2, 17                 # place 17 into argument 3
        li      $a3, 19                 # place 19 into argument 4
        jal     sum4                    # sum4(11, 13, 17, 19)

        move    $a0, $v0                # put z in argument to print ($a0)
        li      $v0, 1                  # syscall number to print integer
        syscall                         # printf("%d", z);

        li      $v0, 11                 # syscall number to print character
        li      $a0, '\n'               # put '\n' in argument to print
        syscall                         # printf("\n")

# places $ra and saved off $s0-$s7 back into the registers
main__epilogue:
        lw      $ra, 0($sp)             # load $ra back from the stack
        addiu   $sp, $sp, 4             # restore stack to original position

        li      $v0, 0                  # load 0 into return register
        jr      $ra                     # return 0



sum4:
sum4__prologue:
        addiu   $sp, $sp, -4            # create space to store $ra
        sw      $ra, 0($sp)             # store $ra onto the stack

        addiu   $sp, $sp, -4            # create space to store $s0
        sw      $s0, 0($sp)             # store $s0 onto the stack

        addiu   $sp, $sp, -4            # create space to store $s1
        sw      $s1, 0($sp)             # store $s1 onto the stack

        addiu   $sp, $sp, -4            # create space to store $s2
        sw      $s2, 0($sp)             # store $s2 onto the stack

sum4__body:
        move    $s0, $a2                # store c in $s0
        move    $s1, $a3                # store d in $s1

        move    $a0, $a0                # place a into argument 1
        move    $a1, $a1                # place b into argument 2
        jal     sum2                    # sum2(a, b)

        move    $s2, $v0                # store e in $s2

        move    $a0, $s0                # place c into argument 1
        move    $a1, $s1                # place d into argument 2
        jal     sum2                    # sum2(c, d)

        move    $a0, $s2                # place e into argument 1
        move    $a1, $v0                # place f into argument 2
        jal     sum2                    # sum2(e, f)

sum4__epilogue:
        lw      $s2, 0($sp)             # load $s0 back from the stack
        addiu   $sp, $sp, 4             # restore stack to before $s2 was placed

        lw      $s1, 0($sp)             # load $s1 back from the stack
        addiu   $sp, $sp, 4             # restore stack to before $s1 was placed

        lw      $s0, 0($sp)             # load $s2 back from the stack
        addiu   $sp, $sp, 4             # restore stack to before $s0 was placed

        lw      $ra, 0($sp)             # load $ra back from the stack
        addiu   $sp, $sp, 4             # restore stack to original position

        # don't need to load result because sum2(e, f) is already stored in $v0
        jr      $ra                     # return sum2(e, f)



sum2:
sum2__prologue:
# empty because it doesn't call any functions


sum2__body:
        add     $t0, $a0, $a1           # calculate x+y and store in $t0

sum2__epilogue:
        move    $v0, $t0                # stores x + y in return register
        jr      $ra                     # return x + y
```


___
### 5. For each of the following struct definitions, what are the likely offset values for each field, and the total size of the struct:
### Both the offsets and sizes should be in units of number of bytes.

#### a)
``` C
struct _coord {
    double x;
    double y;
};
```

| field | offset | size |
|:---:|:---:|:---:|
| x | 0 | 8 |
| y | 8 | 8 |

Total: 8 + 8 = 16

#### b)
``` C
typedef struct _node Node;
struct _node {
    int value;
    Node *next;
};
```

| field | offset | size |
|:---:|:---:|:---:|
| value | 0 | 4 |
| next | 4 | 4 |

Total: 4 + 4 = 8


#### c)
``` C
struct _enrolment {
    int stu_id;         // e.g. 5012345
    char course[9];     // e.g. "COMP1521"
    char term[5];       // e.g. "17s2"
    char grade[3];      // e.g. "HD"
    double mark;        // e.g. 87.3
};
```

| field | offset | size |
|:---:|:---:|:---:|
| stu_id | 0 | 4 |
| course | 4 | 9 |
| term | 13 | 5 |
| grade | 18 | 3 |
| (padding) | 21 | 3 |
| mark | 24 | 8 |

Total: 4 + 9 + 5 + 3 + 3 + 8 = 32


#### d)
``` C
struct _queue {
    int nitems;     // # items currently in queue
    int head;       // index of oldest item added
    int tail;       // index of most recent item added
    int maxitems;   // size of array
    Item *items;    // malloc'd array of Items
};
```
| field | offset | size |
|:---:|:---:|:---:|
| nitem | 0 | 4 |
| head | 4 | 4 |
| tail | 8 | 4 |
| maxitems | 12 | 4 |
| items | 16 | 4 |

Total: 4 + 4 + 4 + 4 + 4 = 20
