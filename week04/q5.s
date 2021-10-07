        .text
main:
        li              $v0, 4          # indicate print string
        la              $a0, prompt     # load address of prompt into $a0
        syscall                         # printf("Enter ...");

        li              $v0, 5          # indicate read integer
        syscall 
        move 	        $t0, $v0        # scanf("%d", &x);
                                        # store x in register $t0

        la              $t1, small_big  # store message in $t1
        
        ble             $t0, 100, do_print      # if $t0 <= 100 then goto do_print
        bge             $t0, 1000, do_print     # if $t0 >= 1000 then goto do_print
        
        la              $t1, medium     # set message to medium
        
do_print:
        li              $v0, 4          # indicate print string
        move 	        $a0, $t1
        syscall

        li              $v0, 0
        jr              $ra             # return 0;

        .data
prompt:
        .asciiz "Enter a number: "

small_big:
        .asciiz "small/big\n"

medium:
        .asciiz "medium\n"
