        .text
main:
        li      $v0, 5                  # syscall number for read integer
        syscall                         # scanf("%d" -> store number in $v0

        sw      $v0, y                  # stores number read in into y

        addi    $t0, $v0, 2000          # stores y + 2000 in $t0
        addi    $t1, $v0, 3000          # stores y + 3000 in $t1

        mult    $t0, $t1                # multiply large values in $t0 and $t1
                                        # result store in (hi, lo)

        mfhi    $t0                     # grab value out of hi register, store in $t0
        sw      $t0, x                  # place high bits in top 4 bytes of x

        mflo    $t0                     # grab value out of lo register, store in $t0
        sw      $t0, x+4                # place lo bits in bottom 4 bytes of x

                                        # store value into x

        .data
x:
        .space 8
y:
        .space 4
