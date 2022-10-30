module reg_16b (write, writeData, readData, clk, rst);
    input [15:0] writeData;
    input clk;
    output [15:0] readData;
    
    dff DF0(.q(readData[0]), .d(writeData[0]), .clk(clk), .rst(rst));
    dff DF1(readData[1], writeData[1], clk, rst);
    dff DF2(readData[2], writeData[2], clk, rst);
    dff DF3(readData[3], writeData[3], clk, rst);
    dff DF4(readData[4], writeData[4], clk, rst);
    dff DF5(readData[5], writeData[5], clk, rst);
    dff DF6(readData[6], writeData[6], clk, rst);
    dff DF7(readData[7], writeData[7], clk, rst);
    dff DF8(readData[8], writeData[8], clk, rst);
    dff DF9(readData[9], writeData[9], clk, rst);
    dff DF10(readData[10], writeData[10], clk, rst);
    dff DF11(readData[11], writeData[11], clk, rst);
    dff DF12(readData[12], writeData[12], clk, rst);
    dff DF13(readData[13], writeData[13], clk, rst);
    dff DF14(readData[14], writeData[14], clk, rst);
    dff DF15(readData[15], writeData[15], clk, rst);
endmodule