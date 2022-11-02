/* $Author: sinclair $ */
/* $LastChangedDate: 2020-02-09 17:03:45 -0600 (Sun, 09 Feb 2020) $ */
/* $Rev: 46 $ */
module proc (/*AUTOARG*/
    // Outputs
        err, 
    // Inputs
    clk, rst
    );

    input clk;
    input rst;

    output err;

    // None of the above lines can be modified

    // OR all the err ouputs for every sub-module and assign it as this
    // err output
    
    // As desribed in the homeworks, use the err signal to trap corner
    // cases that you think are illegal in your statemachines
    
    
    /* your code here -- should include instantiations of fetch, decode, execute, mem and wb modules */
    
    wire pcErr;
    wire [15:0] wb_out, wb_pc, brPcAddr, data_mem_out;

    wire [15:0] nxtPc, instr;
    wire fetch_err;

    wire regDst, jump, branch, MemRead, MemToReg, memWrite, aluSrc, regWrite; 
    wire [4:0] aluOp;
    wire control_err, halt, i1Fmt, zeroExt, alu_ofl;

    wire errDcd;
    wire [15:0] jumpAddr, readData1, readData2, immVal;
    
    wire zero, aluErr, ltz;
    wire [15:0] aluRes, brAddr, jumpAddrOut;
    
    wire [2:0] aluControl;
    wire invA, invB, sign, cin, passA, passB;

    
    fetch fetch0(.pc(wb_pc), .clk(clk), .rst(rst), .pcOut(nxtPc), .instr(instr), .err(fetch_err));
    
    control control0(.opcode(instr[15:11]), .regDst(regDst), .jump(jump), 
                .branch(branch), .memRead(MemRead), .memToReg(MemToReg), .halt(halt),
                .aluOp(aluOp), .memWrite(memWrite), .aluSrc(aluSrc), .regWrite(regWrite), .err(control_err),
                    .i1Fmt(i1Fmt), .zeroExt(zeroExt));

    decode decode0(.instr(instr), .writeData(wb_out), .regDst(regDst), .regWrite(regWrite),
                .pc(nxtPc), .zeroExt(zeroExt), .memWrite(memWrite), .i1Fmt(i1Fmt),
                .jump(jump), .aluSrc(aluSrc),
                .clk(clk), .rst(rst), .jumpAddr(jumpAddr), .readData1(readData1), .readData2(readData2), 
                .immVal(immVal),.err(errDcd));  
    
    alu_control actl0(.aluOp(aluOp), .funct(instr[1:0]), 
                    .invA(invA), .invB(invB), .aluControl(aluControl), 
                    .cin(cin), .sign(sign), .passA(passA), .passB(passB));
    
    execute exec0 (.readData1(readData1), .readData2(readData2), .immVal(immVal), 
            .aluControl(aluControl), .aluSrc(aluSrc), .pc(nxtPc), .invA(invA), .invB(invB), 
            .cin(cin), .sign(sign), .passThroughA(passA), .passThroughB(passB), .aluOp(aluOp), 
            .memWrite(memWrite), .aluRes(aluRes), .zero(zero), .ltz(ltz), .err(aluErr));  

    data_mem memory0(.memWrite(memWrite), .memRead(MemRead), .aluRes(aluRes), .writedata(readData2), 
                    .readData(data_mem_out), .halt(halt), .clk(clk), .rst(rst));  

    pc_control pcControl0(.immVal(immVal), .readData2(readData2), .zero(zero), .branch(branch), 
                .pc(nxtPc), .jumpAddrIn(jumpAddr), .ltz(ltz), .aluOp(aluOp), .jumpAddrOut(jumpAddrOut), 
                .brPcAddr(brPcAddr), .err(pcErr));

    wb wb0 (.aluRes(aluRes), .memData(data_mem_out), .memToReg(MemToReg), .brPcAddr(brPcAddr), 
                    .jumpAddr(jumpAddrOut), .jump(jump), .writeData(wb_out), .pc(wb_pc)); 
    
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
