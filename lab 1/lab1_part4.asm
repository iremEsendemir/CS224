.data
ask_element_num:   .asciiz "Enter the number of elements: "
ask_element:       .asciiz "Enter element: "
answer_a:       .asciiz "\nMaximum number: "
answer_b:       .asciiz "\nThe number of occurrences of the maximum value is: "
answer_c:       .asciiz "\nThe number of values that divide the maximum value without a remainder (excluding the maximum itself) is:"
answer_d:       .asciiz "\nGoodbye!\n"
new_line:	.asciiz "\n"
menu:		.asciiz "\nHow can I help you?\na. Find the maximum number stored in the array and display that number.\nb. Find the number of times the maximum number appears in the array.\nc. Find how many numbers we have (other than the maximum number) that we can divide the maximum number without a remainder.\nd. Quit.\nEnter the char please: "

	.align 4
arr:    .space 400


	.text
	#s0 -> num of element, s1-> answer to a, s2-> answer to b, s3 -> answer to C
	#s4 -> a in ascii, s5 -> b in ascii, s6 -> c in ascii
	li $s4, 97
	li $s5, 98
	li $s6, 99
	
	
	li $v0, 4                 # system call to print
	la $a0, ask_element_num
	syscall
	
	li $v0, 5                 # syscall 5 reads an integer
    	syscall
    	move $s0, $v0             # s0 -> num of elements
    	
    	li $t0, 0		# t0 -> index to take elements
    	la $t1, arr             #t1 -> current addres
    	
    	#READING ELEMENTS
    	reading_loop:
    		beq $t0, $s0, reading_loop_end #if t0 == s0(n), finish
    		li $v0, 4                 # system call to print
   		la $a0, ask_element
    		syscall
    		
    		li $v0, 5                # syscall 5 reads an integer
    		syscall
    		sw $v0, 0($t1) 		# storing the read int in the array
    		addi $t1, $t1, 4
    		addi $t0, $t0, 1          # Increment index
    		j reading_loop
    	reading_loop_end:
    	
    	#CALCULATING A
    	li $t0, 0		# t0 -> index to take elements
    	la $t1, arr             #t1 -> current addres
    	lw $t2, 0($t1)		#t2 -> current value
    	move $s1, $t2		# max is set to the first element
    	find_max_loop:
    		beq $t0, $s0, find_max_loop_end
    		bgt $s1, $t2, max_not_found
    		move $s1, $t2
    		max_not_found:
    		addi $t0, $t0, 1
    		addi $t1, $t1, 4
    		lw $t2, 0($t1)
    		j find_max_loop
    	find_max_loop_end:
    	
    	#CALCULATING B
    	li $t0, 0		# t0 -> index to take elements
    	la $t1, arr             #t1 -> current addres
    	li $s2, 0
    	lw $t2, 0($t1)		#t2 -> current value
    	max_occurence_loop:
    		beq $t0, $s0, max_occurence_loop_end #aaaa
    		bne $s1, $t2, not_same
    		addi $s2, $s2, 1
    		not_same:
    		addi $t0, $t0, 1
    		addi $t1, $t1, 4
    		lw $t2, 0($t1)		#t2 -> current value
    		j max_occurence_loop
    	max_occurence_loop_end:
    	
    	#CALCULATING C
    	li $t0, 0		# t0 -> index to take elements
    	la $t1, arr             #t1 -> current addres
    	li $s3, 0
    	rem_zero_loop:
    		beq $t0, $s0, rem_zero_loop_end
    		lw $t2, 0($t1)		#t2 -> current value
    		beq $t2, $0, not_zero 
    		div $s1, $t2
    		mfhi $t3 # t3 -> remainder
    		bne $t3, $0, not_zero
    		addi $s3, $s3, 1
    		not_zero:
    		addi $t0, $t0, 1
    		addi $t1, $t1, 4
    		j rem_zero_loop
    	rem_zero_loop_end:
    	sub $s3, $s3, $s2
    	
    	#DISPLAYING MENU
    	menu_loop:
    		li $v0, 4                 # system call to print
		la $a0, menu
		syscall
	
		li $v0, 12
		syscall # read char
		move $s7, $v0 # s7 -> char is read
	check_a:
		bne $s7, $s4, not_a_check_b
		
		li $v0, 4                 # system call to print
		la $a0, answer_a
		syscall 
		
		li $v0, 1
		move $a0, $s1
		syscall
		
		li $v0, 4                 # system call to print
		la $a0, new_line
		syscall 
		
		j menu_loop
	not_a_check_b:
		bne $s7, $s5, not_b_check_c
		
		li $v0, 4                 # system call to print
		la $a0, answer_b
		syscall 
		
		li $v0, 1
		move $a0, $s2
		syscall
		
		li $v0, 4                 # system call to print
		la $a0, new_line
		syscall
	
		j menu_loop
	not_b_check_c:
		bne $s7, $s6, menu_loop_end
		
		li $v0, 4                 # system call to print
		la $a0, answer_c
		syscall 
		
		li $v0, 1
		move $a0, $s3
		syscall
		
		li $v0, 4                 # system call to print
		la $a0, new_line
		syscall
		
		j menu_loop
	menu_loop_end:
	
	
	li $v0, 4                 # system call to print
	la $a0, answer_d
	syscall
    	li $v0, 10                # system call to exit
    	syscall
    	
