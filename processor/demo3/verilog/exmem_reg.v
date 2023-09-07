module exmem_reg (/* input */ aluResIn, 
    memWriteDataIn, RtIn, RtValidIn, writeRegIn, writeRegValidIn, branchTakeIn, JumpIn, 
    brAddrIn, jumpAddrIn,
    /* control */ MemReadIn, MemWriteIn, HaltIn, MemToRegIn, RegWriteIn,
    controlZeroExMem, writeExMem, errIn1, errIn2, errIn3, clk, rst, 
    /* output */ aluResOut, memWriteDataOut, RtOut, RtValidOut,
    writeRegOut, branchTakeOut, JumpOut, brAddrOut, jumpAddrOut,
    MemReadOut, MemWriteOut, HaltOut, MemToRegOut, RegWriteOut, writeRegValidOut, errOut);

    input clk, rst;
    input [15:0] aluResIn, memWriteDataIn, brAddrIn, jumpAddrIn;
    input MemReadIn, MemWriteIn, HaltIn, branchTakeIn, JumpIn, MemToRegIn, RegWriteIn;
    input [2:0] writeRegIn, RtIn;
    input controlZeroExMem, writeRegValidIn, RtValidIn, writeExMem,
        errIn1, errIn2, errIn3;

    output [15:0] aluResOut, memWriteDataOut, brAddrOut, jumpAddrOut;
    output [2:0] writeRegOut, RtOut;
    output branchTakeOut, JumpOut, MemReadOut, MemWriteOut, HaltOut, MemToRegOut, RegWriteOut;
    output writeRegValidOut, RtValidOut, errOut;

    wire [15:0] aluResInFinal, memWriteDataInFinal, brAddrInFinal, jumpAddrInFinal;
    wire [2:0] writeRegInFinal, RtInFinal;

    wire MemWriteInFinal, RegWriteInFinal, branchTakeInFinal, 
        JumpInFinal, MemReadInFinal, HaltInFinal, MemToRegInFinal, writeRegValidInFinal,
        RtValidInFinal, errIn, errInFinal;

    assign aluResInFinal = writeExMem? aluResIn: aluResOut;
    assign memWriteDataInFinal = writeExMem? memWriteDataIn: memWriteDataOut;
    assign writeRegInFinal = writeExMem? writeRegIn: writeRegOut;
    assign RtInFinal = writeExMem? RtIn: RtOut;
    assign brAddrInFinal = writeExMem? brAddrIn: brAddrOut;
    assign jumpAddrInFinal = writeExMem? jumpAddrIn: jumpAddrOut; 

    dff ALU  [15:0] (.q(aluResOut), .d(aluResInFinal), .clk(clk), .rst(rst));
    dff READ2[15:0] (.q(memWriteDataOut), .d(memWriteDataInFinal), .clk(clk), .rst(rst));

    dff RWR [2:0] (.q(writeRegOut), .d(writeRegInFinal), .clk(clk), .rst(rst));
    dff RT [2:0] (.q(RtOut), .d(RtInFinal), .clk(clk), .rst(rst));

    dff RBA [15:0] (.q(brAddrOut), .d(brAddrInFinal), .clk(clk), .rst(rst));
    dff RJA [15:0] (.q(jumpAddrOut), .d(jumpAddrInFinal), .clk(clk), .rst(rst));

    assign MemWriteInFinal = controlZeroExMem? 1'b0: writeExMem? MemWriteIn: MemWriteOut;
    assign RegWriteInFinal = controlZeroExMem? 1'b0: writeExMem? RegWriteIn: RegWriteOut;
    assign branchTakeInFinal = controlZeroExMem? 1'b0: writeExMem? branchTakeIn: branchTakeOut;
    assign JumpInFinal = controlZeroExMem? 1'b0: writeExMem? JumpIn: JumpOut;
    assign MemReadInFinal = controlZeroExMem? 1'b0: writeExMem? MemReadIn: MemReadOut;
    assign HaltInFinal = controlZeroExMem? 1'b0: writeExMem? HaltIn: HaltOut;
    assign MemToRegInFinal = writeExMem? MemToRegIn: MemToRegOut;
    assign writeRegValidInFinal = writeExMem? writeRegValidIn: writeRegValidOut;
    assign RtValidInFinal = writeExMem? RtValidIn: RtValidOut;
    assign errIn = errIn1 | errIn2 | errIn3;
    assign errInFinal = writeExMem? errIn: errOut;

    dff RMW (.q(MemWriteOut),  .d(MemWriteInFinal),  .clk(clk), .rst(rst));
    dff RWO  (.q(RegWriteOut),  .d(RegWriteInFinal),  .clk(clk), .rst(rst));
    
    dff RB (.q(branchTakeOut),   .d(branchTakeInFinal),   .clk(clk), .rst(rst));
    dff RJ (.q(JumpOut),   .d(JumpInFinal),   .clk(clk), .rst(rst));
    dff RMR (.q(MemReadOut),   .d(MemReadInFinal),   .clk(clk), .rst(rst));
    
    dff RH (.q(HaltOut),       .d(HaltInFinal),       .clk(clk), .rst(rst));
    dff RMTR  (.q(MemToRegOut), .d(MemToRegInFinal), .clk(clk), .rst(rst));
    
    dff RWRV (.q(writeRegValidOut), .d(writeRegValidInFinal), .clk(clk), .rst(rst));
    dff RTV (.q(RtValidOut), .d(RtValidInFinal), .clk(clk), .rst(rst));
    dff ERR (.q(errOut), .d(errInFinal), .clk(clk), .rst(rst));
   
endmodule
