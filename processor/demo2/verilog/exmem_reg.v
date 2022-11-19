module exmem_reg (/* input */ aluResIn, 
    memWriteDataIn, writeRegIn, branchTakeIn, JumpIn, 
    brAddrIn, jumpAddrIn,
    MemReadIn, MemWriteIn, HaltIn, MemToRegIn, RegWriteIn,
    writeRegValidIn, controlZeroExMem, clk, rst, 
    /* output */ aluResOut, memWriteDataOut, 
    writeRegOut, branchTakeOut, JumpOut, brAddrOut, jumpAddrOut,
    MemReadOut, MemWriteOut, HaltOut, MemToRegOut, RegWriteOut, writeRegValidOut);

    input clk, rst;
    input [15:0] aluResIn, memWriteDataIn, brAddrIn, jumpAddrIn;
    input branchTakeIn, JumpIn, MemReadIn, MemWriteIn, HaltIn, MemToRegIn, RegWriteIn;
    input [2:0] writeRegIn;
    input controlZeroExMem, writeRegValidIn;

    output [15:0] aluResOut, memWriteDataOut, brAddrOut, jumpAddrOut;
    output branchTakeOut, JumpOut, MemReadOut, MemWriteOut, HaltOut, MemToRegOut, RegWriteOut;
    output [2:0] writeRegOut;
    output writeRegValidOut;

    wire MemWriteInFinal, RegWriteInFinal, HaltInFinal, 
        branchTakeInFinal, JumpInFinal, MemReadInFinal;

    dff ALU  [15:0] (.q(aluResOut),    .d(aluResIn),    .clk(clk), .rst(rst));
    dff READ2[15:0] (.q(memWriteDataOut),     .d(memWriteDataIn),     .clk(clk), .rst(rst));

    dff WRITE_REG [2:0] (.q(writeRegOut), .d(writeRegIn), .clk(clk), .rst(rst));

    dff RBA [15:0] (.q(brAddrOut), .d(brAddrIn), .clk(clk), .rst(rst));
    dff RJA [15:0] (.q(jumpAddrOut), .d(jumpAddrIn), .clk(clk), .rst(rst));

    assign MemWriteInFinal = controlZeroExMem? 1'b0: MemWriteIn;
    assign RegWriteInFinal = controlZeroExMem? 1'b0: RegWriteIn;
    assign HaltInFinal = controlZeroExMem? 1'b0: HaltIn;
    assign branchTakeInFinal = controlZeroExMem? 1'b0: branchTakeIn;
    assign JumpInFinal = controlZeroExMem? 1'b0: jumpIn;
    assign MemReadInFinal = controlZeroExMem? 1'b0: MemReadIn;

    dff MEMW (.q(MemWriteOut),  .d(MemWriteInFinal),  .clk(clk), .rst(rst));
    dff RWO  (.q(RegWriteOut),  .d(RegWriteInFinal),  .clk(clk), .rst(rst));
    
    dff RB (.q(branchTakeOut),   .d(branchTakeInFinal),   .clk(clk), .rst(rst));
    dff RJ (.q(JumpOut),   .d(JumpInFinal),   .clk(clk), .rst(rst));
    dff MEMR (.q(MemReadOut),   .d(MemReadInFinal),   .clk(clk), .rst(rst));
    
    dff HALT (.q(HaltOut),       .d(HaltInFinal),       .clk(clk), .rst(rst));
    dff MTR  (.q(MemToRegOut), .d(MemToRegIn), .clk(clk), .rst(rst));
    
    dff RS (.q(writeRegValidOut),       .d(writeRegValidIn),       .clk(clk), .rst(rst));
   
endmodule
