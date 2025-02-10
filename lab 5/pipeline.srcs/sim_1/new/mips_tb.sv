`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.11.2024 22:56:45
// Design Name: 
// Module Name: mips_tb
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

module mips_tb();
    // Test signals
    logic clk;
    logic reset;
    logic [31:0] writedata, dataaddr;
    logic memwrite, regwrite;
    logic [31:0] pcf, pc;
    logic lwstall, branchstall, branch;
    logic [4:0] writereg, rsD, rtD, regdst;

    // Instantiate the pipelined MIPS module
    mips dut(clk, reset, writedata, dataaddr, memwrite, regwrite,
             pcf, pc, lwstall, branchstall, branch,
             writereg, rsD, rtD, regdst);

    // Access the instruction from the pipeline
    logic [31:0] instruction;
    assign instruction = dut.dp.instrD;

    // Clock generation
    always begin
        clk = 1; #5;
        clk = 0; #5;
    end

    initial begin
        $display("\nTime-PC-Instruction-Dataaddr-Writedata-Regwrite-Memwrite-Stalls-Branch");        
        
        // Start with reset
        reset = 1;
        @(posedge clk);
        @(posedge clk);
        reset = 0;

        repeat(30) begin
            @(negedge clk); 
            $display("%0t\t%h\t%h\t%h\t%h\t%h\t%h\t%h%h\t%h", 
                    $time, pcf, instruction, dataaddr, writedata, regwrite, memwrite,
                    lwstall, branchstall, branch);
        end
        
        $display("\nSimulation finished");
        $finish;
    end

    // Monitor memory writes
    always @(negedge clk) begin
        if (memwrite) begin
            $display("memwrite %0t: dataaddr=%h, writedata=%h", 
                    $time, dataaddr, writedata);
        end
    end
endmodule