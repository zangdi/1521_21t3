# Week 1 Tute

The class website can be found [here](https://cgi.cse.unsw.edu.au/~cs1521/21T3/).
It contains links to all the information you need, including course outline, lectures, lecture slides, tute questions, lab questions, etc.

The course forum can be found [here](https://discourse.cse.unsw.edu.au/21t3/comp1521/).
If you have any questions about the content or any tute questions and lab exercises, please ask there.


___
### 2. Consider the following C program skeleton:
``` C
int  a;
char b[100];

int fun1() {
    int c, d;
    ...
}

double e;

int fun2() {
    int f;
    static int ff;
    ...
    fun1();
    ...
}

int g;

int main(void) {
    char h[10];
    int i;
    ...
    fun2()
    ...
}
```
### Now consider what happens during the execution of this program and answer the following:

### a. Which variables are accessible from within `main()`?
`a, b, e, g` are global variables which are above `main`

`h, i` are local variables

### b. Which variables are accessible from within `fun2()`?
`a, b, e` are global variables which are above `fun2`

`f, ff` are local variables

Note that `g` is a global variable but cannot be accessed as it is below `fun2`

### c. Which variables are accessible from within `fun1()`?
`a, b` are global variables which are above `fun1`

`c, d` are local variables

Note that `e, g` are global variables but cannot be accessed as they are below `fun1`

### d. Which variables are removed when `fun1()` returns?
`c, d`

### e. Which variables are removed when `fun2()` returns?
`f`

Sidenote: `static` variables in a function are like global variables but can only be accessed in the function which they are declared.
The first time a function is called, `static` variables will be initialised to 0 if there is not assignment in the same line as the declaration or whatever value it is assigned to be.
In further calls to the function, the variable will be updated and maintain the value it was between function calls.

### f. How long does the variable `f` exist during program execution?
It will exist whenever `fun2` exists.

When `fun2` calls `fun1`, `fun2` still exists on the stack under `fun1`'s stack so `f` will still exist.
However, when the program returns from `fun2`, `f` will no longer exist.

### g. How long does the variable `g` exist during program execution?
Since `g` is a global variable, it will exist for the entire duration of program execution.


___
### 3.Explain the differences between the properties of the variables s1 and s2 in the following program fragment:
``` C
#include <stdio.h>

char *s1 = "abc";

int main(void) {
    char *s2 = "def";
    // ...
}
```

### Where is each variable located in memory? Where are the strings located?

Memory is structured like this diagram

![0x0000\[ Code | Data | Heap ->         <- Stack\] 0xFFFF](week01.png)

+ Code contains the code which is being executed.
+ Data contains global variables and string literals
+ Heap contains variables which have been dynamically allocated and grows upwards
+ Stack contains information for the functions, including local variables and grows downwards

Since `s1` is a global variables, it is stored in the data segment.

Since `s2` is a local variable, it is stored in the stack.

The string literals are stored in the data segment.

___
### 4. C's `sizeof` operator is a prefix unary operator (precedes its 1 operand) - what are examples of other C unary operators?

operator | name | example | notes
---|---|---|---
\- | unary minus | `int a = -5` | negative number
\+ | unary plus | `int b = +5` | positive number
-- | decrement | `int c = --a` | can be prefix (--x) or postfix (x--)
++ | increment | `int d = b++` | can be prefix (++x) or postfix (x++)
! | logical negation | `if (true == ! false)` | for conditions
~ | bitwise negation | `int e = ~0` | for bit operations
& | address of | `int *f = &e` | gets the address of a variable
\* | indirection | `int g = *f` | gets the value stored at an address

Note: for increment and decrement, prefix and postfix do different things.
- Prefix (++i) means that i will be incremented **before** the rest of the line is performed
- Postfix (i++) means that i will be incremented **after** the rest of the line is performed

Ex
``` C
#include <stdio.h>

int main() {
    int i = 0;
    int j = 0;

    printf("i = %d, j = %d\n", i, j);       // prints out i = 0, j = 0
    printf("i = %d, j = %d\n", ++i, j++);   // prints out i = 1, j = 0
    printf("i = %d, j = %d\n", i, j);       // prints out i = 1, j = 1

    return 0;
}
```

___
### 5. Why is C's `sizeof` operator different to other C unary & binary operators?

`sizeof` can take variable, value or type as an argument.

To use `sizeof` with types, you will need to put brackets around the type.

`sizeof` is a compile time operator.


___
### 7. What is a pointer? How do pointers relate to other variables?

A pointer is a variable that points to another variable.

In C, they store the memory address of the variable they refer to.

Given a pointer, you can access the variable it points to and assign to it.

`&` gives you the address of a variable while `*` allows you to access the value of a variable as an address.

``` C
int a;
int *b = &a;    // set value of b to the address of a

a = 2;          // set value of a to 2
*b = 3;         // access value of b as an address and set the value at that address to 3, this sets value of a to 3
```


___
### 6. Discuss errors in this code:
``` C
struct node *a, *b, *c, *d;
a = NULL;
b = malloc(sizeof b);
c = malloc(sizeof(struct node));
d = malloc(8); // please don't do this
c = a; // c = NULL
d->data = 42;
c->data = 42; // seg fault because dereferencing NULL
```

Since `b` is of type `struct node *`, `*b` is of type `struct node`.
Therefore we should have
``` C
b = malloc(sizeof *b);
```

Need to have brackets around a type when we use `sizeof` so we should have
``` C
c = malloc(sizeof(struct node));
```

While 
``` C
d = malloc(8);
```
could be correct, it is not portable as `struct node` could be of different sizes on different systems, e.g. 8 bytes on a 32-bit OS but 16 bytes on a 64-bit OS.

`d.data` is not correct as `d` is a pointer to a struct. We should have
``` C
d->data = 42;
```

`c->data` is illegal as `c` will be `NULL` when it is executed.


Note: when we have a `struct node`, we should use a `.` operator to access the field. However, when we have a `struct node *`, we should use a `->` operator to access the field.
``` C
struct node {
    int data;
    ...
};

struct node e;
e.data;             // since e is a struct node, we use .

struct node *f;
f->data;            // since f is a struct node *, we use ->
                    // f->data is equivalent to (*f).data
```


___
### 9. Consider the following pair of variables
``` C
int  x;  // a variable located at address 1000 with initial value 0
int *p;  // a variable located at address 2000 with initial value 0
```

### If each of the following statements is executed in turn, starting from the above state, show the value of both variables after each statement:

### If any of the statements would trigger an error, state what the error would be.

| label | x | p |
|:--:|:--:|:---:|
| address | 1000 | 2000 |

### a.
``` C
p = &x;
```
Set `p` to the address of `x` which is 1000.

`x = 0, p = 1000`

### b.
```C
x = 5;
```
Set `x` to 5.

`x = 5, p = 1000`

### c.
``` C
*p = 3;
```
Set the variable at the address pointed to by `p` to 3.
Since `p` points to `x`, set `x` to 3.

`x = 3, p = 1000`

### d.
``` C
x = (int)p;
```
`(int) p` means casting the variable `p` to an `int`, so treating `p` as if it were an `int`.

Set `x` to the `p` casted as an int.

`x = 1000, p = 1000`

### e.
``` C
x = (int)&p;
```
Set `x` to the address of `p` casted as an int.
The address of `p` is 2000.

`x = 2000, p = 1000`

### f.
``` C
p = NULL;
```
Set `p` to `NULL`.

`x = 2000, p = NULL`

### g.
``` C
*p = 1;
```
Set the address pointed to by `p` to 1.

Since `p` points to `NULL` and `NULL` cannot be accessed, we will get an error for dereferencing a `NULL` pointer

___
### 10. Consider the following C program:
``` C
#include <stdio.h>

int main(void)
{
    int nums[] = {3, 1, 4, 1, 5, 9, 2, 6, 5, 3};
    for (int i = 0; i < 10; i++) {
        printf("%d\n", nums[i]);
    }
    return 0;
}
```
### This program uses a `for` loop to print each element in the array
### Rewrite this program using a [recursive function](https://en.wikipedia.org/wiki/Recursion_(computer_science))

A recursive function is a function that calls itself.

Any iterative loop (`for` or `while` loop) can be written as a recursive function.

The key elements of a recursive function are:
+ a base step (where the recursion stops)
+ actions which are taken at each specific stage of the recurstion
+ a recursive call (where the function calls itself)

``` C
#include <stdio.h>

void print_array(int nums[10], int index) {
    // base case (when it'll stop)
    if (index > 9) {
        return;
    }

    // calculation / steps
    printf("%d\n", nums[index]);

    // recursion (when it calls itself)
    print_array(nums, index + 1);
}

int  main() {
    int nums[] = {3, 1, 4, 1, 5, 9, 2, 6, 5, 3};
    print_array(nums, 0);
    return 0;
}

```
___
### For Loops

A `for` loop consists of 3 parts,
- Initialisation of the loop variable
- End condition (when you want to stop looping)
- Update statement (action to perform to loop variable to for next iteration of the loop)

``` C
for (int i = 0; i < 10; i++) {
    // steps to loop over
}

/* In the for loop structure, the
int i = 0; // does initialisation
i < 10;    // is the condition for it to stop
i++        // updates the loop variable
*/

// This while loop is equivalent to the for loop above
int j = 0;
while (j < 10) {
    // steps to loop over
    j++;
}

```

Sometimes, a `for` loop can be used to make a `while` loop simpler.

One subtle difference in the earlier examples is that since `i` is declared in the `for` loop, it will only exist within the `for` loop.
However, `j` is declared before the `while` loop so it will still exist after the `while` loop.
If you want to use `i` after the `for` loop, just declare `i` above the for loop and initialise it as usual.