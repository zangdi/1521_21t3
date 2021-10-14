        .text
main:
        li      $t0, 0          # store i in $t0

loop:
        addi    $t0, $t0, 1     # i++

        li      $v0, 1          # syscall number for print integer
        move    $a0, $t0        # stores i in $a0 to print
        syscall                 # printf("%d", i)

        li      $v0, 11         # syscall number for print character
        li      $a0, '\n'       # stores '\n' in $a0 to print
        syscall                 # printf("\n")

        blt     $t0, 10, loop   # if (i < 10) goto loop

        li      $v0, 0
        jr      $ra
