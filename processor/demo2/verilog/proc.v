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
    
    wire [15:0] nxtPc, instr, pcOut;
    wire [2:0] Rs, Rt;
    wire validIns, fetchErr;

    wire [15:0] nxtPcIfId, instrIfId;
    wire [2:0] RsIfId, RtIfId;
    wire validInsIfId, RsValidIfId, RtValidIfId, writeRegValidIfId;

    wire RegDst, Jump, Branch, MemRead, memToReg, MemWrite, AluSrc, RegWrite; 
    wire [4:0] AluOp;
    wire cntrlErr, halt, i1Fmt, zeroExt;

    wire errDcd;
    wire [15:0] readData1, readData2, immVal, jumpDist, nxtPcIdEx, 
        readData1IdEx, readData2IdEx, immValIdEx, jumpDistIdEx;
    wire [2:0] writeRegDcd, RsIdEx, RtIdEx, RdIdEx, writeRegIdEx;
    wire RsValid, RtValid, writeRegValid, RsValidIdEx, RtValidIdEx, writeRegValidIdEx;
    wire [4:0] AluOpIdEx;
    wire AluSrcIdEx, MemReadIdEx, MemWriteIdEx, BranchIdEx, haltIdEx, memToRegIdEx,
        JumpIdEx, RegWriteIdEx; 
    wire [1:0] functIdEx;

    wire writePc, writeIfId, controlZeroIdEx1;

    wire [2:0] aluControl;
    wire invA, invB, sign, cIn;    
    
    wire zero, aluErr, ltz;
    wire [15:0] aluRes, memWriteData, readData1f, brAddr, jumpAddr;

    wire branchTake, pcErr, flushIf, controlZeroIdEx2, controlZeroExMem;

    wire [15:0] aluResExMem, memWriteDataExMem, brAddrExMem, jumpAddrExMem;
    wire [2:0] writeRegExMem, RtExMem;
    wire MemReadExMem, MemWriteExMem, HaltExMem, MemToRegExMem, 
        RegWriteExMem, branchTakeExMem, JumpExMem, 
        writeRegValidExMem, RtValidExMem;

    wire [15:0] memData;

    wire [15:0] memDataMemWb, aluResMemWb;
    wire [2:0] writeRegMemWb;
    wire MemToRegMemWb, RegWriteMemWb, MemReadMemWb, writeRegValidMemWb;
    
    wire [15:0] writeDataWb;

    wire [1:0] forwardA,forwardB;

    fetch fetch0(/* input */ .lastPcOut(pcOut), .clk(clk), .rst(rst), .writePc(writePc), .brAddr(brAddrExMem), 
        .jumpAddr(jumpAddrExMem), .branchTake(branchTakeExMem), .Jump(JumpExMem),
        /* output */ .pcOut(pcOut), .instr(instr), .nxtPc(nxtPc), .validIns(validIns), .err(fetchErr));

    control_reg controlReg0(/*input*/ .instr(instr), 
        /* output */ .Rs(Rs), .Rt(Rt), .RsValid(RsValid), .RtValid(RtValid), .writeRegValid(writeRegValid));

    ifid_reg ifid0(/* input */ .lastPcOut(nxtPcIfId), .lastInstrOut(instrIfId), 
        .lastValidInsOut(validInsIfId), .lastRsValidOut(RsValidIfId), 
        .lastRtValidOut(RtValidIfId), .lastWriteRegValidOut(writeRegValidIfId), 
        .pcIn(nxtPc), .instrIn(instr), .RsIn(Rs), .RtIn(Rt), .validInsIn(validIns), 
        .RsValidIn(RsValid), .RtValidIn(RtValid), .writeRegValidIn(writeRegValid), .writeIfId(writeIfId),
        .flushIf(flushIf), .clk(clk), .rst(rst), 
        /* output */ .pcOut(nxtPcIfId), .instrOut(instrIfId), 
        .RsOut(RsIfId), .RtOut(RtIfId), .validInsOut(validInsIfId),
        .RsValidOut(RsValidIfId), .RtValidOut(RtValidIfId), .writeRegValidOut(writeRegValidIfId));
    
    control control0(/* input */ .opcode(instrIfId[15:11]), .validIns(validInsIfId),
        /* output */ .RegDst(RegDst), .AluSrc(AluSrc),.AluOp(AluOp), 
        .Branch(Branch), .MemRead(MemRead), .MemWrite(MemWrite), .Jump(Jump), .memToReg(memToReg), .halt(halt),
        .RegWrite(RegWrite), .err(cntrlErr),.i1Fmt(i1Fmt), .zeroExt(zeroExt));

    hazard_load hzdLoad0(/* input */ .MemReadIdEx(MemReadIdEx), 
        .writeRegIdEx(writeRegIdEx), .RsIfId(RsIfId), .RtIfId(RtIfId), 
        .writeRegValidIdEx(writeRegValidIdEx), .RsValidIfId(RsValidIfId), .RtValidIfId(RtValidIfId),
        /* output */ .writePc(writePc), .writeIfId(writeIfId), .controlZeroIdEx(controlZeroIdEx1)
    );

    decode decode0(/* input */ .instr(instrIfId), .RegDst(RegDst), .RegWrite(RegWriteMemWb),
        .writeReg(writeRegMemWb), .writeData(writeDataWb), .pc(nxtPcIfId), .i1Fmt(i1Fmt), 
        .AluSrc(AluSrc), .zeroExt(zeroExt), .Jump(Jump), .clk(clk), .rst(rst), 
        /* output */ .jumpDist(jumpDist), .readData1(readData1), .readData2(readData2), 
        .immVal(immVal), .writeRegOut(writeRegDcd), .err(errDcd));  

    idex_reg idex0 (/* input */
        .clk(clk), .rst(rst), .pcIn(nxtPcIfId), .read1_in(readData1), .read2_in(readData2), 
        .imm_in(immVal), .jumpDistIn(jumpDist), .funct_in(instrIfId[1:0]), 
        .writeRegIn(writeRegDcd),
        /* control */ .AluOpIn(AluOp), .AluSrcIn(AluSrc), 
        .BranchIn(Branch), .MemReadIn(MemRead), .MemWriteIn(MemWrite), .HaltIn(halt), 
        .MemToRegIn(memToReg), .RegWriteIn(RegWrite), .JumpIn(Jump), .controlZeroIdEx1(controlZeroIdEx1),
        .controlZeroIdEx2(controlZeroIdEx2),
        /* register */ .RsIn(RsIfId), .RtIn(RtIfId), .RsValidIn(RsValidIfId), .RtValidIn(RtValidIfId), 
        .writeRegValidIn(writeRegValidIfId), 
        /* output */ .pcOut(nxtPcIdEx), .read1_out(readData1IdEx), .read2_out(readData2IdEx), 
        .imm_out(immValIdEx), .jumpDistOut(jumpDistIdEx), .funct_out(functIdEx), 
        .writeRegOut(writeRegIdEx),
        /* control */ .AluOpOut(AluOpIdEx), .AluSrcOut(AluSrcIdEx), 
        .BranchOut(BranchIdEx), .MemReadOut(MemReadIdEx), .MemWriteOut(MemWriteIdEx),
        .HaltOut(haltIdEx), .MemToRegOut(memToRegIdEx), .RegWriteOut(RegWriteIdEx), .JumpOut(JumpIdEx),
        /* register */ .RsOut(RsIdEx), .RtOut(RtIdEx), .RsValidOut(RsValidIdEx), 
        .RtValidOut(RtValidIdEx), .writeRegValidOut(writeRegValidIdEx));
    
    alu_control actl0(/* input */ .AluOp(AluOpIdEx), .funct(functIdEx), 
        /* output */ .invA(invA), .invB(invB), .aluControl(aluControl), 
        .cIn(cIn), .sign(sign));

    forward_ex fex0(
        /* input */ .RsIdEx(RsIdEx), .RtIdEx(RtIdEx), .writeRegExMem(writeRegExMem), 
        .writeRegMemWb(writeRegMemWb), .RsValidIdEx(RsValidIdEx), .RtValidIdEx(RtValidIdEx),
        .writeRegValidExMem(writeRegValidExMem), .writeRegValidMemWb(writeRegValidMemWb),
        .RegWriteExMem(RegWriteExMem), .RegWriteMemWb(RegWriteMemWb), .MemReadExMem(MemReadExMem),
        .MemReadMemWb(MemReadMemWb),
        /* output */ .forwardA(forwardA), .forwardB(forwardB));
    
    execute exec0 (/* input */ .readData1(readData1IdEx), .readData2(readData2IdEx), .immVal(immValIdEx), 
        .aluControl(aluControl), .AluSrc(AluSrcIdEx), .invA(invA), .invB(invB), 
        .cIn(cIn), .sign(sign), .AluOp(AluOpIdEx), 
        .forwardA(forwardA), .forwardB(forwardB), .aluResExMem(aluResExMem), .aluResMemWb(aluResMemWb),
        .memDataMemWb(memDataMemWb), .pc(nxtPcIdEx),
        /* output */ .aluRes(aluRes), .memWriteData(memWriteData), .readData1f(readData1f),
            .zero(zero), .ltz(ltz), .err(aluErr));  

    pc_control pcControl0(/*input */ .immVal(immValIdEx), .readData1(readData1f), .zero(zero), .Branch(BranchIdEx), 
        .pc(nxtPcIdEx), .jumpDistIn(jumpDistIdEx), .ltz(ltz), .AluOp(AluOpIdEx), 
        /* output */ .brAddr(brAddr), .jumpAddr(jumpAddr), .branchTake(branchTake), .err(pcErr));

    hazard_pc hzdBr0(/*input*/ .branchTake(branchTakeExMem), .Jump(JumpExMem),
        /* output */ .flushIf(flushIf), .controlZeroIdEx(controlZeroIdEx2), .controlZeroExMem(controlZeroExMem));

    exmem_reg exmem0 (/* input */
        .aluResIn(aluRes), .memWriteDataIn(memWriteData),
        .RtIn(RtIdEx), .RtValidIn(RtValidIdEx), .writeRegIn(writeRegIdEx), .writeRegValidIn(writeRegValidIdEx), 
        .branchTakeIn(branchTake), .JumpIn(JumpIdEx),
        .brAddrIn(brAddr), .jumpAddrIn(jumpAddr), .clk(clk), .rst(rst), 
        //Control Inputs
        .MemReadIn(MemReadIdEx), .MemWriteIn(MemWriteIdEx), .HaltIn(haltIdEx),
        .MemToRegIn(memToRegIdEx), .RegWriteIn(RegWriteIdEx), 
        .controlZeroExMem(controlZeroExMem),
        //Outputs
        .aluResOut(aluResExMem), .memWriteDataOut(memWriteDataExMem), 
        .RtOut(RtExMem), .RtValidOut(RtValidExMem),
        .writeRegOut(writeRegExMem),
        .branchTakeOut(branchTakeExMem), .JumpOut(JumpExMem), .brAddrOut(brAddrExMem), .jumpAddrOut(jumpAddrExMem),
        //Control Outputs
        .MemReadOut(MemReadExMem), .MemWriteOut(MemWriteExMem), .HaltOut(HaltExMem),
        .MemToRegOut(MemToRegExMem), .RegWriteOut(RegWriteExMem), 
        .writeRegValidOut(writeRegValidExMem));
   
    forward_mem fmem0(/* input */ .MemWriteExMem(MemWriteExMem), .MemReadMemWb(MemReadMemWb), 
        .RtExMem(RtExMem), .writeRegMemWb(writeRegMemWb),
        .RtValidExMem(RtValidExMem), .writeRegValidMemWb(writeRegValidMemWb),
        /* output */ .forwardC(forwardC));

    dmemory memory0(/* input */ .MemWrite(MemWriteExMem), .MemRead(MemReadExMem), .memAddr(aluResExMem), 
        .writeData(memWriteDataExMem), .forwardC(forwardC), .memDataMemWb(memDataMemWb),
        .halt(HaltExMem), .clk(clk), .rst(rst), 
        /* output */ .readData(memData));
    
    memwb_reg memwb0(/* input */
        .data_mem_in(memData), .aluResIn(aluResExMem), .writeRegIn(writeRegExMem),
        //Control Inputs
        .MemToRegIn(MemToRegExMem), .RegWriteIn(RegWriteExMem), .MemReadIn(MemReadExMem),
        .writeRegValidIn(writeRegValidExMem), .clk(clk), .rst(rst),
        //Outputs
        .data_mem_out(memDataMemWb), .aluResOut(aluResMemWb), .writeRegOut(writeRegMemWb),
        //Control Outputs
        .MemToRegOut(MemToRegMemWb), .RegWriteOut(RegWriteMemWb), .MemReadOut(MemReadMemWb),
        .writeRegValidOut(writeRegValidMemWb));

    wb wb0 (/* input */ .aluRes(aluResMemWb), .memData(memDataMemWb), .memToReg(MemToRegMemWb), 
        /* output */.writeData(writeDataWb)); 
    
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
