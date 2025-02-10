module HazardUnit(
    input  logic        RegWriteW,
    input  logic [4:0]  WriteRegW,
    input  logic        RegWriteM, MemtoRegM,
    input  logic [4:0]  WriteRegM, WriteRegE,
    input  logic        RegWriteE, MemtoRegE,
    input  logic [4:0]  rsE, rtE,
    input  logic [4:0]  rsD, rtD,
    input  logic        BranchD, JumpD,
    output logic        ForwardAD, ForwardBD,
    output logic [1:0]  ForwardAE, ForwardBE,
    output logic        FlushE, StallD, StallF,
    output logic        lwstall, branchstall
);
    
    always_comb begin   
        // Execute stage forwarding
        if (rsE != 0 & rsE == WriteRegM & RegWriteM)
            ForwardAE = 2'b10;
        else if (rsE != 0 & rsE == WriteRegW & RegWriteW)
            ForwardAE = 2'b01;
        else
            ForwardAE = 2'b00;
            
        if (rtE != 0 & rtE == WriteRegM & RegWriteM)
            ForwardBE = 2'b10;
        else if (rtE != 0 & rtE == WriteRegW & RegWriteW)
            ForwardBE = 2'b01;
        else
            ForwardBE = 2'b00;
            
            
        lwstall = MemtoRegE & (rtE == rsD | rtE == rtD);
        branchstall = (BranchD & RegWriteE & (WriteRegE == rsD | WriteRegE == rtD))
                      | (BranchD & MemtoRegM & (WriteRegM == rsD | WriteRegM == rtD));
        
        // Decode stage forwarding
        ForwardAD = (rsD != 0) & RegWriteM & (rsD == WriteRegM);
        ForwardBD = (rtD != 0) & RegWriteM & (rtD == WriteRegM);
        
        StallF = lwstall | branchstall;
        StallD = lwstall | branchstall;
        FlushE = lwstall | branchstall | JumpD;
        
        
    end
endmodule