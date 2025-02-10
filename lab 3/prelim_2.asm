	.data
ask_B:		.asciiz "Value of B: "
ask_C:		.asciiz "Value of C: "
ask_D:		.asciiz "Value of D: "
print_result: 	.asciiz "Result is: "


	.text
	
	la $a0,ask_B	
	li $v0,4	
	syscall
	li $v0, 5	
	syscall
	move $s0, $v0 #s0 -> b
	
	la $a0,ask_C	
	li $v0,4	
	syscall
	li $v0, 5	
	syscall
	move $s1, $v0 #s1 -> c
	
	la $a0,ask_D	
	li $v0,4	
	syscall
	li $v0, 5	
	syscall
	move $s2, $v0 #s2 -> d
	
	#CALCULATING
	move $a0, $s0
	move $a1, $s1
	jal division
	move $t0, $v0 #t0 = B/C
	
	move $a0, $s2
	move $a1, $s0
	jal mode
	move $t1, $v0 #t1= D%B 
	
			
	add $t2, $t0, $t1 # t2 = t0 + t1
	sub $t3, $t2, $s1 # t3 = t2 - C
	
	move $a0, $t3
	move $a1, $s0
	jal division
	move $s3, $v0 #s3 = t3/B
	
	#PRINTING RESULT
	
	la $a0,print_result	
	li $v0,4	
	syscall
	
	move $a0, $s3
	li $v0,1
	syscall
	
	
	li $v0,10  # system call to exit
	syscall	#    bye bye
	
	
	division: #v0->a0/a1
    	li $v0, 0           # quotient
    	move $t4, $a0      # t4 = dividend
    	move $t5, $a1      # t5 = divisor
	division_loop:
    		blt $t4, $t5, division_loop_end #if(t4<t5), finish process
    		sub $t4, $t4, $t5  # t4 = t4 - t5
    		addi $v0, $v0, 1   # quotient++
    		j division_loop
	division_loop_end:
    	jr $ra             
	
	mode: #v0-> a0%a1
	move $t4, $a0     
    	move $t5, $a1      
	mode_loop:
    		blt $t4, $t5, mode_loop_end
   	 	sub $t4, $t4, $t5 
    		j mode_loop
	mode_loop_end:
    	move $v0, $t4      
    	jr $ra
	
