`timescale 1ns / 1ps

// jalsub ror control signals

module controller(input  logic[5:0] op, funct,
                  input  logic     zero,
                  output logic     memtoreg, memwrite,
                  output logic     pcsrc, alusrc,
                  output logic     regdst, regwrite,
                  output logic     jump, 
                  output logic     jalsub, ror,
                  output logic[2:0] alucontrol);

   logic [1:0] aluop;
   logic       branch;

   maindec md (op, funct, memtoreg, memwrite, branch, alusrc, regdst, regwrite,  jalsub, ror, jump,  aluop);

   aludec  ad (funct, aluop, alucontrol);

   assign pcsrc = branch & zero;

endmodule