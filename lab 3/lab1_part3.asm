	.data
ask_B:		.asciiz "Value of B: "
ask_A:		.asciiz "Value of A: "
ask_D:		.asciiz "Value of D: "
print_result: 	.asciiz "Result is: "


	.text
	
	la $a0,ask_A	
	li $v0,4	
	syscall
	li $v0, 5	
	syscall
	move $s0, $v0 #s0 -> A
	
	la $a0,ask_B	
	li $v0,4	
	syscall
	li $v0, 5	
	syscall
	move $s1, $v0 #s1 -> B
	
	#CALCULATING
	addi $t0, $s0, 7
	move $t0, $v0 #t0 = A+7
	
	div $s0, $t0
	mfhi $t1
	move $t1, $v0 #t1= B%(A+7) = B % $t0
	
	sub $t2, $s1, $s0 # t2 = B-A
	
	div $t1, $t2
	mflo $v0  #v0 = t1 / t2
	
	#PRINTING RESULT
	
	la $a0,print_result	
	li $v0,4	
	syscall
	
	move $a0, $s3
	li $v0,1
	syscall
	
	
	li $v0,10  # system call to exit
	syscall	#    bye bye
	
