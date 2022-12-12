module ifid_reg(/*input */ lastPcOut, lastInstrOut, lastRsIn, lastRtIn, 
    lastValidInsOut, lastRsValidOut, lastRtValidOut, lastWriteRegValidOut, lastErrOut,
    pcIn, instrIn, validInsIn, RsIn, RtIn, RsValidIn, RtValidIn, writeRegValidIn, flushIf,
    writeIfId, errIn, clk, rst, 
    /* output */ pcOut, instrOut, RsOut, RtOut, validInsOut, RsValidOut, 
    RtValidOut, writeRegValidOut, errOut);

    input [15:0] lastPcOut, lastInstrOut;
    input lastValidInsOut, lastRsValidOut, lastRtValidOut, lastWriteRegValidOut, lastErrOut;
    input [15:0] pcIn, instrIn;
    input [2:0] RsIn, RtIn, lastRsIn, lastRtIn;
    input validInsIn, RsValidIn, RtValidIn, writeRegValidIn, flushIf, writeIfId, errIn;
    input clk, rst;

    output [15:0] pcOut, instrOut;
    output [2:0] RsOut, RtOut;
    output validInsOut, RsValidOut, RtValidOut, writeRegValidOut, errOut;

    wire validInsInIntm, validInsInFinal, RsValidInFinal, RtValidInFinal, 
        writeRegValidInFinal, errInFinal;
    wire [15:0] pcInFinal, instrFinal;
    wire [2:0] RsInFinal, RtInFinal;
    
    assign validInsInIntm = flushIf? 1'b0: validInsIn;
    assign pcInFinal = (writeIfId)? pcIn: lastPcOut;
    assign instrFinal = (writeIfId)? instrIn: lastInstrOut;
    assign validInsInFinal = (writeIfId)? validInsInIntm: lastValidInsOut;
    assign RsValidInFinal = (writeIfId)? RsValidIn: lastRsValidOut;
    assign RtValidInFinal = (writeIfId)? RtValidIn: lastRtValidOut;
    assign writeRegValidInFinal = (writeIfId)? writeRegValidIn: lastWriteRegValidOut;
    assign RsInFinal = (writeIfId)? RsIn: lastRsIn;
    assign RtInFinal = (writeIfId)? RtIn: lastRtIn;
    assign errInFinal = (writeIfId)? errIn: lastErrOut;

    dff RP [15:0]  (.q(pcOut), .d(pcInFinal), .clk(clk), .rst(rst));
    dff RI [15:0] (.q(instrOut), .d(instrFinal), .clk(clk), .rst(rst));

    dff RRS [2:0] (.q(RsOut), .d(RsInFinal), .clk(clk), .rst(rst));
    dff RRT [2:0] (.q(RtOut), .d(RtInFinal), .clk(clk), .rst(rst));

    dff RIV (.q(validInsOut), .d(validInsInFinal), .clk(clk), .rst(rst));
    dff RSV (.q(RsValidOut), .d(RsValidInFinal), .clk(clk), .rst(rst));
    dff RTV (.q(RtValidOut), .d(RtValidInFinal), .clk(clk), .rst(rst));
    dff RWV (.q(writeRegValidOut), .d(writeRegValidInFinal), .clk(clk), .rst(rst));
    dff ERR (.q(errOut), .d(errInFinal), .clk(clk), .rst(rst));

endmodule
