/*
   CS/ECE 552 Spring '20
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/

module fetch(pc, clk, rst, instr, next_pc, err);
   // TODO: Your code here
  input [15:0] pc;
  input clk, rst;

  output [15:0] next_pc;
  output [15:0] instr;
  output err;

  wire [15:0] pcCurrent;  
  wire cin;
  wire [15:0] increment_pc;
  wire sign;
  wire dump, wr, enable;
  wire [15:0] data_in;

  assign increment_pc = 16'b0000_0000_0000_0010;
  assign sign = 1'b0; //I don't think it is signed
  assign cin = 1'b0;  //No cin
  assign data_in = 16'b0000_0000_0000_0000;
  assign dump = 1'b0;
  assign wr = 1'b0;
  assign enable = ~rst;  //Might not want to always have this enabled

  dff ZERO(.q(pcCurrent[0]),  .d(pc[0]),  .clk(clk), .rst(rst));
  dff ONE (.q(pcCurrent[1]),  .d(pc[1]),  .clk(clk), .rst(rst));
  dff TWO (.q(pcCurrent[2]),  .d(pc[2]),  .clk(clk), .rst(rst));
  dff THRE(.q(pcCurrent[3]),  .d(pc[3]),  .clk(clk), .rst(rst));
  dff FOUR(.q(pcCurrent[4]),  .d(pc[4]),  .clk(clk), .rst(rst));
  dff FIVE(.q(pcCurrent[5]),  .d(pc[5]),  .clk(clk), .rst(rst));
  dff SIX (.q(pcCurrent[6]),  .d(pc[6]),  .clk(clk), .rst(rst));
  dff SEVE(.q(pcCurrent[7]),  .d(pc[7]),  .clk(clk), .rst(rst));
  dff EIGH(.q(pcCurrent[8]),  .d(pc[8]),  .clk(clk), .rst(rst));
  dff NINE(.q(pcCurrent[9]),  .d(pc[9]),  .clk(clk), .rst(rst));
  dff TEN (.q(pcCurrent[10]), .d(pc[10]), .clk(clk), .rst(rst));
  dff ELEV(.q(pcCurrent[11]), .d(pc[11]), .clk(clk), .rst(rst));
  dff TWEL(.q(pcCurrent[12]), .d(pc[12]), .clk(clk), .rst(rst));
  dff THIR(.q(pcCurrent[13]), .d(pc[13]), .clk(clk), .rst(rst));
  dff FORT(.q(pcCurrent[14]), .d(pc[14]), .clk(clk), .rst(rst));
  dff FIFT(.q(pcCurrent[15]), .d(pc[15]), .clk(clk), .rst(rst));

  //add 2 to the get the next pc
  cla_16b ADD(.a(pcCurrent), .b(increment_pc), .c_in(cin), .sign(sign), .sum(next_pc), .ofl(err));

  //Get next instruction from instruction memory
  memory2c IMEM(.data_out(instr), .data_in(data_in), .addr(pcCurrent), .enable(enable), .wr(wr), .createdump(dump), .clk(clk), .rst(rst)); 

endmodule

