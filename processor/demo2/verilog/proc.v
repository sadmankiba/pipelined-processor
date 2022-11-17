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
    
    wire [15:0] nxtPc, instr;
    wire validIns, fetchErr;

    wire [15:0] nxtPcIfId, instrIfId;
    wire [2:0] RsIfId, RtIfId;
    wire validInsIfId, RsValidIfId, RtValidIfId, writeRegValidIfId;

    wire regDst, jump, branch, MemRead, memToReg, MemWrite, aluSrc, RegWrite; 
    wire [4:0] aluOp;
    wire cntrlErr, halt, i1Fmt, zeroExt;

    wire errDcd;
    wire [15:0] readData1, readData2, immVal, jumpDist, nxtPcIdEx, 
        readData1IdEx, readData2IdEx, immValIdEx, jumpDistIdEx;
    wire [2:0] writeRegDcd, RsIdEx, RtIdEx, RdIdEx, writeRegIdEx;
    wire RsValid, RtValid, writeRegValid, RsValidIdEx, RtValidIdEx, writeRegValidIdEx;
    wire [4:0] aluOpIdEx;
    wire aluSrcIdEx, MemReadIdEx, MemWriteIdEx, branchIdEx, haltIdEx, memToRegIdEx,
        jumpIdEx, RegWriteIdEx; 
    wire [1:0] functIdEx;

    wire writePc, writeIfId, controlZero;

    wire [2:0] aluControl;
    wire invA, invB, sign, cIn;    
    
    wire zero, aluErr, ltz;
    wire [15:0] aluRes, brAddr, jumpDistOut;

    wire pcErr;
    wire [15:0] pcFinal, brPcAddr;

    wire [15:0] aluResExMem, readData1ExMem;
    wire [2:0] writeRegExMem, writeRegValidExMem;
    wire MemReadExMem, MemWriteExMem, HaltExMem, MemToRegExMem, RegWriteExMem, JumpExMem;

    wire [15:0] memData;

    wire [15:0] memDataMemWb, aluResMemWb;
    wire [2:0] writeRegMemWb, writeRegValidMemWb;
    wire MemToRegMemWb, RegWriteMemWb, MemReadMemWb;
    
    wire [15:0] writeDataWb;

    wire [1:0] forwardA,forwardB;

    fetch fetch0(/* input */ .lastPcOut(pcOut), .clk(clk), .rst(rst), .writePc(writePc),
        /* output */ .pcOut(pcOut), .instr(instr), .nxtPc(nxtPc), .validIns(validIns), .err(fetchErr));

    control_reg controlReg0(/*input*/ .opcode(instr[15:11]), 
        /* output */ .Rs(RsIfId), .Rt(RtIfId), .RsValid(RsValid), .RtValid(RtValid), .writeRegValid(writeRegValid));

    ifid_reg ifid0(/* input */ .clk(clk), .rst(rst), .pc_in(nxtPc), .instr_in(instr), .validInsIn(validIns), 
        .RsValidIn(RsValid), .RtValidIn(RtValid), .writeRegValidIn(writeRegValid),
        /* output */ .pc_out(nxtPcIfId), .instr_out(instrIfId), .validInsOut(validInsIfId)
        .RsValidOut(RsValidIfId), .RtValidOut(RtValidIfId), .writeRegValidOut(writeRegValidIfId));
    
    control control0(/* input */ .opcode(instrIfId[15:11]), .validIns(validInsIfId),
        /* output */ .regDst(regDst), .aluSrc(aluSrc),.aluOp(aluOp), 
        .branch(branch), .MemRead(MemRead), .MemWrite(MemWrite), .jump(jump), .memToReg(memToReg), .halt(halt),
        .RegWrite(RegWrite), .err(cntrlErr),.i1Fmt(i1Fmt), .zeroExt(zeroExt));

    hazard_detection_unit hazard0(/* input */ .MemReadIdEx(MemReadIdEx), 
        .writeRegIdEx(RtIdEx), .RsIfId(RsIfId), .RtIfId(RtIfId), 
        .writeRegValidIdEx(writeRegValidIdEx), .RsValidIfId(RsValidIfId), .RtValidIfId(RtValidIfId),
        /* output */ .writePc(writePc), .writeIfId(writeIfId), .controlZero(controlZero)
    );
    assign controlZero = 1'b0;

    decode decode0(/* input */ .instr(instrIfId), .regDst(regDst), .RegWrite(RegWriteMemWb),
        .writeReg(writeRegMemWb), .writeData(writeDataWb), .pc(nxtPcIfId), .i1Fmt(i1Fmt), .aluSrc(aluSrc), .zeroExt(zeroExt), 
        .jump(jump), .clk(clk), .rst(rst), 
        /* output */ .jumpDist(jumpDist), .readData1(readData1), .readData2(readData2), 
        .immVal(immVal), .writeRegOut(writeRegDcd), .err(errDcd));  

    

    idex_reg idex0 (/* input */
        .clk(clk), .rst(rst), .pc_in(nxtPcIfId), .read1_in(readData1), .read2_in(readData2), 
        .imm_in(immVal), .jumpaddr_in(jumpDist), .funct_in(instrIfId[1:0]), 
        .write_reg_in(writeRegDcd),
        .alu_op_in(aluOp), .alu_src_in(aluSrc), /* EX Control Inputs */
        .branch_in(branch), .mem_read_in(MemRead), .mem_write_in(MemWrite), .halt_in(halt), //MEM Control Inputs
        .mem_to_reg_in(memToReg), .reg_write_in(RegWrite), .jump_in(Jump), //WB Control Inputs
        .Rs_in(RsIfId), .Rt_in(RtIfId), .RsValidIn(RsValidIfId), .RtValidIn(RtValidIfId), .writeRegValidIn(writeRegValidIfId), 
        .controlZero(controlZero),
        /* output */
        .pc_out(nxtPcIdEx), .read1_out(readData1IdEx), .read2_out(readData2IdEx), 
        .imm_out(immValIdEx), .jumpaddr_out(jumpDistIdEx), .funct_out(functIdEx), 
        .write_reg_out(writeRegIdEx),
        //Control Outputs
        .alu_op_out(aluOpIdEx), .alu_src_out(aluSrcIdEx), 
        .branch_out(branchIdEx), .mem_read_out(MemReadIdEx), .mem_write_out(MemWriteIdEx),
        .halt_out(haltIdEx),
        .mem_to_reg_out(memToRegIdEx), .reg_write_out(RegWriteIdEx), .jump_out(jumpIdEx),
        //Register Outputs
        .Rs_out(RsIdEx), .Rt_out(RtIdEx),
        .RsValidOut(RsValidIdEx), .RtValidOut(RtValidIdEx), .writeRegValidOut(writeRegValidIdEx));
    
    alu_control actl0(/* input */ .aluOp(aluOpIdEx), .funct(functIdEx), 
        /* output */ .invA(invA), .invB(invB), .aluControl(aluControl), 
        .cIn(cIn), .sign(sign));

    forward_ex FWD(
        /* input */ .RsIdEx(RsIdEx), .RtIdEx(RtIdEx), 
        .writeRegExMem(RdExMem), .writeRegMemWb(RdMemWb),
        .RsValidIdEx(RsValidIdEx), .RtValidIdEx(RtValidIdEx),
        .writeRegValidExMem(writeRegValidExMem), .writeRegValidMemWb(writeRegValidMemWb),
        .RegWriteExMem(RegWriteExMem), .RegWriteMemWb(RegWriteMemWb), .MemReadExMem(MemReadExMem),
        .MemReadMemWb(MemReadMemWb),
        /* output */ .forwardA(forwardA), .forwardB(forwardB));
    
    execute exec0 (/* input */ .readData1(readData1IdEx), .readData2(readData2IdEx), .immVal(immValIdEx), 
        .aluControl(aluControl), .aluSrc(aluSrcIdEx), .invA(invA), .invB(invB), 
        .cIn(cIn), .sign(sign), .aluOp(aluOpIdEx), .MemWrite(MemWriteIdEx),
        .forwardA(forwardA), .forwardB(forwardB), .aluResExMem(aluResExMem), .aluResMemWb(aluResMemWb),
        .memDataMemWb(memDataMemWb),
        /* output */ .aluRes(aluRes), .zero(zero), .ltz(ltz), .err(aluErr));

    pc_control pcControl0(/*input */ .immVal(immValIdEx), .readData2(readData2IdEx), .zero(zero), .branch(branchIdEx), 
        .pc(nxtPcIdEx), .jumpDistIn(jumpDistIdEx), .ltz(ltz), .aluOp(aluOpIdEx), 
        /* output */ .pcFinal(pcFinal), .err(pcErr));  

    exmem_reg EX_MEM (/* input */
        .clk(clk), .rst(rst), .alu_result_in(aluRes), .readData1In(readData1IdEx),
        .write_reg_in(writeRegIdEx),
        //Control Inputs
        .mem_read_in(MemReadIdEx), .mem_write_in(MemWriteIdEx), .halt_in(haltIdEx),
        .mem_to_reg_in(memToRegIdEx), .reg_write_in(RegWriteIdEx), 
        .writeRegValidIn(writeRegValidIdEx),
        //Outputs
        .alu_result_out(aluResExMem), .readData1Out(readData1ExMem), .write_reg_out(writeRegExMem),
        //Control Outputs
        .mem_read_out(MemReadExMem), .mem_write_out(MemWriteExMem), .halt_out(HaltExMem),
        .mem_to_reg_out(MemToRegExMem), .reg_write_out(RegWriteExMem), 
        .writeRegValidOut(writeRegValidExMem));

    forward_mem fmem0(/* input */ .MemWriteExMem(MemWriteExMem), .MemReadMemWb(MemReadMemWb), 
        .writeRegExMem(writeRegExMem), .writeRegMemWb(writeRegMemWb),
        .writeRegValidExMem(writeRegValidExMem), .writeRegValidMemWb(writeRegValidMemWb),
        /* output */ .forwardC(forwardC));

    dmemory memory0(/* input */ .MemWrite(MemWriteExMem), .MemRead(MemReadExMem), .memAddr(aluResExMem), 
        .writeData(readData1ExMem), .forwardC(forwardC), .memDataMemWb(memDataMemWb),
        .halt(HaltExMem), .clk(clk), .rst(rst), 
        /* output */ .readData(memData));
    
    memwb_reg MEM_WB(/* input */
        .data_mem_in(memData), .alu_result_in(aluResExMem), .write_reg_in(writeRegExMem),
        //Control Inputs
        .mem_to_reg_in(MemToRegExMem), .reg_write_in(RegWriteExMem), .MemReadIn(MemReadExMem),
        .writeRegValidIn(writeRegValidExMem), .clk(clk), .rst(rst),
        //Outputs
        .data_mem_out(memDataMemWb), .alu_result_out(aluResMemWb), .write_reg_out(writeRegMemWb),
        //Control Outputs
        .mem_to_reg_out(MemToRegMemWb), .reg_write_out(RegWriteMemWb), .MemReadOut(MemReadMemWb),
        .writeRegValidOut(writeRegValidMemWb));

    wb wb0 (/* input */ .aluRes(aluResMemWb), .memData(memDataMemWb), .memToReg(MemToRegMemWb), 
        /* output */.writeData(writeDataWb)); 
    
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
