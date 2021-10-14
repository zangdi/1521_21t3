        .text
main:
        li      $t0, 0                  # store i in $t0

loop1:
        bge     $t0, 10, end1

        li      $v0, 5                  # syscall number for read integer
        syscall                         # scanf -> integer stored in $v0

        mul     $t1, $t0, 4             # stores offset above numbers (i * 4)
        sw      $v0, numbers($t1)       # numbers[i] = $v0

        addi    $t0, $t0, 1             # i++

        b       loop1

end1:

        li      $t0, 9                  # i = 9
loop2:
        bltz    $t0, end2               # if (i < 0) goto end2
        # blt   $t0, 0, end2

        mul     $t1, $t0, 4             # how much higher &numbers[i] is than &numbers[0]
        lw      $a0, numbers($t1)       # store numbers[i] in $a0 as an argument

        li      $v0, 1                  # syscall number to print integer
        syscall                         # printf("%d", numbers[i])

        li      $v0, 11                 # syscall number to print character
        li      $a0, '\n'               # '\n' as argument to print
        syscall                         # printf("\n")

        addi    $t0, $t0, -1            # i--

        b       loop2

end2:
        li      $v0, 0
        jr      $ra


        .data
numbers:
        .word   0, 0, 0, 0, 0, 0, 0, 0, 0, 0
