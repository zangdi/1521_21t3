        .text
max:
max__prologue:
        addiu   $sp, $sp, -8            # allocate space to store $ra, $s0
        sw      $ra, 0($sp)             # save $ra onto stack
        sw      $s0, 4($sp)             # save $s0 onto stack

max__body:
        lw      $s0, ($a0)              # store first_element in $s0

        beq     $a1, 1, first_element   # if (length == 1) goto first_element;

        addi    $a0, $a0, 4             # store &a[1] in $a0
        addi    $a1, $a1, -1            # store length - 1 in $a1
        jal     max                     # max_so_far is stored in $v0

        ble     $s0, $v0, max__epilogue

        move    $v0, $s0                # max_so_far = first_element
        j       max__epilogue

first_element:
        move    $v0, $s0                # store first_element in return register

max__epilogue:
        lw      $s0, 4($sp)             # reloading $s0 from stack
        lw      $ra, 0($sp)             # reloading $ra from stack
        addiu   $sp, $sp, 8             # place stack back to before $ra and $s0 was stored

        jr      $ra                     # return
