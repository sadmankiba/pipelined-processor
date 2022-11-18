module memwb_reg(/*input*/ data_mem_in,  
                    aluResIn, writeRegIn, MemToRegIn, RegWriteIn, MemReadIn,
                    writeRegValidIn, clk, rst,  
                    /*output*/ data_mem_out, aluResOut, 
                    writeRegOut, MemToRegOut, RegWriteOut, MemReadOut,
                    writeRegValidOut);

    input [15:0]data_mem_in, aluResIn;
    input [2:0] writeRegIn;
    input MemToRegIn, RegWriteIn, MemReadIn;
    input  writeRegValidIn;
    input clk, rst;

    output [15:0] data_mem_out, aluResOut;
    output [2:0] writeRegOut;
    output MemToRegOut, RegWriteOut, MemReadOut;
    output writeRegValidOut;

    dff DMEM [15:0](.q(data_mem_out),     .d(data_mem_in),     .clk(clk), .rst(rst));
    dff ALUR [15:0](.q(aluResOut),   .d(aluResIn),   .clk(clk), .rst(rst));

    dff WREG [2:0] (.q(writeRegOut), .d(writeRegIn), .clk(clk), .rst(rst));

    dff RMTR (.q(MemToRegOut), .d(MemToRegIn), .clk(clk), .rst(rst));
    dff RRW (.q(RegWriteOut),  .d(RegWriteIn),  .clk(clk), .rst(rst));
    dff RMR (.q(MemReadOut),  .d(MemReadIn),  .clk(clk), .rst(rst));
    
    dff RS (.q(writeRegValidOut),       .d(writeRegValidIn),       .clk(clk), .rst(rst));
endmodule
