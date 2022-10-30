module reg_16b (in, out, clk, rst);
    input [15:0] in;
    input clk;
    output out;
    
    dff DF0(out[0], in[0], clk, rst);
    dff DF1(out[1], in[1], clk, rst);
    dff DF2(out[2], in[2], clk, rst);
    dff DF3(out[3], in[3], clk, rst);
    dff DF4(out[4], in[4], clk, rst);
    dff DF5(out[5], in[5], clk, rst);
    dff DF6(out[6], in[6], clk, rst);
    dff DF7(out[7], in[7], clk, rst);
    dff DF8(out[8], in[8], clk, rst);
    dff DF9(out[9], in[9], clk, rst);
    dff DF10(out[10], in[10], clk, rst);
    dff DF11(out[11], in[11], clk, rst);
    dff DF12(out[12], in[12], clk, rst);
    dff DF13(out[13], in[13], clk, rst);
    dff DF14(out[14], in[14], clk, rst);
    dff DF15(out[15], in[15], clk, rst);
endmodule