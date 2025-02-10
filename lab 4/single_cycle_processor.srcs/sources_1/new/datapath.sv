`timescale 1ns / 1ps


module datapath (input  logic clk, reset, memtoreg, pcsrc, alusrc, regdst,
                 input  logic regwrite, jump, jalsub, ror,
		 input  logic[2:0]  alucontrol, 
                 output logic zero, 
		 output logic[31:0] pc, 
	         input  logic[31:0] instr,
                 output logic[31:0] aluout, writedata, 
	         input  logic[31:0] readdata);

  logic [4:0]  writereg;
  logic [31:0] pcnext, pcnextbr, pcplus4, pcbranch, pcnextbeforejalsub;
  logic [31:0] signimm, signimmsh, srca, srcb, resultbeforepcplus4, resultbeforeror, rorresult, result;
 
  // next PC logic
  flopr #(32) pcreg(clk, reset, pcnext, pc);
  adder       pcadd1(pc, 32'b100, pcplus4);
  sl2         immsh(signimm, signimmsh);
  adder       pcadd2(pcplus4, signimmsh, pcbranch);
  mux2 #(32)  pcbrmux(pcplus4, pcbranch, pcsrc,
                      pcnextbr);
  mux2 #(32)  pcmuxbeforejalsub(pcnextbr, {pcplus4[31:28], 
                    instr[25:0], 2'b00}, jump, pcnextbeforejalsub);
  mux2 #(32) pcmux(pcnextbeforejalsub, aluout, jalsub, pcnext);

// register file logic
   regfile     rf (clk, regwrite, jalsub,instr[25:21], instr[20:16], writereg,
                   result, srca, writedata);

   mux2 #(5)    wrmux (instr[20:16], instr[15:11], regdst, writereg);
   mux2 #(32)  resmux (aluout, readdata, memtoreg, resultbeforepcplus4);
   mux2 #(32)  muxwithjalsub(resultbeforepcplus4, pcplus4, jalsub, resultbeforeror);
   assign rorresult = ((srca >> instr[10:6]) | (srca << (32 - instr[10:6])));
   mux2 #(32) muxwithror(resultbeforeror, rorresult, ror, result);
   signext         se (instr[15:0], signimm);

  // ALU logic
   mux2 #(32)  srcbmux (writedata, signimm, alusrc, srcb);
   alu         alu (srca, srcb, alucontrol, aluout, zero);

endmodule