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
