module ifid_reg(/*input */ lastPcOut, lastInstrOut, lastValidInsOut, lastRsValidOut, 
    lastRtValidOut, lastWriteRegValidOut,
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

    wire validInsInIntm, validInsInFinal, RsValidInFinal, RtValidInFinal, writeRegValidInFinal;
    wire [15:0] pcInFinal, writeIfIdFinal;
    
    assign validInsInIntm = flushIf? 1'b0: validInsIn;
    assign pcInFinal = (writeIfId)? pcIn: lastPcOut;
    assign instrFinal = (writeIfId)? instrIn: lastInstrOut;
    assign validInsInFinal = (writeIfId)? validInsInIntm: lastValidInsOut;
    assign RsValidInFinal = (writeIfId)? RsValidIn: lastRsValidOut;
    assign RtValidInFinal = (writeIfId)? RtValidIn: lastRtValidOut;
    assign writeRegValidInFinal = (writeIfId)? writeRegValidIn: lastWriteRegValidOut;

    dff RP [15:0]  (.q(pcOut), .d(pcInFinal), .clk(clk), .rst(rst));
    dff RI [15:0] (.q(instrOut), .d(instrFinal), .clk(clk), .rst(rst));

    dff RIV (.q(validInsOut), .d(validInsInFinal), .clk(clk), .rst(rst));
    dff RSV (.q(RsValidOut), .d(RsValidInFinal), .clk(clk), .rst(rst));
    dff RTV (.q(RtValidOut), .d(RtValidInFinal), .clk(clk), .rst(rst));
    dff RWV (.q(writeRegValidOut), .d(writeRegValidInFinal), .clk(clk), .rst(rst));

endmodule
