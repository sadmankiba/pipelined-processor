/*
   CS/ECE 552 Spring '20
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/

module fetch(/*input */ pc, clk, rst, writePc, 
        /* output */ pcOut, instr, validIns, err);
    // TODO: Your code here
    input [15:0] pc;
    input clk, rst;

    output [15:0] pcOut, instr;
    output validIns, err;

    wire [15:0] pcCurrent;  
    wire memEn;

    dff DF [15:0] (.q(pcCurrent),  .d(pc),  .clk(clk), .rst(rst));

    cla_16b CLA(.a(pcCurrent), .b(16'b0000_0000_0000_0010), .c_in(1'b0), 
            .sign(1'b0), .sum(pcOut), .ofl(err));

    assign memEn = ~rst;  
    memory2c MEMI(.data_out(instr), .data_in(16'b0000_0000_0000_0000), .addr(pcCurrent), .enable(memEn), 
            .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));

    assign validIns = 1'b1; 

endmodule

