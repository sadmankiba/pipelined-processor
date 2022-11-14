module register(writeData, write, clk, rst, readReg);
  input [15:0] writeData;
  input write;
  input clk, rst;
  
  output [15:0] readReg;

  wire [15:0] dffIn;
  
  assign dffIn = write ? writeData : readReg;   
  dff REGS[15:0](.q(readReg),  .d(dffIn),  .clk(clk), .rst(rst));
endmodule
