`timescale 1ns / 1ps

module regfile (input    logic clk, we3, changeRA,
                input    logic[4:0]  ra1, ra2, wa3, 
                input    logic[31:0] wd3, 
                output   logic[31:0] rd1, rd2);

  logic [31:0] rf [31:0];
  initial begin
        for (int i = 0; i < 32; i = i + 1)
            rf[i] = 32'h0;
    end

  // three ported register file: read two ports combinationally
  // write third port on rising edge of clock. Register0 hardwired to 0.

  always_ff@(posedge clk)
      if(changeRA && !we3) begin
        rf[31] <= wd3;
      end
     else if (we3) begin
         rf [wa3] <= wd3;	
     end
    

  assign rd1 = (ra1 != 0) ? rf [ra1] : 0;
  assign rd2 = (ra2 != 0) ? rf[ ra2] : 0;

endmodule