`timescale 1ns / 1ps


module maindec (
    input logic[5:0] op, funct, 
    output logic memtoreg, memwrite, branch,
    output logic alusrc, regdst, regwrite, jalsub, ror, jump,
    output logic [1:0] aluop
);
    logic [10:0] controls;
    
    assign {regwrite, regdst, alusrc, branch, memwrite,
             memtoreg, aluop, jump, jalsub, ror} = controls;
             
    always_comb begin
        controls = 11'b00000000000;         
        case (op)
            6'b000010: controls = 11'b00000000100; // J 
            6'b000000: begin // R-type instructions
                case (funct)
                    6'b100000: controls = 11'b11000010000; // ADD
                    6'b100010: controls = 11'b11000010000; // SUB
                    6'b100100: controls = 11'b11000010000; // AND
                    6'b100101: controls = 11'b11000010000; // OR
                    6'b101010: controls = 11'b11000010000; // SLT
                    6'b110000: controls = 11'b01010001110; // JALSUB
                    6'b111000: controls = 11'b11000000001; // ROR
                    default:   controls = 11'b00000000000; // Illegal funct
                endcase
            end
            6'b100011: controls = 11'b10100100000; // LW
            6'b101011: controls = 11'b00101000000; // SW
            6'b000100: controls = 11'b00010001000; // BEQ
            6'b001000: controls = 11'b10100000000; // ADDI
            default:   controls = 11'b00000000000; // Illegal opcode
        endcase
    end
endmodule