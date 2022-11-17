module ifid_reg(/*input */ lastPcOut, lastInstrOut, lastValidInsOut, lastRsValidOut, lastRtValidOut, lastWriteRegValidOut
    pcIn, instrIn, validInsIn, RsValidIn, RtValidIn, writeRegValidIn, flushIf,
    writeIfId, clk, rst, 
    /* output */ pcOut, instrOut, validInsOut, RsValidOut, RtValidOut, writeRegValidOut);

    input [15:0] lastPcOut, lastInstrOut;
    input lastValidInsOut, lastRsValidOut, lastRtValidOut, lastWriteRegValidOut;
    input [15:0] pcIn, instrIn;
    input validInsIn, RsValidIn, RtValidIn, writeRegValidIn, flushIf, writeIfId;
    input clk, rst;

    output [15:0] pcOut, instrOut;
    output validInsOut, RsValidOut, RtValidOut, writeRegValidOut;

    wire validInsInFinal = flushIf? 1'b0: validInsIn;

    dff RP [15:0]  (.q(pcOut), .d(writeIfId? pcIn: lastPcOut), .clk(clk), .rst(rst));
    dff RI [15:0] (.q(instrOut), .d(writeIfId? instrIn: lastInstrOut), .clk(clk), .rst(rst));

    dff RV (.q(validInsOut), .d(writeIfId? validInsInFinal: lastValidInsOut), .clk(clk), .rst(rst));
    dff RV (.q(RsValidOut), .d(writeIfId? RsValidIn: lastRsValidOut), .clk(clk), .rst(rst));
    dff RV (.q(RtValidOut), .d(writeIfId? RtValidIn: lastRtValidOut), .clk(clk), .rst(rst));
    dff RV (.q(writeRegValidOut), .d(writeIfId? writeRegValidIn: lastWriteRegValidOut), .clk(clk), .rst(rst));

    assign lastPcOut = pcOut;
    assign lastInstrOut = instrOut;
    assign lastValidInsOut = validInsOut;
    assign lastRsValidOut = RsValidOut;
    assign lastRtValidOut = RtValidOut;
    assign lastWriteRegValidOut = writeRegValidOut;

endmodule
