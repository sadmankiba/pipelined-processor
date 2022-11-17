module ifid_reg(/*input */ pc_in, instr_in, validInsIn, RsValidIn, RtValidIn, writeRegValidIn, clk, rst, 
    /* output */ pc_out, instr_out, validInsOut, RsValidOut, RtValidOut, writeRegValidOut);

    input [15:0] pc_in, instr_in;
    input validInsIn, RsValidIn, RtValidIn, writeRegValidIn;
    input clk, rst;

    output [15:0] pc_out, instr_out;
    output validInsOut, RsValidOut, RtValidOut, writeRegValidOut;

    dff RP [15:0]  (.q(pc_out), .d(pc_in), .clk(clk), .rst(rst));
    dff RI [15:0] (.q(instr_out), .d(instr_in), .clk(clk), .rst(rst));

    dff RV (.q(validInsOut), .d(validInsIn), .clk(clk), .rst(rst));
    dff RV (.q(RsValidOut), .d(RsValidIn), .clk(clk), .rst(rst));
    dff RV (.q(RtValidOut), .d(RtValidIn), .clk(clk), .rst(rst));
    dff RV (.q(writeRegValidOut), .d(writeRegValidIn), .clk(clk), .rst(rst));

endmodule
