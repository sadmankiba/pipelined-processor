module idex_reg(/* input */ clk, rst, pcIn, readData1In, readData2In, immValIn, jumpDistIn,
    functIn, writeRegIn,
    /* control */ AluOpIn, AluSrcIn, BranchIn, MemReadIn, MemWriteIn,
    MemToRegIn, errIn1, errIn2, errIn3,
    /* register */ RegWriteIn, JumpIn, HaltIn,
    RsIn, RtIn, RsValidIn, RtValidIn, writeRegValidIn, controlZeroIdEx1, controlZeroIdEx2,
    /* output */ readData1Out, readData2Out, pcOut, immValOut, jumpDistOut, functOut,
    writeRegOut, 
    /* control */ AluOpOut, AluSrcOut, BranchOut, MemReadOut, MemWriteOut,
    MemToRegOut, errOut,
    /* register */ RegWriteOut, JumpOut, HaltOut,
    RsOut, RtOut, RsValidOut, RtValidOut, writeRegValidOut);

    input [15:0] pcIn, readData1In, readData2In, immValIn, jumpDistIn;
    input [4:0] AluOpIn;
    input [2:0] writeRegIn;
    input [1:0] functIn;
    input AluSrcIn, BranchIn, MemReadIn, MemWriteIn, MemToRegIn, 
        RegWriteIn, JumpIn, HaltIn, controlZeroIdEx1, controlZeroIdEx2, errIn1, errIn2, errIn3;
    input [2:0] RsIn, RtIn;
    input RsValidIn, RtValidIn, writeRegValidIn;
    input clk, rst;

    output [4:0] AluOpOut;
    output [2:0] writeRegOut;
    output [1:0] functOut;
    output AluSrcOut, BranchOut, MemReadOut, MemWriteOut, MemToRegOut, 
        RegWriteOut, JumpOut, HaltOut, errOut;
    output [15:0] readData1Out, readData2Out, pcOut, immValOut, jumpDistOut;
    output [2:0] RsOut, RtOut;
    output RsValidOut, RtValidOut, writeRegValidOut;

    wire controlZero, MemWriteInFinal, RegWriteInFinal, HaltInFinal, 
        BranchInFinal, JumpInFinal, MemReadInFinal, errIn;

    dff RAO [4:0] (.q(AluOpOut),     .d(AluOpIn),     .clk(clk), .rst(rst));
    dff RWR [2:0] (.q(writeRegOut), .d(writeRegIn), .clk(clk), .rst(rst));
    dff RI [1:0] (.q(functOut), .d(functIn), .clk(clk), .rst(rst));
    dff RAS (.q(AluSrcOut),    .d(AluSrcIn),    .clk(clk), .rst(rst));
    dff RPC [15:0] (.q(pcOut),        .d(pcIn),        .clk(clk), .rst(rst));
    dff RD1 [15:0] (.q(readData1Out),     .d(readData1In),     .clk(clk), .rst(rst));
    dff RD2 [15:0] (.q(readData2Out),     .d(readData2In),     .clk(clk), .rst(rst));
    dff RIM   [15:0] (.q(immValOut),       .d(immValIn),       .clk(clk), .rst(rst));
    dff RJD [15:0] (.q(jumpDistOut),  .d(jumpDistIn),  .clk(clk), .rst(rst));
    
    assign controlZero = (controlZeroIdEx1 | controlZeroIdEx2);
    assign MemWriteInFinal = (controlZero) ? 1'b0 : MemWriteIn;
    assign RegWriteInFinal = (controlZero) ? 1'b0 : RegWriteIn;
    assign HaltInFinal = (controlZero)? 1'b0: HaltIn;
    assign BranchInFinal = controlZero? 1'b0: BranchIn;
    assign JumpInFinal = controlZero? 1'b0: JumpIn;
    assign MemReadInFinal = controlZero? 1'b0: MemReadIn;
    assign errIn = errIn1 | errIn2 | errIn3;

    dff BR_FF       (.q(BranchOut),     .d(BranchInFinal),     .clk(clk), .rst(rst));
    dff MEMR_FF     (.q(MemReadOut),   .d(MemReadInFinal),   .clk(clk), .rst(rst));
    dff MEMW_FF     (.q(MemWriteOut),  .d(MemWriteInFinal),  .clk(clk), .rst(rst));
    dff RW_FF       (.q(RegWriteOut),  .d(RegWriteInFinal),  .clk(clk), .rst(rst));
    dff MEMTR_FF    (.q(MemToRegOut), .d(MemToRegIn), .clk(clk), .rst(rst));
    dff JUMP_FF     (.q(JumpOut),       .d(JumpInFinal),       .clk(clk), .rst(rst));
    dff HALT_FF     (.q(HaltOut),       .d(HaltInFinal),       .clk(clk), .rst(rst));

    dff RRS [2:0] (.q(RsOut), .d(RsIn), .clk(clk), .rst(rst));
    dff RRT [2:0] (.q(RtOut), .d(RtIn), .clk(clk), .rst(rst));
    dff RRSV  (.q(RsValidOut), .d(RsValidIn), .clk(clk), .rst(rst));
    dff RRTV  (.q(RtValidOut), .d(RtValidIn), .clk(clk), .rst(rst));
    dff RRDV (.q(writeRegValidOut), .d(writeRegValidIn), .clk(clk), .rst(rst));
    dff ERR (.q(errOut), .d(errIn), .clk(clk), .rst(rst));
endmodule
