`timescale 1ns / 1ps


module imem (
    input  logic [7:0]  addr,
    output logic [31:0] instr
);
    always_comb
        case (addr)
        //jalsub
        8'h00: instr = 32'h20040018;    // addi $4, $zero, 0x18    
        8'h04: instr = 32'h20050008;    // addi $5, $zero, 0x08    
        8'h08: instr = 32'h00850030;    // jalsub $4, $5           
        8'h0c: instr = 32'h20070003;    // addi $7, $zero, 3 #should not be executed
        8'h10: instr = 32'h23ff0006;    // addi $31, $31, 6       
        8'h14: instr = 32'h23e70000;    // addi $7, $31, 0         
        //ror 
        8'h18: instr = 32'h20020f0f;    // addi $2, $zero, 0x0F0F  
        8'h1c: instr = 32'h004018f8;    // ror $3, $2, 3  #t1 = 0xE00001E1
        8'h20: instr = 32'h0x00001020; //add $2, $0, $0
        // Original MIPS test program
        8'h24: instr = 32'h20020005;    // addi $2, $zero, 5      
        8'h28: instr = 32'h2003000c;    // addi $3, $zero, 12      
        8'h2c: instr = 32'h2067fff7;    // addi $7, $3, -9         
        8'h30: instr = 32'h00e22025;    // or $4, $7, $2          
        8'h34: instr = 32'h00642824;    // and $5, $3, $4         
        8'h38: instr = 32'h00a42820;    // add $5, $5, $4        
        8'h3c: instr = 32'h10a70011;    // beq $5, $7, 0x44
        8'h40: instr = 32'h0064202a;    // slt $4, $3, $4
        8'h44: instr = 32'h10800001;    // beq $4, $zero, 1
        8'h48: instr = 32'h20050000;    // addi $5, $zero, 0
        8'h4c: instr = 32'h00e2202a;    // slt $4, $7, $2
        8'h50: instr = 32'h00853820;    // add $7, $4, $5
        8'h54: instr = 32'h00e23822;    // sub $7, $7, $2
        8'h58: instr = 32'hac670044;    // sw $7, 68($3)
        8'h5c: instr = 32'h8c020050;    // lw $2, 80($zero)
        8'h60: instr = 32'h0800001a;    // j 0x68 (skip next instruction)
        8'h64: instr = 32'h20020001;    // addi $2, $zero, 1
        8'h68: instr = 32'hac020054;    // sw $2, 84($zero)
        8'h6c: instr = 32'h0800001b;    // j 0x6c (infinite loop)
        default: instr = 32'hxxxxxxxx;   // Unknown address
        endcase
endmodule