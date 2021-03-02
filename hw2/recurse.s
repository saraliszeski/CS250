.text


main:
    li $v0, 4           
    la $a0, prompt
    syscall

    li $v0, 5   
    syscall
   
    move $s1, $v0 
    li $v0, 0
    move $s0, $s1
     

    add $sp, $sp, -12
    sw $ra, 8($sp)
    beqz $s1, clean
    lw $ra, 8($sp)
    jal func
    j final
    

func: 
    addi $sp, $sp, -12
    sw $ra, 8($sp)
    sw $s1, 4($sp)
    bnez $v0, continued
    bnez $s1, rest
    li $v0, 5
    jal clean

rest:
    addi $s1, $s1, -1
    jal func



continued:
    
    lw $t1, 4($sp) #load n
    li $t3, 2
    mul $v0, $v0, $t3 #2*f(n-1)
    li $t2, 4 #4
    addi $t1, $t1, 1    #n+1
    mul $t1, $t2, $t1 #4(n+1)
    move $t2,$v0 #2*f(n-1)
    add $t2,$t1, $t2 #puts result in $s2
    addi $t2, $t2, -2 #4(N+1) + 2(F(N-1))-2
    move $v0, $t2 

clean:
    lw $ra, 8($sp)
    addi $sp, $sp, 12
    jr $ra

final1:
    j final
final:
    move $a0, $v0
    li $v0, 1           #print prompt
    syscall
    li $v0, 10              # terminate program run and
    syscall

exit:


.data
prompt: .asciiz "Please enter an integer:"

.end