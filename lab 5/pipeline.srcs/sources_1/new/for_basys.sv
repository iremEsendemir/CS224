`timescale 1ns / 1ps
module for_basys(
    input logic clk,             // 100 MHz clock from BASYS3
    input logic btnC,           // Center button for reset
    input logic btnU,           // Up button for clock pulse
    output logic [6:0] seg,     // 7-segment display segments
    output logic dp,            // Decimal point
    output logic [3:0] an,      // 7-segment display digit select
    output logic [4:0] led     // LEDs for control signals
);
    // Internal signals
    logic clk_pulse, reset_pulse;  
    logic [31:0] writedata, dataaddr;  
    logic memwrite, regwrite;          
    logic [31:0] pcf, pc;         
    logic lwstall, branchstall, branch;
    logic [4:0] writereg, rsD, rtD, regdst;
    
    pulse_controller clock_ctrl(clk,btnU,btnC,clk_pulse);


    pulse_controller reset_ctrl(clk,btnC,1'b0,reset_pulse);

    mips mips_basys( clk_pulse, reset_pulse, writedata, dataaddr, memwrite, regwrite, pcf, pc, lwstall, branchstall, branch, writereg, rsD, rtD, regdst);
       

    logic [3:0] digits [3:0];
    
    assign digits[0] = writedata[3:0];
    assign digits[1] = writedata[7:4];
    
    assign digits[2] = dataaddr[3:0];
    assign digits[3] = dataaddr[7:4];

    display_controller display_ctrl(
        .clk(clk),                 
        .in0(digits[0]),      
        .in1(digits[1]),   
        .in2(digits[2]),   
        .in3(digits[3]),
        .seg(seg),
        .dp(dp),
        .an(an)
    );

    assign led[4] = regwrite;    
    assign led[3] = memwrite;    
    assign led[2] = lwstall;     
    assign led[1] = branchstall;
    assign led[0] = branch;     

endmodule