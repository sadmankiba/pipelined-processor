/*
   CS/ECE 552 Spring '20
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/

module fetch(/*input */ writePc1, writePc2, brAddr, jumpAddr, branchTake, Jump, clk, rst, 
    /* output */ pcOut, nxtPc, instr, validIns, err);
    
    // TODO: Your code here
    input [15:0] brAddr, jumpAddr;
    input writePc1;         // writePc1 = 0 on load-use hazard
    input writePc2;         // writePc2 = 0 on data mem stall
    input branchTake, Jump;
    input clk, rst;

    output [15:0] pcOut;    // PC to fetch instruction in this cycle
    output [15:0] nxtPc;    // PC + 2 
    output [15:0] instr;
    output validIns;        // validIns = 0 on ins mem stall
    output err;

    wire [15:0] pcIn;       // PC for next cycle
    wire [15:0] brPcAddr, nxtOrLastPc;
    wire [15:0] brOrJAddr, brOrJAddrIn, brOrJAddrRead, brOrJAddrFinal;
    wire brOrJ, incPc, bjIn, bjRead, Done, Stall, PcWrite, CacheHit, 
        memEn, ofErr, iMemErr;
    
    // assign incPc = writePc1 & writePc2 & validIns;
    // mux2_1_16b DN(.InB(nxtPc), .InA(pcOut), .S(incPc), .Out(nxtOrLastPc));
    // mux2_1_16b MXBT(.InB(brAddr), .InA(nxtOrLastPc), .S(branchTake), .Out(brPcAddr));
    // mux2_1_16b MXA(.InB(jumpAddr), .InA(brPcAddr), .S(Jump), .Out(pcIn));

    // dff DF [15:0] (.q(pcOut), .d(pcIn), .clk(clk), .rst(rst));
    
    /* 
    Two registers to remember to branch/jump and branch/jump addr 
    when instruction memory completes read of an invalidated instruction.
    Two cases:
    1. Branch identified at same cycle as read done: 
        Ins is invalidated in IF/ID reg
    2. Branch identified at a cycle before read done:
        Ins got from cache is invalidated here in fetch
    */
    assign brOrJ = (branchTake | Jump);
    assign bjIn = (bjRead | brOrJ) & (~Done);
    dff BJ (.q(bjRead), .d(bjIn), .clk(clk), .rst(rst));

    mux2_1_16b BOJA (.InB(jumpAddr), .InA(brAddr), .S(Jump), .Out(brOrJAddr));
    reg_nb #(.REG_WIDTH(16)) BJA(.rdData(brOrJAddrRead), .wrData(brOrJAddr), 
        .wr((~bjRead)), .clk(clk), .rst(rst));
    assign brOrJAddrFinal = bjRead? brOrJAddrRead: brOrJAddr;

    mux2_1_16b BRT (.InB(brOrJAddrFinal), .InA(nxtPc), .S((brOrJ | bjRead)), .Out(pcIn));
    /* If fetching of ins i is done in a cycle, ins (i+1) is issued in next cycle */
    assign PcWrite = writePc1 & writePc2 & Done;
    reg_nb #(.REG_WIDTH(16)) PC (.rdData(pcOut), .wrData(pcIn), .wr(PcWrite), 
        .clk(clk), .rst(rst));

    cla_16b CLA(.a(pcOut), .b(16'b0000_0000_0000_0010), .c_in(1'b0), 
            .sign(1'b0), .sum(nxtPc), .ofl(ofErr));

    assign memEn = ~rst;  
    mem_system MEMI (.DataOut(instr), .Done(Done), .Stall(Stall), .CacheHit(CacheHit), .err(iMemErr), 
        .Addr(pcOut), .DataIn(16'b0000_0000_0000_0000), .Rd(memEn), .Wr(1'b0), 
        .createdump(1'b0), .clk(clk), .rst(rst));

    assign validIns = Done & (~bjRead);
    assign err = ofErr | iMemErr;

endmodule

