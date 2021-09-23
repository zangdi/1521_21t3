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