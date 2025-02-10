	.data
ask_number1:	.asciiz "Enter Number 1: "
ask_number2:	.asciiz "Enter Number 2: "
print_hex1:	.asciiz "Hex form of register1: "
print_hex2:	.asciiz "Hex form of register2: "
print_hamming:	.asciiz "The hamming distance: "
ask_cont:	.asciiz "Enter 0 if you want to continue, 1 if you want to exit: "
bye_string:	.asciiz "\nGoodbye!\n"
endl:		.asciiz "\n"
	.text 
.globl main

main:
	jal ask_numbers
	la $a0, bye_string
	addi $v0, $0, 4
	syscall
	addi $v0, $0, 10
	syscall
ask_numbers:
	sw $ra, 0($sp)
	sub $sp, $sp, 4
	
	keep_cont_to_ask:
	
	addi $v0, $0 ,4
    	la $a0, ask_number1
 	syscall
 	addi $v0, $0, 5
    	syscall
    	addi $s0, $v0, 0 #s0 -> first number
    	
    	la $a0, ask_number2
    	addi $v0, $0, 4
 	syscall
 	addi $v0, $0, 5
    	syscall
    	addi $s1, $v0, 0 #s1 -> second number
    	
    	addi $v0, $0 ,4
    	la $a0, print_hex1
 	syscall
 	addi $a0, $s0, 0
 	li $v0, 34
    	syscall   

	addi $v0, $0, 4
    	la $a0, endl
 	syscall   # prints first hex

	addi $v0, $0, 4
    	la $a0, print_hex2
 	syscall
 	addi $a0, $s1, 0
 	addi $v0, $0, 34
    	syscall
    	
    	addi $v0, $0 ,4
    	la $a0, endl
 	syscall     # prints second hex
    	
    	
    	addi $a0, $s0, 0
    	addi $a1, $s1, 0
	jal CalculateDistance
	addi $s2, $v0, 0 #s2 -> hamming distance
	
	addi $v0, $0, 4
    	la $a0, print_hamming
 	syscall
 	addi $v0, $0, 1
 	addi $a0, $s2, 0
    	syscall 
    	
    	addi $v0, $0 ,4
    	la $a0, endl
 	syscall   #print hamming
    	
    	#ask whether to cont:
    	addi $v0, $0 ,4
    	la $a0, ask_cont
 	syscall
 	
 	addi $v0, $0 ,5
 	syscall
 	
 	beq $v0, $0, keep_cont_to_ask
    	
    	
	addi $sp, $sp, 4
	lw $ra, 0($sp)
	jr $ra
	
	
	
CalculateDistance:
	addi $v0, $0, 0
	xor $s0, $a0, $a1 #s0 -> the diff ones are 1
	addi $s1, $0, 0 #s1->ctr
	
	dist_loop:
	
		beq $s1, 32, dist_loop_end
		and $s2, $s0, 1
		beq $s2, $0, dont_incr
		addi $v0, $v0, 1
	dont_incr:
		addi $s1, $s1, 1
		srl $s0, $s0, 1
		j dist_loop
	
	dist_loop_end:
	
	jr $ra






















