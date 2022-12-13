/*
   CS/ECE 552 Spring '20
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/

module fetch(/*input */ writePc1, writePc2, brAddr, jumpAddr, branchTake, Jump, clk, rst, 
    /* output */ pcOut, nxtPc, instr, validIns, err);
    
    // TODO: Your code here
    input [15:0] brAddr, jumpAddr;
    input writePc1, writePc2;          // writePc1 = 0 on load-use hazard.
    input branchTake, Jump;
    input clk, rst;

    output [15:0] pcOut;    // PC to fetch instruction in this cycle
    output [15:0] nxtPc;    // PC + 2 
    output [15:0] instr;
    output validIns, err;

    wire [15:0] pcIn;       // PC for next cycle
    wire [15:0] brPcAddr, nxtOrLastPc;
    wire Done, Stall, CacheHit, memEn, ofErr, iMemErr;
    
    mux2_1_16b DN(.InB(nxtPc), .InA(pcOut), .S(writePc1 & writePc2 & Done), .Out(nxtOrLastPc));
    mux2_1_16b MXBT(.InB(brAddr), .InA(nxtOrLastPc), .S(branchTake), .Out(brPcAddr));
    mux2_1_16b MXA(.InB(jumpAddr), .InA(brPcAddr), .S(Jump), .Out(pcIn));

    dff DF [15:0] (.q(pcOut), .d(pcIn), .clk(clk), .rst(rst));

    cla_16b CLA(.a(pcOut), .b(16'b0000_0000_0000_0010), .c_in(1'b0), 
            .sign(1'b0), .sum(nxtPc), .ofl(ofErr));

    assign memEn = ~rst;  
    stallmem MEMI (.DataOut(instr), .Done(Done), .Stall(Stall), .CacheHit(CacheHit), .err(iMemErr), 
        .Addr(pcOut), .DataIn(16'b0000_0000_0000_0000), .Rd(memEn), .Wr(1'b0), 
        .createdump(1'b0), .clk(clk), .rst(rst));

    assign validIns = Done; 
    assign err = ofErr | iMemErr;

endmodule

