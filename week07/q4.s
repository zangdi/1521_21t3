        .text
main:
# does the save of the $ra and $s0-$s7 that we use
main__prologue:
        addiu   $sp, $sp, -4            # create space to store $ra
        sw      $ra, 0($sp)             # store $ra onto the stack

# actual logic for main
main__body:
        li      $a0, 11                 # place 11 into argument 1
        li      $a1, 13                 # place 13 into argument 2
        li      $a2, 17                 # place 17 into argument 3
        li      $a3, 19                 # place 19 into argument 4
        jal     sum4                    # sum4(11, 13, 17, 19)

        move    $a0, $v0                # put z in argument to print ($a0)
        li      $v0, 1                  # syscall number to print integer
        syscall                         # printf("%d", z);

        li      $v0, 11                 # syscall number to print character
        li      $a0, '\n'               # put '\n' in argument to print
        syscall                         # printf("\n")

# places $ra and saved off $s0-$s7 back into the registers
main__epilogue:
        lw      $ra, 0($sp)             # load $ra back from the stack
        addiu   $sp, $sp, 4             # restore stack to original position

        li      $v0, 0                  # load 0 into return register
        jr      $ra                     # return 0



sum4:
sum4__prologue:
        addiu   $sp, $sp, -4            # create space to store $ra
        sw      $ra, 0($sp)             # store $ra onto the stack

        addiu   $sp, $sp, -4            # create space to store $s0
        sw      $s0, 0($sp)             # store $s0 onto the stack

        addiu   $sp, $sp, -4            # create space to store $s1
        sw      $s1, 0($sp)             # store $s1 onto the stack

        addiu   $sp, $sp, -4            # create space to store $s2
        sw      $s2, 0($sp)             # store $s2 onto the stack

sum4__body:
        move    $s0, $a2                # store c in $s0
        move    $s1, $a3                # store d in $s1

        move    $a0, $a0                # place a into argument 1
        move    $a1, $a1                # place b into argument 2
        jal     sum2                    # sum2(a, b)

        move    $s2, $v0                # store e in $s2

        move    $a0, $s0                # place c into argument 1
        move    $a1, $s1                # place d into argument 2
        jal     sum2                    # sum2(c, d)

        move    $a0, $s2                # place e into argument 1
        move    $a1, $v0                # place f into argument 2
        jal     sum2                    # sum2(e, f)

sum4__epilogue:
        lw      $s2, 0($sp)             # load $s0 back from the stack
        addiu   $sp, $sp, 4             # restore stack to before $s2 was placed

        lw      $s1, 0($sp)             # load $s1 back from the stack
        addiu   $sp, $sp, 4             # restore stack to before $s1 was placed

        lw      $s0, 0($sp)             # load $s2 back from the stack
        addiu   $sp, $sp, 4             # restore stack to before $s0 was placed

        lw      $ra, 0($sp)             # load $ra back from the stack
        addiu   $sp, $sp, 4             # restore stack to original position

        # don't need to load result because sum2(e, f) is already stored in $v0
        jr      $ra                     # return sum2(e, f)



sum2:
sum2__prologue:
# empty because it doesn't call any functions


sum2__body:
        add     $t0, $a0, $a1           # calculate x+y and store in $t0

sum2__epilogue:
        move    $v0, $t0                # stores x + y in return register
        jr      $ra                     # return x + y
