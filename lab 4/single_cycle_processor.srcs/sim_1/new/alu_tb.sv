module alu_tb();
    logic [31:0] a, b;
    logic [2:0] alucont;
    logic [31:0] result;
    logic zero;
    
    alu dut(a, b, alucont, result, zero);
    
    initial begin
        a = 32'hFFFF_FFFF; b = 32'hABCD_1234; alucont = 3'b000; #10; // and
        a = 32'h0000_000A; b = 32'h0000_0005; alucont = 3'b010; #10; // add
        a = 32'h0000_000A; b = 32'h0000_0005; alucont = 3'b110; #10; // subtraction
        a = 32'hFFFF_FFFF; b = 32'h0000_00FF; alucont = 3'b000; #10; // and
        a = 32'hFFFF_0000; b = 32'h0000_FFFF; alucont = 3'b001; #10; // or
        a = 32'h0000_0005; b = 32'h0000_000A; alucont = 3'b111; #10; // slt
        a = 32'h0000_0005; b = 32'h0000_0005; alucont = 3'b110; #10; // to see zero
        #10 $finish;
    end
endmodule