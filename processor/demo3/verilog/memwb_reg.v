module memwb_reg(/*input*/ memDataIn,  
                    aluResIn, writeRegIn, MemToRegIn, RegWriteIn, MemReadIn,
                    writeRegValidIn, controlZero, errIn1, errIn2, clk, rst,  
                    /*output*/ memDataOut, aluResOut, 
                    writeRegOut, MemToRegOut, RegWriteOut, MemReadOut,
                    writeRegValidOut, errOut);

    input [15:0]memDataIn, aluResIn;
    input [2:0] writeRegIn;
    input MemToRegIn, RegWriteIn, MemReadIn, controlZero, errIn1, errIn2;
    input  writeRegValidIn;
    input clk, rst;

    output [15:0] memDataOut, aluResOut;
    output [2:0] writeRegOut;
    output MemToRegOut, RegWriteOut, MemReadOut, errOut;
    output writeRegValidOut;

    wire RegWriteInFinal, MemReadInFinal, errIn;

    assign errIn = errIn1 | errIn2; 
    assign RegWriteInFinal = controlZero? 1'b0: RegWriteIn;
    assign MemReadInFinal = controlZero? 1'b0: MemReadIn;

    dff RMD [15:0](.q(memDataOut),     .d(memDataIn),     .clk(clk), .rst(rst));
    dff RAR [15:0](.q(aluResOut),   .d(aluResIn),   .clk(clk), .rst(rst));
    dff RWR [2:0] (.q(writeRegOut), .d(writeRegIn), .clk(clk), .rst(rst));

    dff RMTR (.q(MemToRegOut), .d(MemToRegIn), .clk(clk), .rst(rst));
    dff RRW (.q(RegWriteOut),  .d(RegWriteInFinal),  .clk(clk), .rst(rst));
    dff RMR (.q(MemReadOut),  .d(MemReadInFinal),  .clk(clk), .rst(rst));
    
    dff RS (.q(writeRegValidOut),      .d(writeRegValidIn),       .clk(clk), .rst(rst));
    dff ERR (.q(errOut), .d(errIn), .clk(clk), .rst(rst));
endmodule
