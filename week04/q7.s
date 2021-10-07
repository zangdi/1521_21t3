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
