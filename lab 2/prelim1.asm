	.data
ask_size:	.asciiz "Enter size: "
ask_element:	.asciiz "Enter the element: "
print_array:	.asciiz "Array: "
endl:		.asciiz "\n"
space:		.asciiz " "
invalid_message:.asciiz "Invalid input. Enter a positive integer.\n"
helper_freq1:	.asciiz "Index "
helper_freq2:	.asciiz ": "
FreqTable:       .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  

	.text 
.globl Main

Main:
	jal CreateArray
	addi $t0, $v0, 0 #t0 -> address
	addi $t1, $v1, 0 # t1 -> size
	addi $a0, $t0, 0 #putting as arguments for FindFreq
	addi $a1, $t1, 0
	la $a2, FreqTable
	jal FindFreq
	jal FreqPrinter
	addi $v0,$0, 10 #finisher
	syscall
	
	
    	
CreateArray:
	#address -> $v0, size -> $v1
	#size process
    	addi $v0,$0  4
    	la $a0, ask_size
    	syscall
   	addi $v0, $0, 5
    	syscall
    	addi $s0, $v0, 0   #size -> s0
    	
    	#allocation of memory
    	mul $a0, $s0, 4 # a0 -> num of bytes to allocate
    	addi $v0, $0 ,9
    	syscall 
    	
    	addi $v1, $s0, 0 # v1 -> size, v0 already contains addr of array
    	
    	#go to initialize array, by passing arguments
    	addi $a0, $v0, 0 #a0 -> addr
    	addi $a1, $v1, 0#a1 -> size
    	sw $ra, 0($sp)
    	sub $sp, $sp, 4 
    	jal InitializeArray
    	addi $sp, $sp, 4
    	lw $ra, 0($sp)
    	jr $ra
    	
InitializeArray:
	add $s0, $a0, $0 # s0 -> addr
	add $s1, $a1, $0 # s1 -> size
	add $s2, $0, $0  # s2 -> ctr
	init_loop:
    		beq $s2, $s1, end_init   #If s1(size) == s2(ctr), exit loop	
    		input_loop:
    			li $v0, 4
    			la $a0, ask_element
    			syscall
   			li $v0, 5
    			syscall
    			addi $s4, $v0, 0               # s4 -> input value
    			bltz $s4, input_invalid 	# check negative
    			# current address
    			sll $s5, $s2, 2            # offset(s5) = index(s2) * 4 (size of int)
    			add $s6, $s0, $s5         # s6(addr to put value) = s0(first addr) + s5 (offset)
    			sw $s4, 0($s6)
    			addi $s2, $s2, 1           # s2 = s2 + 1(incr ctr)
    			j init_loop
    		input_invalid:
        		li $v0, 4
        		la $a0, invalid_message
        		syscall
        		j input_loop
	end_init:

	printing_array:
	li $v0, 4
    	la $a0, print_array
    	syscall
    	#we only have valid s0 and s1, we can use other s'.
    	addi $s2, $0, 0 # s2 -> ctr
    	print_array_loop:
    		beq $s2, $s1, print_array_loop_end  #If s1(size) == s2(ctr), exit loop	
    		# current address
    		sll $s4, $s2, 2            # offset(s4) = index(s2) * 4 (size of int)
    		add $s5, $s0, $s4           # s4(addr to read value) = s0(first addr) + s4 (offset)
    		lw $s6, 0($s5)           

    		addi $a0, $s6, 0              
    		li $v0, 1                  
    		syscall

    		addi $v0, $0, 4
    		la $a0, space
    		syscall

    		addi $s2, $s2, 1            # s2 = s2 + 1(incr ctr)
			
    		j print_array_loop

	print_array_loop_end:
	# Print a newline
    	addi $v0, $0, 4
   	la $a0, endl
    	syscall
   	addi $v0, $s0, 0 #size
    	addi $v1, $s1, 0 #addr
    	jr $ra
    	
FindFreq:
	li $s0, 0 # s0 -> ctr

	freq_loop:
		beq $s0, $a1, freq_loop_end

		sll $s1, $s0, 2 # s1 -> offset
		add $s2, $a0, $s1 #s2-> current address
		lw $s3, 0($s2) # s3 -> current value
	
		beq $s3, 0, equal_0
		beq $s3, 1, equal_1
		beq $s3, 2, equal_2
		beq $s3, 3, equal_3
		beq $s3, 4, equal_4
		beq $s3, 5, equal_5
		beq $s3, 6, equal_6
		beq $s3, 7, equal_7
		beq $s3, 8, equal_8
		beq $s3, 9, equal_9
		j gt9

	equal_0:
		lw $s4, 0($a2)
		addi $s4, $s4, 1
		sw $s4, 0($a2)
		j cont_to_freq

	equal_1:
		lw $s4, 4($a2)
		addi $s4, $s4, 1
		sw $s4, 4($a2)
		j cont_to_freq

	equal_2:
		lw $s4, 8($a2)
		addi $s4, $s4, 1
		sw $s4, 8($a2)
		j cont_to_freq

	equal_3:
		lw $s4, 12($a2)
		addi $s4, $s4, 1
		sw $s4, 12($a2)
		j cont_to_freq

	equal_4:
		lw $s4, 16($a2)
		addi $s4, $s4, 1
		sw $s4, 16($a2)
		j cont_to_freq

	equal_5:
		lw $s4, 20($a2)
		addi $s4, $s4, 1
		sw $s4, 20($a2)
		j cont_to_freq
	
	equal_6:
		lw $s4, 24($a2)
		addi $s4, $s4, 1
		sw $s4, 24($a2)
		j cont_to_freq

	equal_7:
		lw $s4, 28($a2)
		addi $s4, $s4, 1
		sw $s4, 28($a2)
		j cont_to_freq

	equal_8:
		lw $s4, 32($a2)
		addi $s4, $s4, 1
		sw $s4, 32($a2)
		j cont_to_freq

	equal_9:
		lw $s4, 36($a2)
		addi $s4, $s4, 1
		sw $s4, 36($a2)
		j cont_to_freq

	gt9:
		lw $s4, 40($a2)
		addi $s4, $s4, 1
		sw $s4, 40($a2)

	cont_to_freq:
		addi $s0, $s0, 1
		j freq_loop

	freq_loop_end:

	jr $ra
	
FreqPrinter:
	la $s0, FreqTable         # s0 -> addr of freq table
	addi $s1, $0, 0         # s1 -> ctr

	freq_print_loop:
		beq $s1, 11, freq_print_loop_end

		li $v0, 4
		la $a0, helper_freq1      # "Index "
		syscall

		move $a0, $s1             # print index
		li $v0, 1
		syscall

		li $v0, 4
		la $a0, helper_freq2      # ": "
		syscall

		sll $s2, $s1, 2           # s2 -> offset
		add $s3, $s2, $s0         # s3 -> current address
		lw $s4, 0($s3)            # s4 -> current frequency value

		move $a0, $s4             # print current frequency value
		li $v0, 1
		syscall

		li $v0, 4
		la $a0, endl              # print \n
		syscall

		addi $s1, $s1, 1          # s1++
		j freq_print_loop

	freq_print_loop_end:
	jr $ra
