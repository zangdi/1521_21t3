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
