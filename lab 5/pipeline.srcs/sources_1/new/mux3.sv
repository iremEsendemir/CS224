`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.11.2024 22:40:46
// Design Name: 
// Module Name: mux3
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


module mux3 #(parameter WIDTH = 32) (
    input  logic [WIDTH-1:0] i0, 
    input  logic [WIDTH-1:0] i1, 
    input  logic [WIDTH-1:0] i2, 
    input  logic [1:0]       sel, 
    output logic [WIDTH-1:0] out  
);

    always_comb begin
        case (sel)
            2'b00: out = i0; 
            2'b01: out = i1;
            2'b10: out = i2; 
            default: out = {WIDTH{1'b0}}; 
        endcase
    end

endmodule

/*
// paramaterized 2-to-1 MUX
module mux4 #(parameter WIDTH = 8)
             (input  logic[WIDTH-1:0] d0, d1, d2, d3,  
              input  logic[1:0] s, 
              output logic[WIDTH-1:0] y);
  
   assign y = s[1] ? (s[0] ? d3 : d2) : (s[0] ? d1 : d0); 
endmodule
*/
