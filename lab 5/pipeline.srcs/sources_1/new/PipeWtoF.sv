`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.11.2024 22:40:46
// Design Name: 
// Module Name: PipeWtoF
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


module PipeWtoF(input logic[31:0] PC,
                input logic EN, clk, reset,		// StallF will be connected as this EN
                output logic[31:0] PCF);

                always_ff @(posedge clk, posedge reset) begin
                    if (reset) begin
                        PCF <= 0;
                    end else if (EN) begin
                        PCF <= PC;
                    end
                end
endmodule
