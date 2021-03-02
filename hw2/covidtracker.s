.text
.align 2
.globl main
main:
	sw $ra, 0($sp)
	li $t4, 0
	move $s6, $sp

readnames:
	beqz $t4, next
	move $a0, $s0
	jal strclr
	move $a0, $s1
	jal strclr

next:
	li $v0, 4
	la $a0, infecteeprompt
	syscall
	li $v0, 8
	la $a0, teename
	li $a1, 15
	syscall #infectee in $v0
	move $s0, $a0 #infectee in $s0
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	jal comparetodone
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	li $v0, 4
	la $a0, infecterprompt
	syscall
	li $v0, 8
	la $a0, tername
	li $a1, 15
	syscall 
	move $s1, $a0#infecter in $s1
	addi $t4, $t4, 1
	li $t3, 1
	beq $t3, $t4, firsttime 
	move $a0, $s5
	move $sp, $s6
	addi $sp, $sp, -8
	addi $s7, $s7, 1
	j checktreeprep

#jumping back to here after checkright

firsttime: #special case to create first node
	li $a0, 64   # $a0 contains the number of bytes you need.      
	li $v0, 9     # code 9 == allocate memory
	syscall
	move $a0, $v0 
	move $s5, $v0#S5 CONTAINS ADDRESS OF FIRST NODE
	sw $zero, 16($a0) #0 is at node.left in struct
	sw $zero, 32($a0)
	move $a1, $s1
	jal strcpy 
	move $a0, $v0
	#li $v0, 4
	#syscall #store infecter at firstnode

createsecond:
	move $t4, $a0
	li $a0, 64   # $a0 contains the number of bytes you need.       # This must be a multiple of four.
	li $v0,9     # code 9 == allocate memory
	syscall
	move $a0, $t4
	sw $v0, 16($a0) #dip into former node, set node.left = address of new node
	move $a0, $v0
	sw $zero, 32($a0)
	sw $zero, 16($a0)
	move $a1, $s0
	jal strcpy
	move $a0, $s0 #load the infectee into $a0 for testprint	
	move $a0, $v0
	j readnames

checktreeprep:
    move $a1, $s1
	addi $sp, $sp, -64
	sw $s1, 0($sp)
	sw $s0, 16($sp)
	sw $s5, 40($sp)
	sw $s6, 44($sp)
    addi $sp, $sp, -32
    sw $a0, 0($sp)
    sw $a1, 16($sp)
    jal strcmp
    lw $a0, 0($sp)
    lw $a1, 16($sp)
    addi $sp, $sp, 32
	lw $s1, 0($sp)
	lw $s0, 16($sp)
	lw $s5, 40($sp)
	lw $s6, 44($sp)
	addi $sp, $sp, 64
    beqz $v0, buildnodeprep

CHECK_TREE:
	addi $sp, $sp, -8
	sw $a0, 4($sp)
    sw $ra, 0($sp)
	#li $v0, 4
	#syscall
check_left:
    lw $t4, 16($a0)
    bnez $t4, next3
    j check_right
    
next3:
	lw $a0, 16($a0)
    addi $sp, $sp, -32
    sw $a0, 0($sp)
    sw $a1, 16($sp)
    jal strcmp
    lw $a0, 0($sp)
    lw $a1, 16($sp)
    addi $sp, $sp, 32
    beqz $v0,buildnodeprep
    jal CHECK_TREE

check_right:
    lw $t4, 32($a0)
    beqz $t4, nonodehereright
    lw $a0, 32($a0)
    addi $sp, $sp, -32
    sw $a0, 0($sp)
    sw $a1, 16($sp)
    jal strcmp
    lw $a0, 0($sp)
    lw $a1, 16($sp)
    addi $sp, $sp, 32
    beqz $v0, buildnodeprep
    jal CHECK_TREE
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	lw $a0, 4($sp)
	jr $ra

nonodehereright:
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	lw $a0, 4($sp)
    jr $ra

buildnodeprep: 
    lw $v0, 16($a0) #was s4
    beqz $v0, buildnodeprepleft #was s4
	b buildnodeprepright
