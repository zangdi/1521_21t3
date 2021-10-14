        .text
main:
        li      $t0, 0                  # store row in $t0

loop1:
        bge     $t0, 6, end1

        li      $t1, 0                  # store col in $t1

loop2:
        bge     $t1, 12, end2

        # remember that flattened index of arr[i][j] is ((i * COL) + j)
        mul     $t2, $t0, 12            # store start of ith row in $t2
        add     $t3, $t2, $t1           # store index of flattened version of flag in $t3

        lb      $a0, flag($t3)          # store flag[row][col] as argument in $a0
        li      $v0, 11                 # syscall number for printing character
        syscall                         # printf("%c", flag[row][col])

        addi    $t1, $t1, 1             # coll++

        b       loop2

end2:
        li      $v0, 11                 # syscall number for printing character
        li      $a0, '\n'               # load newline character into $a0
        syscall                         # printf("\n")

        addi    $t0, $t0, 1             # row++

        b       loop1

end1:
        li      $v0, 0
        jr      $ra                     # return 0;


        .data
flag:
        .byte   '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'
        .byte   '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'
        .byte   '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
        .byte   '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
        .byte   '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'
        .byte   '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'
