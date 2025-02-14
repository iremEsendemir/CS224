	.data
	
	ask_N_data: .asciiz "Please enter the dimension of matrix (NxN): "
	row_summation_print: .asciiz ") Row Summation: "
	col_summation_print: .asciiz ") Column Summation: "
	matrix_summation_row:	.asciiz "Matrix Summation(Row-Major): "
	matrix_summation_col:	.asciiz "Matrix Summation(Col-Major): "
	enter_row_str:  .asciiz "Row: "
	enter_col_str:  .asciiz "Column: "
	print_element: .asciiz "Element: "
	newline: .asciiz "\n"
	space: .asciiz " "
	menu: .asciiz "a:"
	
	.text
	
	jal askSize
	addi $s0, $v0, 0 #s0 = N
	addi $a0, $s0, 0 #parameter for allocation
	jal createMatrix
	addi $s1, $v0, 0 #s1 = address of matrix
	addi $a0, $s0, 0 #first parameter for initialization, a0 = N
	addi $a1, $s1, 0 #first parameter for initialization, a1 = addres
	jal initializeMatrix
	j print_menu
	quit:
    	li $v0, 10
    	syscall
	
	
	
	
	
	
	
askSize:
	addi $v0,$0,4
	la $a0, ask_N_data
	syscall	
	li $v0, 5
	syscall
	jr $ra
	
	
createMatrix:
	mul $a0, $a0, $a0
	li $v0, 9
	syscall
	jr $ra
	
	
initializeMatrix:
    	li $t0, 0              # $t0 = index 
    	mul $t4, $s0, $s0      # $t4 = N * N (size)


    	loop:
        	sll $t1, $t0, 2     # $t1(offset) = index * 4 (byte offset)
        	add $t2, $s1, $t1    # $t2(addr to store) = base + offset

        	addi $t3, $t0, 1     # $t3(value to store) = t0 + 1 
        	sw $t3, 0($t2)       # store value (t0+1) at the calculated addr

        	addi $t0, $t0, 1     #t0++
        	blt $t0, $t4, loop   #loop until t0 < N^2

    	jr $ra                 





rowSummation:
#a0 = row num
#v0 = sum
	addi $t0, $a0, 0 #t0 = a0(row num)
    	addi $t1, $0, 0 # t1 = 0 (col num)
    	addi $v0, $0, 0 # Initialize sum to 0

    row_sum_loop:
        bge $t1, $s0, end_row_sum_loop  #current col >= N, exit loop

        mul $t2, $t1, $s0        # $t2 = col * N
        add $t2, $t2, $t0        # $t2 = (col * N) + row 

        # load element
        sll $t3, $t2, 2          #byte offset
        add $t4, $s1, $t3        #cur addr
        lw $a0, 0($t4)           #cur value

        # update sum
        add $v0, $v0, $a0        

        addi $t1, $t1, 1         # t1++
        j row_sum_loop          

    end_row_sum_loop:
        jr $ra               



colSummation:
# $a0 = col num
# v0 = sum
    	addi $t0, $0, 0 #$t0 = offset (starts at 0)
    	addi $v0, $0, 0 

    	#starting index
    	mul $t1, $a0, $s0 # $t1 = N * a0

col_sum_loop:
	bge $t0, $s0, end_col_sum_loop  # t0 >= N -> exit the loop

        #index = start index + t0
        add $t2, $t1, $t0    # $t2 = (N * a0) + t0

        # load the element
        sll $t3, $t2, 2      #offset
        add $t4, $s1, $t3    #t4(cur addr) = s1(start addr) + t3 ()offset
        lw $a0, 0($t4) 

        #update sum
        add $v0, $v0, $a0   

        addi $t0, $t0, 1     #t0++
        j col_sum_loop      

end_col_sum_loop:
        jr $ra      
        
                      
                                    

rowSumForAll:
	addi $sp, $sp, 4
	sw $ra, 0($sp)
    	addi $t0, $0, 0 #t0->row index
    	addi $v1, $0, 0 #v1-> matrix sum

	rowSumPrintLoop:
    		bge $t0, $s0, end_row_sum_print_loop  # row index >= N->exit the loop
    		move $a0, $t0            # give parameter row index 
    		jal rowSummation         
    		add $v1, $v1, $v0	 # increase matrix sum
    		addi $t0, $t0, 1         # row++
    		j rowSumPrintLoop      

	end_row_sum_print_loop:
	
	lw $ra, 0($sp)
	addi $sp, $sp, -4
	
	
	#matrix sum print
    	li $v0, 4                		
    	la $a0, matrix_summation_row          
    	syscall
    	move $a0, $v1            
    	li $v0, 1              
    	syscall
    	li $v0, 4                		
    	la $a0, newline          	
    	syscall
	
    	jr $ra              
    	
   
    	
    	 	
colSumForAll:
    	addi $sp, $sp, 4
    	sw $ra, 0($sp)
    	addi $t7, $0, 0          #column index
    	addi $v1, $0, 0

	colSumPrintLoop:
    		bge $t7, $s0, end_col_sum_print_loop  #column index >= N->exit the loop
    		move $a0, $t7            # give column index to colSummation
    		jal colSummation         
    		add $v1, $v1, $v0	#increment sum
    		addi $t7, $t7, 1         # column++
    		j colSumPrintLoop       

	end_col_sum_print_loop:
	
    	lw $ra, 0($sp)
    	addi $sp, $sp, -4
    	
    	#printing
    	li $v0, 4                		
  	la $a0, matrix_summation_col         	
    	syscall
    	move $a0, $v1            
    	li $v0, 1                
    	syscall
    	li $v0, 4               
    	la $a0, newline          
    	syscall
	
    	jr $ra 
    	
    	
ask_for_row_col:
	addi $sp, $sp, 4
    	sw $ra, 0($sp)
    
    	#row
    	li $v0, 4
    	la $a0, enter_row_str
    	syscall
    	li $v0, 5
    	syscall
    	move $t0, $v0     
    
    	#col
    	li $v0, 4
    	la $a0, enter_col_str
    	syscall
	li $v0, 5
    	syscall
    	move $t1, $v0          # t1 = j
    
    	# Calculate original place
    	addi $t1, $t1, -1      # j-1
    	addi $t0, $t0, -1      # i-1
    
    	mul $t2, $t1, $s0      # (j-1) * n
    	mul $t2, $t2, 4        # (j-1) * n * 4
    	mul $t3, $t0, 4        # (i-1) * 4
    	add $t2, $t2, $t3      # (j-1) * n * 4 + (i-1) * 4
    

    	add $t4, $s1, $t2      # calculate addr
    	lw $t5, 0($t4)         # t5->val
    
    	# printing
    	li $v0, 4
    	la $a0, print_element
    	syscall
    	li $v0, 1
    	move $a0, $t5          
    	syscall
    	li $v0, 4
    	la $a0, newline
    	syscall
    
    	# return
    	lw $ra, 0($sp)
    	addi $sp, $sp, -4
    	jr $ra
    	
    	
    	
    	
 print_menu:
 	addi $v0, $0, 4
 	la $a0, menu
 	syscall
 	
 	li $v0, 5
 	syscall
 	
 	addi $t9, $v0, 0
 	
 	beq $t9, 1, rowSumForAll
 	beq $t9, 2, colSumForAll
 	beq $t9, 3, ask_for_row_col
 	beq $t9, 4, quit
 	
 	
 j print_menu
 	
 	
