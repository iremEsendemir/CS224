	.data
ask_number:	.asciiz "Enter the number for reversing its content bit by bit: "
print_hex_nr:	.asciiz "The number represented in hexadecimal is: "
print_binary_nr:.asciiz "The number represented in binary is: "
print_reversed:	.asciiz "The reversed number is: "
print_hex_r:	.asciiz "The reversed number represented in hexadecimal is: "
print_binary_r: .asciiz "The reversed number represented in binary is: "
ask_cont:	.asciiz "Enter 0 if you want to continue, 1 if you want to exit: "
bye_string:	.asciiz "\nGoodbye!\n"
endl:		.asciiz "\n"
	.text 
.globl main

main:
	jal ask_number_fnc
	la $a0, bye_string
	addi $v0, $0, 4
	syscall
	addi $v0, $0, 10
	syscall
	
	
ask_number_fnc:
	sw $ra, 0($sp)
	sub $sp, $sp, 4
	
	keep_cont_to_ask:
	
	addi $v0, $0 ,4
    	la $a0, ask_number
 	syscall
 	addi $v0, $0, 5
    	syscall
    	addi $s0, $v0, 0 #s0 -> number to reverse
    	
    	
    	addi $v0, $0 ,4
    	la $a0, print_hex_nr
 	syscall
 	addi $a0, $s0, 0
 	li $v0, 34
    	syscall   

	addi $v0, $0, 4
    	la $a0, endl
 	syscall   # prints nonreversed hex

	addi $v0, $0 ,4
    	la $a0, print_binary_nr
 	syscall
 	addi $a0, $s0, 0
 	li $v0, 35
    	syscall   

	addi $v0, $0, 4
    	la $a0, endl
 	syscall   # prints nonreversed binary
    	
    	
    	addi $a0, $s0, 0
    	
	jal ReverseNumber
	addi $s1, $v0, 0 #s2 -> reversed number
	
	addi $v0, $0 ,4
    	la $a0, print_reversed
 	syscall
 	addi $a0, $s1, 0
 	li $v0, 1
    	syscall   

	addi $v0, $0, 4
    	la $a0, endl
 	syscall   # prints reversed decimal
	
	addi $v0, $0 ,4
    	la $a0, print_hex_r
 	syscall
 	addi $a0, $s1, 0
 	li $v0, 34
    	syscall   

	addi $v0, $0, 4
    	la $a0, endl
 	syscall   # prints nonreversed hex

	addi $v0, $0 ,4
    	la $a0, print_binary_r
 	syscall
 	addi $a0, $s1, 0
 	li $v0, 35
    	syscall   

	addi $v0, $0, 4
    	la $a0, endl
 	syscall   # prints nonreversed binary
    	
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
	
	
	
ReverseNumber:
	addi $v0, $0, 0
	addi $s0, $a0, 0 #s0 -> number to reverse
	addi $s1, $0, 0 #s1->ctr
	
	reverse_loop:
	
		beq $s1, 32, reverse_loop_end
		and $s2, $s0, 1 #s2 -> last bit
		sll $v0, $v0, 1
		beq $s2, $0, dont_incr
		addi $v0, $v0, 1
	dont_incr:
		addi $s1, $s1, 1
		srl $s0, $s0, 1
		j reverse_loop
	
	reverse_loop_end:
	
	jr $ra






















