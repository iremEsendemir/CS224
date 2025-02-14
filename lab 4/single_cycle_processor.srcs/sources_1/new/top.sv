`timescale 1ns / 1ps

// Top level system including MIPS and memories
module top  (input   logic 	 clk, reset,            
	     output  logic[31:0] writedata, dataadr, 
	     output  logic[31:0] readdata,           
	     output  logic       memwrite);    

   logic [31:0] instr, pc;
   // instantiate processor and memories  
   mips mips (clk, reset, pc, instr, memwrite, dataadr, writedata, readdata);  
   imem imem (pc[7:0], instr);  
   dmem dmem (clk, memwrite, dataadr, writedata, readdata);

endmodule
