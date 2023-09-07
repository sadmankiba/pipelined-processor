module idex_reg(/* input */ clk, rst, pcIn, readData1In, readData2In, immValIn, jumpDistIn,
    functIn, writeRegIn,
    /* control */ AluOpIn, AluSrcIn, BranchIn, MemReadIn, MemWriteIn,
    MemToRegIn, writeIdEx, errIn1, errIn2, errIn3,
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
        RegWriteIn, JumpIn, HaltIn, controlZeroIdEx1, controlZeroIdEx2, 
        writeIdEx, errIn1, errIn2, errIn3;
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

    reg_nb #(.REG_WIDTH(5)) RAO (.rdData(AluOpOut), .wrData(AluOpIn), .wr(writeIdEx), .clk(clk), .rst(rst));
    reg_nb #(.REG_WIDTH(3)) RWR (.rdData(writeRegOut), .wrData(writeRegIn), .wr(writeIdEx), .clk(clk), .rst(rst));
    reg_nb #(.REG_WIDTH(2)) RI (.rdData(functOut), .wrData(functIn), .wr(writeIdEx), .clk(clk), .rst(rst));
    reg_nb #(.REG_WIDTH(1)) RAS (.rdData(AluSrcOut),    .wrData(AluSrcIn),    .wr(writeIdEx), .clk(clk), .rst(rst));
    reg_nb #(.REG_WIDTH(16)) RPC (.rdData(pcOut),        .wrData(pcIn),        .wr(writeIdEx), .clk(clk), .rst(rst));
    reg_nb #(.REG_WIDTH(16)) RD1 (.rdData(readData1Out),     .wrData(readData1In),     .wr(writeIdEx), .clk(clk), .rst(rst));
    reg_nb #(.REG_WIDTH(16)) RD2 (.rdData(readData2Out),     .wrData(readData2In),     .wr(writeIdEx), .clk(clk), .rst(rst));
    reg_nb #(.REG_WIDTH(16)) RIM (.rdData(immValOut),       .wrData(immValIn),       .wr(writeIdEx), .clk(clk), .rst(rst));
    reg_nb #(.REG_WIDTH(16)) RJD (.rdData(jumpDistOut),  .wrData(jumpDistIn),  .wr(writeIdEx), .clk(clk), .rst(rst));
    
    assign controlZero = (controlZeroIdEx1 | controlZeroIdEx2);
    assign MemWriteInFinal = (controlZero) ? 1'b0 : MemWriteIn;
    assign RegWriteInFinal = (controlZero) ? 1'b0 : RegWriteIn;
    assign HaltInFinal = (controlZero)? 1'b0: HaltIn;
    assign BranchInFinal = controlZero? 1'b0: BranchIn;
    assign JumpInFinal = controlZero? 1'b0: JumpIn;
    assign MemReadInFinal = controlZero? 1'b0: MemReadIn;
    assign errIn = errIn1 | errIn2 | errIn3;

    reg_nb #(.REG_WIDTH(1)) BR (.rdData(BranchOut), .wrData(BranchInFinal),     .wr(writeIdEx), .clk(clk), .rst(rst));
    reg_nb #(.REG_WIDTH(1)) MRD (.rdData(MemReadOut), .wrData(MemReadInFinal), .wr(writeIdEx), .clk(clk), .rst(rst));
    reg_nb #(.REG_WIDTH(1)) MEMW (.rdData(MemWriteOut),  .wrData(MemWriteInFinal),  .wr(writeIdEx), .clk(clk), .rst(rst));
    reg_nb #(.REG_WIDTH(1)) RW (.rdData(RegWriteOut),  .wrData(RegWriteInFinal),  .wr(writeIdEx), .clk(clk), .rst(rst));
    reg_nb #(.REG_WIDTH(1)) MTR (.rdData(MemToRegOut), .wrData(MemToRegIn), .wr(writeIdEx), .clk(clk), .rst(rst));
    reg_nb #(.REG_WIDTH(1)) JMP (.rdData(JumpOut),  .wrData(JumpInFinal),       .wr(writeIdEx), .clk(clk), .rst(rst));
    reg_nb #(.REG_WIDTH(1)) HLT (.rdData(HaltOut),       .wrData(HaltInFinal),       .wr(writeIdEx), .clk(clk), .rst(rst));

    reg_nb #(.REG_WIDTH(3)) RRS (.rdData(RsOut), .wrData(RsIn), .wr(writeIdEx), .clk(clk), .rst(rst));
    reg_nb #(.REG_WIDTH(3)) RRT (.rdData(RtOut), .wrData(RtIn), .wr(writeIdEx), .clk(clk), .rst(rst));
    reg_nb #(.REG_WIDTH(1)) RRSV (.rdData(RsValidOut), .wrData(RsValidIn), .wr(writeIdEx), .clk(clk), .rst(rst));
    reg_nb #(.REG_WIDTH(1)) RRTV (.rdData(RtValidOut), .wrData(RtValidIn), .wr(writeIdEx), .clk(clk), .rst(rst));
    reg_nb #(.REG_WIDTH(1)) RRDV (.rdData(writeRegValidOut), .wrData(writeRegValidIn), .wr(writeIdEx), .clk(clk), .rst(rst));
    reg_nb #(.REG_WIDTH(1)) ERR (.rdData(errOut), .wrData(errIn), .wr(writeIdEx), .clk(clk), .rst(rst));
endmodule
