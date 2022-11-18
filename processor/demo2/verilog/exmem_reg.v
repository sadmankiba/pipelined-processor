module exmem_reg (/* input */ aluResIn, 
    readData1In, writeRegIn, branchTakeIn, JumpIn, 
    brAddrIn, jumpAddrIn,
    MemReadIn, MemWriteIn, halt_in, MemToRegIn, RegWriteIn,
    writeRegValidIn, controlZeroExMem, clk, rst, 
    /* output */ aluResOut, readData1Out, 
    writeRegOut, branchTakeOut, JumpOut, brAddrOut, jumpAddrOut,
    MemReadOut, MemWriteOut, halt_out, MemToRegOut, RegWriteOut, writeRegValidOut);

    input clk, rst;
    input [15:0] aluResIn, readData1In, brAddrIn, jumpAddrIn;
    input branchTakeIn, JumpIn, MemReadIn, MemWriteIn, halt_in, MemToRegIn, RegWriteIn;
    input [2:0] writeRegIn, writeRegValidIn;
    input controlZeroExMem;

    output [15:0] aluResOut, readData1Out, brAddrOut, jumpAddrOut;
    output branchTakeOut, JumpOut, MemReadOut, MemWriteOut, halt_out, MemToRegOut, RegWriteOut;
    output [2:0] writeRegOut, writeRegValidOut;

    wire MemWriteOutFinal, RegWriteOutFinal;

    dff ALU  [15:0] (.q(aluResOut),    .d(aluResIn),    .clk(clk), .rst(rst));
    dff READ2[15:0] (.q(readData1Out),     .d(readData1In),     .clk(clk), .rst(rst));

    dff WRITE_REG [2:0] (.q(writeRegOut), .d(writeRegIn), .clk(clk), .rst(rst));

    dff RBA [15:0] (.q(brAddrOut), .d(brAddrIn), .clk(clk), .rst(rst));
    dff RJA [15:0] (.q(jumpAddrOut), .d(jumpAddrIn), .clk(clk), .rst(rst));

    assign MemWriteOutFinal = controlZeroExMem? 1'b0: MemWriteIn;
    assign RegWriteOutFinal = controlZeroExMem? 1'b0: RegWriteIn;

    dff MEMW (.q(MemWriteOut),  .d(MemWriteOutFinal),  .clk(clk), .rst(rst));
    dff RWO  (.q(RegWriteOut),  .d(RegWriteOutFinal),  .clk(clk), .rst(rst));
    
    dff RB (.q(branchTakeOut),   .d(branchTakeIn),   .clk(clk), .rst(rst));
    dff RJ (.q(JumpOut),   .d(JumpIn),   .clk(clk), .rst(rst));
    dff MEMR (.q(MemReadOut),   .d(MemReadIn),   .clk(clk), .rst(rst));
    
    dff HALT (.q(halt_out),       .d(halt_in),       .clk(clk), .rst(rst));
    dff MTR  (.q(MemToRegOut), .d(MemToRegIn), .clk(clk), .rst(rst));
    
    dff RS (.q(writeRegValidOut),       .d(writeRegValidIn),       .clk(clk), .rst(rst));
   
endmodule
