module reg_nb (rdData, wrData, wr, clk, rst);
    parameter REG_WIDTH = 16;  
    input [REG_WIDTH - 1:0] wrData;
    input wr;
    input clk, rst;
    
    output [REG_WIDTH - 1:0] rdData;

    wire [REG_WIDTH - 1:0] regIn;
    
    assign regIn = wr ? wrData : rdData;   
    dff REGS[REG_WIDTH - 1:0](.q(rdData),  .d(regIn),  .clk(clk), .rst(rst));
endmodule
