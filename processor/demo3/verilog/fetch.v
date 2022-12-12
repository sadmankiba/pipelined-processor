/*
   CS/ECE 552 Spring '20
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/

module fetch(/*input */ lastPcOut, clk, rst, writePc, brAddr, jumpAddr, branchTake, Jump,
    /* output */ pcOut, nxtPc, instr, validIns, err);
    
    // TODO: Your code here
    input [15:0] lastPcOut, brAddr, jumpAddr;
    input clk, rst, writePc, branchTake, Jump;

    output [15:0] pcOut, nxtPc, instr;
    output validIns, err;

    wire [15:0] pcIn, brPcAddr, pcFinal;
    wire memEn, ofErr, iMemErr;

    mux2_1_16b MXBT(.InA(nxtPc), .InB(brAddr), .S(branchTake), .Out(brPcAddr));
    mux2_1_16b MXA(.InA(brPcAddr), .InB(jumpAddr), .S(Jump), .Out(pcFinal));

    assign pcIn = writePc? pcFinal: lastPcOut;

    dff DF [15:0] (.q(pcOut), .d(pcIn), .clk(clk), .rst(rst));

    cla_16b CLA(.a(pcOut), .b(16'b0000_0000_0000_0010), .c_in(1'b0), 
            .sign(1'b0), .sum(nxtPc), .ofl(ofErr));

    assign memEn = ~rst;  
    memory2c_align MEMI(.data_out(instr), .data_in(16'b0000_0000_0000_0000), .addr(pcOut), .enable(memEn), 
            .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst), .err(iMemErr));

    assign validIns = 1'b1; 
    assign err = ofErr | iMemErr;

endmodule

