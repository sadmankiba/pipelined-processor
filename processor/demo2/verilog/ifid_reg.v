module ifid_reg(/*input */ pcIn, instrIn, validInsIn, RsValidIn, RtValidIn, writeRegValidIn, 
    writeIfId, clk, rst, 
    /* output */ pcOut, instrOut, validInsOut, RsValidOut, RtValidOut, writeRegValidOut);

    input [15:0] pcIn, instrIn;
    input validInsIn, RsValidIn, RtValidIn, writeRegValidIn, writeIfId;
    input clk, rst;

    output [15:0] pcOut, instrOut;
    output validInsOut, RsValidOut, RtValidOut, writeRegValidOut;

    dff RP [15:0]  (.q(pcOut), .d(pcIn), .clk(clk), .rst(rst));
    dff RI [15:0] (.q(instrOut), .d(instrIn), .clk(clk), .rst(rst));

    dff RV (.q(validInsOut), .d(validInsIn), .clk(clk), .rst(rst));
    dff RV (.q(RsValidOut), .d(RsValidIn), .clk(clk), .rst(rst));
    dff RV (.q(RtValidOut), .d(RtValidIn), .clk(clk), .rst(rst));
    dff RV (.q(writeRegValidOut), .d(writeRegValidIn), .clk(clk), .rst(rst));

endmodule
