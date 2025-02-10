`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.11.2024 22:40:46
// Design Name: 
// Module Name: mips
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module mips (
    input  logic        clk, reset,
    output logic [31:0] writedata, dataaddr,
    output logic        memwrite, regwrite,
    output logic [31:0] pcf, pc,
    output logic        lwstall, branchstall, branch,
    output logic [4:0]  writereg, rsD, rtD, regdst
    );

    // Internal signals
    logic        memtoreg, alusrc, regWriteD, jump;
    logic [2:0]  alucontrol;
    logic [5:0]  op, funct;
    logic        MemWriteD;

    datapath dp (
        .clk(clk),
        .reset(reset),
        .RegWriteD(regWriteD),
        .MemtoRegD(memtoreg),
        .MemWriteD(MemWriteD),
        .ALUControlD(alucontrol),
        .ALUSrcD(alusrc),
        .RegDstD(regdst),
        .BranchD(branch),
        .JumpD(jump),
        
        .op(op),
        .funct(funct),

        .RegWriteE(regwrite),
        .MemWriteE(memwrite),
        .ALUOutE(dataaddr),
        .WriteDataE(writedata),
        .PCF(pcf),
        .PC(pc),
        .WriteRegE(writereg),
        .lwstall(lwstall),
        .branchstall(branchstall)
    );

    controller cont (
        .op(op),
        .funct(funct),
        .memtoreg(memtoreg),
        .memwrite(MemWriteD),
        .alusrc(alusrc),
        .regdst(regdst),
        .regwrite(regWriteD),
        .jump(jump),
        .alucontrol(alucontrol),
        .branch(branch)
    );

endmodule
