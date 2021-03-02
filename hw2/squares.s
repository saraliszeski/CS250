.text

main:

    li $v0, 4 #print string
    la $a0, prompt
    syscall
    li $v0, 5
    syscall
    move $t0, $v0
    mul $t1, $t0, $t0
    move $a0, $t1
    li $v0, 1
    syscall
    li      $v0, 10              # terminate program run and
    syscall  
    jr $ra
exit:
                        # Exit 

.data
prompt: .asciiz "Give me a number:"
number: .space 16

.end