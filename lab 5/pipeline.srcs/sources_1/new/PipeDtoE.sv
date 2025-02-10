module PipeDtoE(input logic clk, clear, reset, // clear -> FlushE
                input logic RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, RegDstD,
                input logic [2:0] ALUControlD,
                input logic [31:0] RD1D, RD2D, SignImmD,
                input logic [4:0] RsD, RtD, RdD,
                output logic RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, RegDstE,
                output logic [2:0] ALUControlE,
                output logic [31:0] RD1E, RD2E,SignImmE,
                output logic [4:0] RsE, RtE, RdE
                );
                
                always_ff @(posedge clk or posedge reset)
                begin
                    if ( reset || clear) 
                    begin
                        RegWriteE <= 0;
                        MemtoRegE <= 0;
                        MemWriteE <= 0;
                        ALUControlE <= 0;
                        ALUSrcE <= 0;
                        RegDstE <= 0;
                        RD1E <= 0;
                        RD2E <= 0;
                        RsE <= 0;
                        RtE <= 0;
                        RdE <= 0;
                        SignImmE <= 0;
                    end
                    else begin
                            RegWriteE <= RegWriteD;
                            MemtoRegE <= MemtoRegD;
                            MemWriteE <= MemWriteD;
                            ALUControlE <= ALUControlD;
                            ALUSrcE <= ALUSrcD;
                            RegDstE <= RegDstD;
                            RD1E <= RD1D;
                            RD2E <= RD2D;
                            RsE <= RsD;
                            RtE <= RtD;
                            RdE <= RdD;
                            SignImmE <= SignImmD;
                        end
                end
                      
endmodule