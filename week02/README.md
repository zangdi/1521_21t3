# Week 2 Tute

### 1. When should the types in stdint.h be used:
``` C
#include <stdint.h>

                 // range of values for type
                 //             minimum               maximum
    int8_t   i1; //                 -128                  127
    uint8_t  i2; //                    0                  255
    int16_t  i3; //               -32768                32767
    uint16_t i4; //                    0                65535
    int32_t  i5; //          -2147483648           2147483647
    uint32_t i6; //                    0           4294967295
    int64_t  i7; // -9223372036854775808  9223372036854775807
    uint64_t i8; //                    0 18446744073709551615
```

Use these when you want to ensure a specific size and if you want it to be signed or not.

___
### 2. How can you tell if an integer constant in a C program is decimal (base 10), hexadecimal (base 16), octal (base 8) or binary (base 2)?

- Hexadecimal: 0x1234567890ABCDEF
- Octal: 012345670
- Binary: Does not exist in standard C (gcc offers 0b but don't use it)
- Decimal: Number that starts with not a 0

### Sidenote: do you think this is good language design?

### Language trivia: what base is the constant 0 in C?

### Show what the following decimal values look like in 8-bit binary, 3-digit octal, and 2-digit hexadecimal:

| part | decimal | binary | octal | hexadecimal |
|:---:|:---:|:---:|:---:|:---:|
| a | 1 | 0000 0001 | 001 | 01 |
| b | 8 | 0000 1000 | 010 | 08 |
| c | 10 | 0000 1010 | 012 | 0A |
| d | 15 | 0000 1111 | 017 | 0F |
| e | 16 | 0001 0000 | 020 | 10 |
| f | 100 | 0110 0100 | 144 | 64 |
| g | 127 | 0111 1111 | 177 | 7F |
| h | 200 | 1100 1000 | 310 | C8 |

``` C
// prints decimal, octal and hex
printf("%d %o %x\n", 1, 1, 1);
```


___
## Bitwise Operations
| symbol | name | what it does |
|:---:|:---:|---|
| \| | or | a \| b -> every bit that is set in either a or b is set |
| \& | and | a \& b -> every bit that is set in both a and b is set |
| \~ | not | ~a -> flips the bits (1s in a turn into 0, 0s in a turn into 1) |
| ^ | xor | a ^ b -> every bit is different in a and b is set |
| << | left shift | a << b -> move all the bits in a by b to the left |
| >> | right shift | a >> b -> move all the bits in a by b to the right |


___
### 3. Assume that we have the following 16-bit variables defined and initialised:
``` C
uint16_t a = 0x5555, b = 0xAAAA, c = 0x0001;
```
### What are the values of the following expressions:
### Give your answer in hexadecimal, but you might find it easier to convert to binary to work out the solution.


| part | expression | binary | hexadecimal |
|:---:|:---:|:---:|:---:|
| a | a \| b | 1111 1111 1111 1111 | 0xFFFF |
| b | a & b | 0000 0000 0000 0000 | 0x0000 |
| c | a ^ b | 1111 1111 1111 1111 | 0xFFFF |
| d | a & ~b | 0101 0101 0101 0101 | 0x5555 |
| e | c << 6 | 0000 0000 0100 0000 | 0x0040 |
| f | a >> 4 | 0000 0101 0101 0101 | 0x0555 |
| g | a & (b << 1) | 0101 0101 0101 0100 | 0x5554 |
| h | b \| c | 1010 1010 1010 1011 | 0xAAAB |
| i | a & ~c | 0101 0101 0101 0100 | 0x5554 |

### How could I write a C program to answer this question?

``` C
printf("%x", a | b);
```


___
### 6. Given the following type definition
```C
typedef unsigned int Word;
```
### Write a function
```C
Word reverseBits(Word w);
```
### which reverses the order of the bits in the variable w.
### For example: If `w == 0x01234567`, the underlying bit string looks like:
``` C
0000 0001 0010 0011 0100 0101 0110 0111
```
### which, when reversed, looks like:
```C
1110 0110 1010 0010 1100 0100 1000 0000
```
### which is `0xE6A2C480` in hexadecimal.

``` C
#include <stdio.h>

typedef unsigned int Word;

// and with bit mask to extract the bits
// or with bit mask to set the bits

// any 4 digit binary number can be made up of performing or with 0 and the following digits:
// 1000
// 0100
// 0010
// 0001

// e.g. 1010 = (0000 | 1000) | 0010
// e.g. 1111 = (((0000 | 1000) | 0100) | 0010) | 0001

// this can be extended to binary numbers with any number of digits

Word reverseBits(Word w) {
    // loop through every bit in w

    // if the nth bit from the left is set
    // then we want make a mask with the bit nth bit from the right set
    // and or this with the number that we have so far
    Word res = 0;
    int size = 32;

    for (int i = 0; i < size; i++) {

        //                               the 1 is i + 1 bits from the right
        // e.g. mask will look like 0000 0000 0000 0000 0000 0000 0010 0000
        Word mask = 1 << i;

        // 
        if (w & mask) { // if your condition is 0, false, not 0, true

        //                              the 1 is i + 1 bits from the left
        // or_mask will look like 0000 0100 0000 0000 0000 0000 0000 0000
            Word or_mask = 1 << (size - 1 - i);


        // res looks like 1110 0000 0000 0000 0000 0000 0000 0000
            res = res | or_mask;
        // res looks like 1110 0100 0000 0000 0000 0000 0000 0000
        
        }
    }

    return res;
}

int main(void) {

    Word w = 0x01234567;
    Word reversed = reverseBits(w);

    // fun note: upper case X gives you upper case letters .e.g 0-9A-F
    // lower case x gives you lower case letters 0-9a-f
    printf("%X\n", reversed);

    return 0;
}
```
