`timescale 1ns / 1ps


module alu(
    input  logic [31:0] a, b, 
    input  logic [2:0]  alucont, 
    output logic [31:0] result,
    output logic zero
);             
    always_comb begin
        result = 32'h0000_0000;
        
        case(alucont)
            3'b010: result = a + b;         // add
            3'b110: result = a - b;         // subtract
            3'b000: result = a & b;         // and
            3'b001: result = a | b;         // or
            3'b111: result = (a < b) ? 32'h0000_0001 : 32'h0000_0000;  // slt
            default: result = 32'h0000_0000;
        endcase
    end
    
    assign zero = (result == 32'h0000_0000);
endmodule
