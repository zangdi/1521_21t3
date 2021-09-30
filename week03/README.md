# Week 3 Tute

### 1. On a machine with 16-bit ints, the C expression `(30000 + 30000)` yields a negative result.
### Why the negative result? How can you make it produce the correct result?

Since it's bigger 2^15

We can use 32 bit integer or unsigned 16 bit
___
## Twos-complement

Converting from binary to decimal
1. Flip all the bits
2. Add 1 to the result
3. Convert from binary to decimal
4. Put a minus sign in front

Converting from decimal to binary
1. Get rid of the minus sign
2. Subtract 1
3. Represent it in binary
4. Flip all the bits

___
### 2. Assume that the following hexadecimal values are 16-bit twos-complement. Convert each to the corresponding decimal value.

| part | hexadecimal | twos complement | flipped | decimal |
|:---:|:---:|:---:|:---:|:---:|
| i | 0x0013 | 0000 0000 0001 0011 | - | 19 |
| iv | 0xffff | 1111 1111 1111 1111 | 0000 0000 0000 0001 | -1
| v | 0x8000 | 1000 0000 0000 0000 | 1000 0000 0000 0000 | -32768



___
### 3. Give a representation for each of the following decimal values in 16-bit twos-complement bit-strings. Show the value in binary, octal and hexadecimal.
| part | decimal | binary | octal | hexadecimal |
|:---:|:---:|:---:|:---:|:---:|
| ii | 100 | 0000 0000 0110 0100 | 0144 | 0x64
| iv | 10000 | 0010 0111 0001 0000 | 023420 | 0x2710
| v | 100000 | too big, can't fit in 16bit
| vi | -5 | 1111 1111 1111 1011 | 0177773 | 0xFFFB
| vii | -100 | 1111 1111 1001 1100 | 0177634 | 0xFF9C

___
## Floating Point Representation

32 bits

sign, exponent, fraction

* sign -> top bit
* exponent -> next 8 bits
* fraction -> remaining 23 bits

Binary to float
* Sign: 1 means negative, 0 means positive
* Exponent: Convert into a binary number (0 - 256)
  * Bias = 127
* Fraction: Adding negative powers of 2 starting from 2^-1
* (-1)^sign * 2^(exponent - bias) * (1 + fraction)


Float to binary
* Sign: 1 if negative, 0 if positive
* Exponent: calculate largest power of 2 so that fraction is between 1 and 2
* Fraction: Figure out sum of negative powers of 2 to get result

Special numbers
- 0 - you can have +0 or -0, need exponent and fraction to be all 0s
- infinity: you can have + or - infinity, need exponent all 1s and fraction to be all 0s
- nan (not a number): exponent all 1s, fraction not all 0s

___
### 4. What decimal numbers do the following single-precision IEEE 754-encoded bit-strings represent?
### Each of the following are a single 32-bit bit-string, but partitioned to show the sign, exponent and fraction parts.
| part | string | decimal |
|:---:|:---:|:---:|
| a | 0 00000000 00000000000000000000000 | 
| b | 1 00000000 00000000000000000000000 | 
| c | 0 01111111 10000000000000000000000 | 1.5
| d | 0 01111110 00000000000000000000000 | 0.5
| e | 0 01111110 11111111111111111111111 | 
| f | 0 10000000 01100000000000000000000 | 2.75
| g | 0 10010100 10000000000000000000000 | 
| h | 0 01101110 10100000101000001010000 | 

#### c)
Sign = 0 -> positive

Exponent = 0111 1111 -> 127

Fraction = 10000000000000000000000 -> 0.5

```
(-1)^0 * 2^(127-127) * (1 + 0.5)
= 1 * 2^0 * 1.5
= 1.5
```

#### d)
Exponent = 01111110 -> 126

Fraction = 0

```
(-1)^0 * 2^(126-127) * (1 + 0)
= 1 * 0.5 * 1
= 0.5
```

#### f)
Exponent = 10000000 -> 128

Fraction 01100000000000000000000 -> 2^(-2) + 2(-3) = 0.25 + 0.125 = 0.375

```
(-1)^0 * 2^(128 - 127) * (1 + 0.375)
= 1 * 2 * 1.375
= 2.75
```

___
### 5. Convert the following decimal numbers into IEEE 754-encoded bit-strings:
| part | decimal | string |
|:---:|:---:|:---:|
| a | 2.5 | 0 10000000 01000...
| b | 0.375 | 0 01111101 1000...
| c | 27.0 | 0 10000011 1011000...
| d | 100.0 | 

#### a)
power of 2 so that the decimal is between 1 and 2

Sign: 0 (positive)

Exponent: need 2^(exponent - 127) = 2 -> exponent = 128 -> 10000000

Fraction: 2.5/2 = 1.25 -> need 0.25 -> 2^(-2) = 0100....


#### b)
Exponent: need 2^2 * 0.375 = 1.5 -> 2^(-2) * 1.5 = 0.375 -> -2 = exponent - 127 -> exponent = 125

Fraction: 1.5 -> need 0.5 -> 2^(-1) = 0.5 -> 100...


#### c)
Exponent: 27/(2^4)  = 1.6875 -> need exponent - 127 = 4 -> exponent = 131

Fraction: 1.6875 -> need 0.6875 -> 1011000...

___
### 6. Write a C function, `six_middle_bits`, which, given a `uint32_t`, extracts and returns the middle six bits.

``` C
#include <stdio.h>
#include <stdint.h>

// 31                       0
//  0001001...001011....00010 -> sample number

// 00000...0001001...001011 -> shifted down

// 000000........111111 -> 6 bit mask
// 000000........001011 -> shifted number and with mask

// shift to the right by 13 to move bits down the the right position
// and with 6 bit mask to extract the bits
uint32_t six_middle_bits(uint32_t num) {
    uint32_t mask = 0x3F;
    uint32_t shifted = num >> 13;
    return shifted & mask;
}
```

___
### 7. Draw diagrams to show the difference between the following two data structures:
``` C
struct {
    int a;
    float b;
} x1;
union {
    int a;
    float b;
} x2;
```
### If `x1` was located at `&x1 == 0x1000` and `x2` was located at `&x2 == 0x2000`, what would be the values of `&x1.a`, `&x1.b`, `&x2.a`, and `&x2.b`?


struct:
- hold a bunch of information

``` C

// sizeof(struct abc) == sizeof(int) + sizeof(float)
struct abc {
    int a;
    float b;
};

struct abc var;
var.a = 1;
var.b = 0.5;

// var.a;     ===> use for when it's not a pointer (just a struct itself)
// var->a;    ===> ues for pointer to a struct

/*

  var
|   a    |   b    |

*/

```

union:
- storing everything in one place


``` C
// sizeof(union def) == max(sizeof(int) + sizeof(float))
union def {
    int d;
    float e;
    char f;
    char[5] g;
};

union def var2;
var2.d = 1;
var2.e = 0.5;

var2
|    d/e      |

```
