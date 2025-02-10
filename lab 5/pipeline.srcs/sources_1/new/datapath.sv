`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.11.2024 22:40:46
// Design Name: 
// Module Name: datapath
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
module datapath (
    input  logic        clk, reset,
    input  logic        RegWriteD, MemtoRegD, MemWriteD,
    input  logic [2:0]  ALUControlD, 
    input  logic        ALUSrcD, RegDstD, BranchD, JumpD,          
                
    output logic [5:0]  op, funct,      // For controller
    output logic        RegWriteE,       // For regwrite output
    output logic        MemWriteE,       // For memwrite output
    output logic [31:0] ALUOutE,        // For dataaddr output
    output logic [31:0] WriteDataE,     // For writedata output
    output logic [31:0] PCF, PC,   // For program counter outputs
    output logic [4:0]  WriteRegE,       // For writereg output
    output logic        lwstall, branchstall  // For hazard detection outputs
    ); 
    
    // Internal signals
    logic  stallF, stallD, ForwardAD, ForwardBD, FlushE;
    logic  PcSrcD,MemtoRegW, RegWriteW, pFtoDclr, EqualD, RegWriteM, MemtoRegE, MemtoRegM, ALUSrcE, RegDstE;
    logic [1:0]  ForwardAE, ForwardBE;
    logic [2:0]  ALUControlE;
    logic [4:0]  WriteRegW, WriteRegM, RsE, RtE, RdD, RdE, RsD, RtD;
    logic [31:0] ALUOutW, ReadDataW, ResultW, PCjump, PcBranchD, PcPlus4F, instrF;
    logic [31:0] instrD, PcPlus4D, rd1d_output, rd2d_output, RD1, RD2, SignImmD;
    logic [31:0] SignImmShifted, RD1E, RD2E, SignImmE, SrcAE, SrcBE, ALUOutM, WriteDataM;
    logic [31:0] ReadDataM;

    

    // Datapath implementation
    mux2 #(32) result_mux(ALUOutW, ReadDataW, MemtoRegW, ResultW);
    
    PipeWtoF pWtoF(PC, ~stallF, clk, reset, PCF);                            
    
    adder pc_adder(PCF, 4, PcPlus4F);
    
               
    mux2 #(32) jump_mux(PcPlus4F, { PcPlus4D[31:28], instrD[25:0], 2'b00}, JumpD, PCjump);
    mux2 #(32) pc_mux(PCjump, PcBranchD, PcSrcD, PC);  
    
    imem im1(PCF[7:2], instrF);                                        
    
    assign pFtoDclr = PcSrcD | JumpD;
    
    PipeFtoD pFtoD(instrF, PcPlus4F, ~stallD, clk, pFtoDclr, reset, instrD, PcPlus4D);    
    
    assign EqualD = rd1d_output == rd2d_output;
    assign PcSrcD = BranchD && EqualD;
    
    assign op = instrD[31:26];
    assign funct = instrD[5:0];
    
    assign RsD = instrD[25:21];
    assign RtD = instrD[20:16];
    assign RdD = instrD[15:11];
    
    
    regfile rf(clk, reset, RegWriteW, instrD[25:21], instrD[20:16],
                WriteRegW, ResultW, RD1, RD2);                            
    
    signext signextend (instrD[15:0], SignImmD);
    sl2 shiftimmmediate (SignImmD, SignImmShifted);
    adder branchadder (SignImmShifted, PcPlus4D, PcBranchD);
    
    mux2 #(32) RD1mux (RD1, ALUOutM, ForwardAD, rd1d_output);
    mux2 #(32) RD2mux (RD2, ALUOutM, ForwardBD, rd2d_output);
    
    
    PipeDtoE pDtoE (clk, FlushE, reset,
                    RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, RegDstD,
                    ALUControlD,
                    RD1, RD2,SignImmD,
                    RsD, RtD, RdD,
                    RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, RegDstE,
                    ALUControlE,
                    RD1E, RD2E, SignImmE,
                    RsE, RtE, RdE
                    );
        
    mux2 #(5) writeregmux (RtE, RdE, RegDstE, WriteRegE);
    
    mux3 #(32) ForwardAEmux (RD1E, ResultW, ALUOutM, ForwardAE, SrcAE);
    mux3 #(32) ForwardBEmux (RD2E, ResultW, ALUOutM, ForwardBE, WriteDataE);
    
    mux2 #(32) SrcBEmux (WriteDataE, SignImmE, ALUSrcE, SrcBE);
    
    alu alu (SrcAE, SrcBE, ALUControlE, ALUOutE);
                                
    PipeEtoM pEtoM (clk, reset,
                    RegWriteE, MemtoRegE, MemWriteE,
                    ALUOutE, WriteDataE,
                    WriteRegE,
                    RegWriteM, MemtoRegM, MemWriteM,
                    ALUOutM, WriteDataM,
                    WriteRegM
                    );
    
    dmem dmem (clk, MemWriteM, ALUOutM, WriteDataM, ReadDataM);
    
    PipeMtoW pMtoW (clk, reset,
                    RegWriteM, MemtoRegM,
                    ReadDataM, ALUOutM,
                    WriteRegM,
                    RegWriteW, MemtoRegW,
                    ReadDataW, ALUOutW,
                    WriteRegW
                    );
                    
     HazardUnit hu (
        .RegWriteW(RegWriteW),
        .WriteRegW(WriteRegW),
        .RegWriteM(RegWriteM),
        .MemtoRegM(MemtoRegM),
        .WriteRegM(WriteRegM),
        .WriteRegE(WriteRegE),
        .RegWriteE(RegWriteE),
        .MemtoRegE(MemtoRegE),
        .rsE(RsE),
        .rtE(RtE),
        .rsD(RsD),
        .rtD(RtD),
        .BranchD(BranchD),
        .JumpD(JumpD),
        .ForwardAD(ForwardAD),
        .ForwardBD(ForwardBD),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .FlushE(FlushE),
        .StallD(stallD),
        .StallF(stallF),
        .lwstall(lwstall),
        .branchstall(branchstall)
    );

endmodule