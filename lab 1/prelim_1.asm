.data
ask_element_num:   .asciiz "Enter the number of elements: "
ask_element:       .asciiz "Enter element: "
show_arr_before:   .asciiz "Given array: "
show_arr_after:    .asciiz "Swapped array: "
new_line:	   .asciiz "\n"
print_space:	   .asciiz " "

	.align 4
arr:    .space 80


	.text
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
    	
    	#DISPLAYING BEFORE SWAPPING
    	li $v0, 4                  # system call to print
    	la $a0, show_arr_before
    	syscall
    	li $t0, 0		# t0 -> index of elements
    	la $t1, arr             #t1 -> current addres
    	show_before_swap_loop:
    		beq $t0, $s0, show_before_swap_loop_end
    		lw $a0, 0($t1)
    		li $v0, 1                 # printing an integer
    		syscall
    		
    		li $v0, 4                 # printing space
    		la $a0, print_space
    		syscall
    		
    		addi $t0, $t0, 1
    		addi $t1, $t1, 4
    		j show_before_swap_loop
    	show_before_swap_loop_end:            
    	li $v0, 4                 # printing new line
    	la $a0, new_line
    	syscall
    		
    	#SWAPPING
    	li $s1, 2
    	div $s0, $s1
    	mflo $s1                 # s1 = n/2  (number of swap)
    	li $t0, 0		# t0 -> index to take elements
    	la $t1, arr             #t1 -> addres of element in the lower side
    	
    	subi $t3, $s0, 1 
    	sll $t4, $t3, 2
    	add $t2, $t4, $t1	#t2 -> address of element in the upper side   (t2=(n-1)*4+addr(arr)) 
    	swap_loop:
    		beq $t0, $s1, swap_loop_end
    		#swapping
    		lw $a0, 0($t1) 
    		lw $a1, 0($t2)
    		sw $a0, 0($t2)
    		sw $a1, 0($t1)
    		#indexes handled
    		addi $t0, $t0, 1
    		addi $t1, $t1, 4
    		subi $t2, $t2, 4
    		j swap_loop
    	swap_loop_end:        
    	
    	#DISPLAYING AFTER SWAPPING
    	li $v0, 4                  # system call to print
    	la $a0, show_arr_after
    	syscall
    	li $t0, 0		# t0 -> index of elements
    	la $t1, arr             #t1 -> current addres
    	show_after_swap_loop:
    		beq $t0, $s0, show_after_swap_loop_end
    		lw $a0, 0($t1)
    		li $v0, 1                 # printing an integer
    		syscall
    		
    		li $v0, 4                 # printing space
    		la $a0, print_space
    		syscall
    		
    		addi $t0, $t0, 1
    		addi $t1, $t1, 4	#indexes handled
    		j show_after_swap_loop
    	show_after_swap_loop_end:        	
    	li $v0, 10                # system call to exit
    	syscall
    	
    	
    	
