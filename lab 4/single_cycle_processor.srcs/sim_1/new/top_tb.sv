module top_tb();
    // Test signals
    logic clk;
    logic reset;
    logic [31:0] writedata, dataadr;
    logic [31:0] readdata;
    logic memwrite;
    
    // Register monitoring signals
    logic [31:0] reg2, reg3, reg4, reg5, reg7, reg31;  // Added reg31 for $ra
    
    // Instantiate the top module
    top dut(clk, reset, writedata, dataadr, readdata, memwrite);
    
    //registers
    assign reg2 = dut.mips.dp.rf.rf[2];   // $2 
    assign reg3 = dut.mips.dp.rf.rf[3];   // $3 
    assign reg4 = dut.mips.dp.rf.rf[4];   // $4 
    assign reg5 = dut.mips.dp.rf.rf[5];   // $5 
    assign reg7 = dut.mips.dp.rf.rf[7];   // $7 
    assign reg31 = dut.mips.dp.rf.rf[31]; // $31 
    
    // clock
    always begin
        clk = 1; #5;
        clk = 0; #5;
    end
    
    initial begin
        $display("\nTime-PC-Instruction-$2-$3-$4-$5-$7-$ra-memwrite-writedata-dataaddr");        
        // start with reset
        reset = 1;
        @(posedge clk);
        @(posedge clk);
        reset = 0;
        repeat(30) begin
            @(negedge clk); 
            $display("%0t\t%h\t%h\t%h\t%h\t%h\t%h\t%h\t%h\t%h\t%h\t%h", 
                    $time, dut.pc, dut.instr,
                    reg2, reg3, reg4, reg5, reg7, reg31, memwrite, writedata, dataadr);
        end
        $display("\nSimulation finished");
        $finish;
    end
    
    // check for memwrite
    always @(negedge clk) begin
        if(memwrite) begin
            $display("memwrite %0t: dataaddr=%h, writedata=%h", 
                    $time, dataadr, writedata);
        end
    end
    
endmodule