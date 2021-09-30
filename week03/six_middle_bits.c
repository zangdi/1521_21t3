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

int main(void) {

}