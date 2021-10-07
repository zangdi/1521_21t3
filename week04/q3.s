        .text
main:
        li              $v0, 4          # store 4 into $v0
        la              $a0, prompt     # put address of prompt into $a0
        syscall                         # print prompt string

        li              $v0, 5          # store 5 into $v0
        syscall                         # read in integer
        
        move            $t0, $v0        # store x in $t0
        mul             $t1, $t0, $t0   # y = x*x

        li              $v0, 1          # indicate print int
        move 	        $a0, $t1        # store y in $a0 to print
        syscall

        li              $v0, 11         # indicate print character
        li              $a0, '\n'
        syscall

        li              $v0, 0          # store 0 as return value
        jr              $ra             # return;

        .data
prompt:
        .asciiz "Enter a number: "