buildnodeprepleft:
	move $t4, $a0
	li $a0,64   # $a0 contains the number of bytes you need.
	li $v0,9     # code 9 == allocate memory
	syscall 
	move $a0, $t4  
	sw $v0, 16($a0) #this is causing issues!-- unaligned address???
	move $a0, $v0 #load the addy of the newest node
	j buildnode

buildnodeprepright:
	addi $sp, $sp, -48
	sw $a0, 0($sp)
	sw $a1, 16($sp)
	sw $v0, 32($sp) #changed this #
	move $a1, $v0 #changed this from $s4
	move $a0, $s0
	jal strcmp #this causes error
	lw $a0, 0($sp)
	lw $a1, 16($sp)
	lw $t1, 32($sp) #changed this!!
	addi $sp, $sp, 48 #changed this #
	bgtz $v0, n
	sw $t1, 32($a0) #changed this from 
	j buildnodeprepleft
n:
	#THIS IS WHERE I STOP EDITING
	move $t4, $a0
	li $a0,64   # $a0 contains the number of bytes you need.
	li $v0,9     # code 9 == allocate memory
	syscall
	move $a0, $t4
	sw $v0, 32($a0)
	li $v1, 0
	move $a0, $v0       # call the service.
                  # $v0 <-- the address of the first byte
                  # of the dynamically allocated block

buildnode:
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	li $t4, 0 #node.right =0
	sw $t4, 16($a0) #0 is at node.left in struct
	sw $t4, 32($a0) 
	move $t4, $a0
	move $a0, $s0
	move $a0, $t4#0 is at node.right in struct
	move $a1, $s0
	jal strcpy
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	j readnames

PRINT_TREE:
	addi $s6, $s6, 1
	addi $sp, $sp, -8
	sw $a0, 4($sp)
    sw $ra, 0($sp)
	li $v0, 4
	syscall
	beq $s6, $s7, exit
print_left:
    lw $t4, 16($a0)
    bnez $t4, next4
    j print_right
    
next4:
	lw $a0, 16($a0)
    jal PRINT_TREE

print_right:
    lw $t4, 32($a0)
    beqz $t4, printnonodehereright
    lw $a0, 32($a0)
    jal PRINT_TREE
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	lw $a0, 4($sp)
	jr $ra

printnonodehereright:
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	lw $a0, 4($sp)
    jr $ra


comparetodone: 
	addi $sp, $sp, -16
	la $a1, done
	sw $s0, 8($sp)
	sw $ra, 0($sp) #what numbers should I be using
	move $a0, $s0
	jal strcmp
	lw $ra, 0($sp)
	lw $s0, 8($sp)
	addi $sp, $sp, 16
	beqz $v0, strtprint 
	jr $ra#for now-- will print in futur
	#j checktree

strtprint:
	move $a0, $s5
	move $sp, $s6
	addi $sp, $sp, -8
	jal PRINT_TREE
	j exit
#this is where I launch tree traversal and printing

strcpy:
	lb $t0, 0($a1)
	beq $t0, $zero, done_copying
	sb $t0, 0($a0)
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	j strcpy

	done_copying:
	jr $ra

# $a0 = dest, $a1 = src
strclr:
	lb $t0, 0($a0)
	beq $t0, $zero, done_clearing
	sb $zero, 0($a0)
	addi $a0, $a0, 1
	j strclr

	done_clearing:
	jr $ra

# $a0, $a1 = strings to compare
# $v0 = result of strcmp($a0, $a1)
strcmp:
	lb $t0, 0($a0)
	lb $t1, 0($a1) #error appearing here

	bne $t0, $t1, done_with_strcmp_loop
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	bnez $t0, strcmp
	li $v0, 0
	jr $ra
		

	done_with_strcmp_loop:
	sub $v0, $t0, $t1
	jr $ra




exit:

li $v0, 10
syscall

.data
infecterprompt: .asciiz "Please enter infecter:"
infecteeprompt: .asciiz "Please enter infectee:"
space: .space 16
teename: .space 16
tername: .space 16
done: .asciiz "DONE\n"
.align 2

.end