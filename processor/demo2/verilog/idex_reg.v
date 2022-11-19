module idex_reg(/* input */ clk, rst, pcIn, read1_in, read2_in, imm_in, jumpDistIn,
    funct_in, writeRegIn,
    AluOpIn, AluSrcIn, BranchIn, MemReadIn, MemWriteIn,
    MemToRegIn, RegWriteIn, JumpIn, halt_in,
    RsIn, RtIn, RsValidIn, RtValidIn, writeRegValidIn, controlZeroIdEx1, controlZeroIdEx2,
    /* output */ read1_out, read2_out, pcOut, imm_out, jumpDistOut, funct_out,
    writeRegOut, AluOpOut, AluSrcOut, BranchOut, MemReadOut, MemWriteOut,
    MemToRegOut, RegWriteOut, JumpOut, halt_out,
    RsOut, RtOut, RsValidOut, RtValidOut, writeRegValidOut);

    input clk, rst;
    input [15:0] pcIn, read1_in, read2_in, imm_in, jumpDistIn;
    input [4:0] AluOpIn;
    input [2:0] writeRegIn;
    input [1:0] funct_in;
    input AluSrcIn, BranchIn, MemReadIn, MemWriteIn, MemToRegIn, 
        RegWriteIn, JumpIn, halt_in, controlZeroIdEx1, controlZeroIdEx2;
    input [2:0] RsIn, RtIn;
    input RsValidIn, RtValidIn, writeRegValidIn;

    output [4:0] AluOpOut;
    output [2:0] writeRegOut;
    output [1:0] funct_out;
    output AluSrcOut, BranchOut, MemReadOut, MemWriteOut, MemToRegOut, 
        RegWriteOut, JumpOut, halt_out;
    output [15:0] read1_out, read2_out, pcOut, imm_out, jumpDistOut;
    output [2:0] RsOut, RtOut;
    output RsValidOut, RtValidOut, writeRegValidOut;

    wire MemWriteInFinal, RegWriteInFinal;

    dff PC_FF    [15:0] (.q(pcOut),        .d(pcIn),        .clk(clk), .rst(rst));
    dff READ1_FF [15:0] (.q(read1_out),     .d(read1_in),     .clk(clk), .rst(rst));
    dff READ2_FF [15:0] (.q(read2_out),     .d(read2_in),     .clk(clk), .rst(rst));
    dff IMM_FF   [15:0] (.q(imm_out),       .d(imm_in),       .clk(clk), .rst(rst));
    dff JUMPA_FF [15:0] (.q(jumpDistOut),  .d(jumpDistIn),  .clk(clk), .rst(rst));

    dff OP_FF [4:0] (.q(AluOpOut),     .d(AluOpIn),     .clk(clk), .rst(rst));
    
    dff WRITE_REG [2:0] (.q(writeRegOut), .d(writeRegIn), .clk(clk), .rst(rst));

    dff INSTR [1:0] (.q(funct_out), .d(funct_in), .clk(clk), .rst(rst));

    dff SRC_FF      (.q(AluSrcOut),    .d(AluSrcIn),    .clk(clk), .rst(rst));
    dff BR_FF       (.q(BranchOut),     .d(BranchIn),     .clk(clk), .rst(rst));
    dff MEMR_FF     (.q(MemReadOut),   .d(MemReadIn),   .clk(clk), .rst(rst));
    
    assign MemWriteInFinal = (controlZeroIdEx1 | controlZeroIdEx2) ? 1'b0 : MemWriteIn;
    assign RegWriteInFinal = (controlZeroIdEx1 | controlZeroIdEx2) ? 1'b0 : RegWriteIn;

    dff MEMW_FF     (.q(MemWriteOut),  .d(MemWriteInFinal),  .clk(clk), .rst(rst));
    dff RW_FF       (.q(RegWriteOut),  .d(RegWriteInFinal),  .clk(clk), .rst(rst));

    dff MEMTR_FF    (.q(MemToRegOut), .d(MemToRegIn), .clk(clk), .rst(rst));
    dff JUMP_FF     (.q(JumpOut),       .d(JumpIn),       .clk(clk), .rst(rst));
    dff HALT_FF     (.q(halt_out),       .d(halt_in),       .clk(clk), .rst(rst));

    dff RRS [2:0] (.q(RsOut), .d(RsIn), .clk(clk), .rst(rst));
    dff RRT [2:0] (.q(RtOut), .d(RtIn), .clk(clk), .rst(rst));
    dff RRSV  (.q(RsValidOut), .d(RsValidIn), .clk(clk), .rst(rst));
    dff RRTV  (.q(RtValidOut), .d(RtValidIn), .clk(clk), .rst(rst));
    dff RRDV (.q(writeRegValidOut), .d(writeRegValidIn), .clk(clk), .rst(rst));
endmodule
