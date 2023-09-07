module ifid_reg(/*input */ pcIn, instrIn, validInsIn, RsIn, RtIn, RsValidIn, RtValidIn, writeRegValidIn, flushIf,
    writeIfId1, writeIfId2, errIn, clk, rst, 
    /* output */ pcOut, instrOut, RsOut, RtOut, validInsOut, RsValidOut, 
    RtValidOut, writeRegValidOut, errOut);

    input [15:0] pcIn, instrIn;
    input [2:0] RsIn, RtIn;
    input validInsIn, RsValidIn, RtValidIn, writeRegValidIn, flushIf, writeIfId1, writeIfId2, errIn;
    input clk, rst;

    output [15:0] pcOut, instrOut;
    output [2:0] RsOut, RtOut;
    output validInsOut, RsValidOut, RtValidOut, writeRegValidOut, errOut;

    wire writeIfId, validInsInIntm, validInsInFinal, RsValidInFinal, RtValidInFinal, 
        writeRegValidInFinal, errInFinal;
    wire [15:0] pcInFinal, instrFinal;
    wire [2:0] RsInFinal, RtInFinal;
    
    assign writeIfId = writeIfId1 & writeIfId2;
    assign validInsInIntm = flushIf? 1'b0: validInsIn;

    reg_nb #(.REG_WIDTH(16)) PCR (.rdData(pcOut), .wrData(pcIn), .wr(writeIfId), .clk(clk), .rst(rst));
    
    reg_nb #(.REG_WIDTH(16)) RI (.rdData(instrOut), .wrData(instrIn), .wr(writeIfId), .clk(clk), .rst(rst));

    reg_nb #(.REG_WIDTH(3)) RRS (.rdData(RsOut), .wrData(RsIn), .wr(writeIfId), .clk(clk), .rst(rst));
    reg_nb #(.REG_WIDTH(3)) RRT (.rdData(RtOut), .wrData(RtIn), .wr(writeIfId), .clk(clk), .rst(rst));

    reg_nb #(.REG_WIDTH(1)) RIV (.rdData(validInsOut), .wrData(validInsInIntm), .wr(writeIfId), .clk(clk), .rst(rst));
    reg_nb #(.REG_WIDTH(1)) RSV (.rdData(RsValidOut), .wrData(RsValidIn), .wr(writeIfId), .clk(clk), .rst(rst));
    reg_nb #(.REG_WIDTH(1)) RTV (.rdData(RtValidOut), .wrData(RtValidIn), .wr(writeIfId), .clk(clk), .rst(rst));
    reg_nb #(.REG_WIDTH(1)) RWV (.rdData(writeRegValidOut), .wrData(writeRegValidIn), .wr(writeIfId), .clk(clk), .rst(rst));
    reg_nb #(.REG_WIDTH(1)) ERR (.rdData(errOut), .wrData(errIn), .wr(writeIfId), .clk(clk), .rst(rst));

endmodule
