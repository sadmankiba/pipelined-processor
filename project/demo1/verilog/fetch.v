/*
   CS/ECE 552 Spring '20
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/

module fetch(pc, clk, rst, instr, pcOut, err);
    // TODO: Your code here
    input [15:0] pc;
    input clk, rst;

    output [15:0] pcOut, instr;
    output err;

    wire [15:0] pcCurrent;  
    wire enable;

    dff DF0(.q(pcCurrent[0]),  .d(pc[0]),  .clk(clk), .rst(rst));
    dff DF1(.q(pcCurrent[1]),  .d(pc[1]),  .clk(clk), .rst(rst));
    dff DF2(.q(pcCurrent[2]),  .d(pc[2]),  .clk(clk), .rst(rst));
    dff DF3(.q(pcCurrent[3]),  .d(pc[3]),  .clk(clk), .rst(rst));
    dff DF4(.q(pcCurrent[4]),  .d(pc[4]),  .clk(clk), .rst(rst));
    dff DF5(.q(pcCurrent[5]),  .d(pc[5]),  .clk(clk), .rst(rst));
    dff DF6(.q(pcCurrent[6]),  .d(pc[6]),  .clk(clk), .rst(rst));
    dff DF7(.q(pcCurrent[7]),  .d(pc[7]),  .clk(clk), .rst(rst));
    dff DF8(.q(pcCurrent[8]),  .d(pc[8]),  .clk(clk), .rst(rst));
    dff DF9(.q(pcCurrent[9]),  .d(pc[9]),  .clk(clk), .rst(rst));
    dff DF10(.q(pcCurrent[10]), .d(pc[10]), .clk(clk), .rst(rst));
    dff DF11(.q(pcCurrent[11]), .d(pc[11]), .clk(clk), .rst(rst));
    dff DF12(.q(pcCurrent[12]), .d(pc[12]), .clk(clk), .rst(rst));
    dff DF13(.q(pcCurrent[13]), .d(pc[13]), .clk(clk), .rst(rst));
    dff DF14(.q(pcCurrent[14]), .d(pc[14]), .clk(clk), .rst(rst));
    dff DF15(.q(pcCurrent[15]), .d(pc[15]), .clk(clk), .rst(rst));

    cla_16b CLA(.a(pcCurrent), .b(16'b0000_0000_0000_0010), .c_in(1'b0), 
            .sign(1'b0), .sum(pcOut), .ofl(err));

    assign enable = ~rst;  
    memory2c MEMI(.data_out(instr), .data_in(16'b0000_0000_0000_0000), .addr(pcCurrent), .enable(enable), 
            .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst)); 

endmodule

