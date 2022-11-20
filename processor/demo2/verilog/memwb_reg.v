module memwb_reg(/*input*/ memDataIn,  
                    aluResIn, writeRegIn, MemToRegIn, RegWriteIn, MemReadIn,
                    writeRegValidIn, clk, rst,  
                    /*output*/ memDataOut, aluResOut, 
                    writeRegOut, MemToRegOut, RegWriteOut, MemReadOut,
                    writeRegValidOut);

    input [15:0]memDataIn, aluResIn;
    input [2:0] writeRegIn;
    input MemToRegIn, RegWriteIn, MemReadIn;
    input  writeRegValidIn;
    input clk, rst;

    output [15:0] memDataOut, aluResOut;
    output [2:0] writeRegOut;
    output MemToRegOut, RegWriteOut, MemReadOut;
    output writeRegValidOut;

    dff RMD [15:0](.q(memDataOut),     .d(memDataIn),     .clk(clk), .rst(rst));
    dff RAR [15:0](.q(aluResOut),   .d(aluResIn),   .clk(clk), .rst(rst));
    dff RWR [2:0] (.q(writeRegOut), .d(writeRegIn), .clk(clk), .rst(rst));

    dff RMTR (.q(MemToRegOut), .d(MemToRegIn), .clk(clk), .rst(rst));
    dff RRW (.q(RegWriteOut),  .d(RegWriteIn),  .clk(clk), .rst(rst));
    dff RMR (.q(MemReadOut),  .d(MemReadIn),  .clk(clk), .rst(rst));
    
    dff RS (.q(writeRegValidOut),       .d(writeRegValidIn),       .clk(clk), .rst(rst));
endmodule
