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
    wire validInsIfId;

    wire regDst, jump, branch, MemRead, memToReg, memWrite, aluSrc, regWrite; 
    wire [4:0] aluOp;
    wire cntrlErr, halt, i1Fmt, zeroExt;

    wire errDcd;
    wire [15:0] readData1, readData2, immVal, jumpDist, nxtPcIdEx, 
        readData1IdEx, readData2IdEx, immValIdEx, jumpDistIdEx;
    wire [2:0] Rs, Rt, Rd, writeRegDcd, RsIdEx, RtIdEx, RdIdEx, writeRegIdEx;
    wire [4:0] aluOpIdEx;
    wire aluSrcIdEx, MemReadIdEx, memWriteIdEx, branchIdEx, haltIdEx, memToRegIdEx,
        jumpIdEx, regWriteIdEx; 
    wire [1:0] functIdEx;

    wire [2:0] aluControl;
    wire invA, invB, sign, cIn;    
    
    wire zero, aluErr, ltz;
    wire [15:0] aluRes, brAddr, jumpDistOut;

    wire pcErr;
    wire [15:0] pcFinal, brPcAddr;

    wire [15:0] aluResExMem, readData1ExMem;
    wire [2:0] writeRegExMem, RsExMem, RtExMem, RdExMem;
    wire MemReadExMem, MemWriteExMem, HaltExMem, MemToRegExMem, RegWriteExMem, JumpExMem;

    wire [15:0] memData;

    wire [15:0] memDataMemWb, aluResMemWb;
    wire [2:0] writeRegMemWb;
    wire MemToRegMemWb, regWriteMemWb;
    wire [2:0] RsMemWb, RtMemWb, RdMemWb;
    
    wire [15:0] writeDataWb;

    //Reg control Outputs
    // wire [2:0] Rs, Rt, Rd;
    // wire Rs_valid, Rt_valid, Rd_valid;

    wire [1:0] forwardA,forwardB;

    wire PCWrite, IF_ID_Write, controlZero;

    fetch fetch0(/* input */.pc(nxtPcIfId), .clk(clk), .rst(rst), 
        /* output */ .instr(instr), .pcOut(nxtPc), .validIns(validIns), .err(fetchErr));

    ifid_reg ifid0(/* input */ .clk(clk), .rst(rst), .pc_in(nxtPc), .instr_in(instr), .validInsIn(validIns), 
        /* output */ .pc_out(nxtPcIfId), .instr_out(instrIfId), .validInsOut(validInsIfId));
    
    control control0(/* input */ .opcode(instrIfId[15:11]), .validIns(validInsIfId),
        /* output */ .regDst(regDst), .aluSrc(aluSrc),.aluOp(aluOp), 
        .branch(branch), .MemRead(MemRead), .memWrite(memWrite), .jump(jump), .memToReg(memToReg), .halt(halt),
        .regWrite(regWrite), .err(cntrlErr),.i1Fmt(i1Fmt), .zeroExt(zeroExt));

    // hazard_detection_unit HZD(/* input */ .MemRead_id_ex(MemReadIdEx), 
    //     .RtIdEx(RtIdEx), .Rs_if_id(Rs), .Rt_if_id(Rt),
    //     /* output */ .PCWrite(PCWrite), .IF_ID_Write(IF_ID_Write), .controlZero(controlZero)
    //     );
    assign controlZero = 1'b0;

    decode decode0(/* input */ .instr(instrIfId), .regDst(regDst), .regWrite(regWriteMemWb),
        .writeReg(writeRegMemWb), .writeData(writeDataWb), .pc(nxtPcIfId), .i1Fmt(i1Fmt), .aluSrc(aluSrc), .zeroExt(zeroExt), 
        .jump(jump), .clk(clk), .rst(rst), 
        /* output */ .Rs(Rs), .Rt(Rt), .Rd(Rd), .jumpDist(jumpDist), .readData1(readData1), .readData2(readData2), 
        .immVal(immVal), .writeRegOut(writeRegDcd), .err(errDcd));  

    idex_reg idex0 (/* input */
        .clk(clk), .rst(rst), .pc_in(nxtPcIfId), .read1_in(readData1), .read2_in(readData2), 
        .imm_in(immVal), .jumpaddr_in(jumpDist), .funct_in(instrIfId[1:0]), 
        .write_reg_in(writeRegDcd),
        .alu_op_in(aluOp), .alu_src_in(aluSrc), /* EX Control Inputs */
        .branch_in(branch), .mem_read_in(MemRead), .mem_write_in(memWrite), .halt_in(halt), //MEM Control Inputs
        .mem_to_reg_in(memToReg), .reg_write_in(RegWrite), .jump_in(Jump), //WB Control Inputs
        .Rs_in(Rs), .Rt_in(Rt), .Rd_in(Rd), //Register Inputs
        .controlZero(controlZero),
        /* output */
        .pc_out(nxtPcIdEx), .read1_out(readData1IdEx), .read2_out(readData2IdEx), 
        .imm_out(immValIdEx), .jumpaddr_out(jumpDistIdEx), .funct_out(functIdEx), 
        .write_reg_out(writeRegIdEx),
        //Control Outputs
        .alu_op_out(aluOpIdEx), .alu_src_out(aluSrcIdEx), 
        .branch_out(branchIdEx), .mem_read_out(MemReadIdEx), .mem_write_out(memWriteIdEx),
        .halt_out(haltIdEx),
        .mem_to_reg_out(memToRegIdEx), .reg_write_out(regWriteIdEx), .jump_out(jumpIdEx),
        //Register Outputs
        .Rs_out(RsIdEx), .Rt_out(RtIdEx), .Rd_out(RdIdEx));
    
    alu_control actl0(/* input */ .aluOp(aluOpIdEx), .funct(functIdEx), 
        /* output */ .invA(invA), .invB(invB), .aluControl(aluControl), 
        .cIn(cIn), .sign(sign));

    // data_forward_unit FWD(
    //     /* input */ .RsIdEx(RsIdEx), .RtIdEx(RtIdEx), .RsExMem(RsExMem),  
    //     .RdExMem(RdExMem), .RdMemWb(RdMemWb),
    //     .WriteReg_ex_mem(RegWriteExMem), .WriteReg_mem_wb(RegWrite_from_mem_wb),
    //     .MemRead_ex_mem(MemReadExMem),
    //     /* output */ .forwardA(forwardA), .forwardB(forwardB));
    
    execute exec0 (/* input */ .readData1(readData1IdEx), .readData2(readData2IdEx), .immVal(immValIdEx), 
        .aluControl(aluControl), .aluSrc(aluSrcIdEx), .invA(invA), .invB(invB), 
        .cIn(cIn), .sign(sign), .aluOp(aluOpIdEx), .memWrite(memWriteIdEx), 
        /* output */ .aluRes(aluRes), .zero(zero), .ltz(ltz), .err(aluErr));

    pc_control pcControl0(/*input */ .immVal(immValIdEx), .readData2(readData2IdEx), .zero(zero), .branch(branchIdEx), 
        .pc(nxtPcIdEx), .jumpDistIn(jumpDistIdEx), .ltz(ltz), .aluOp(aluOpIdEx), 
        /* output */ .pcFinal(pcFinal), .err(pcErr));  

    exmem_reg EX_MEM (/* input */
        .clk(clk), .rst(rst), .alu_result_in(aluRes), .readData1In(readData1IdEx),
        .write_reg_in(writeRegIdEx),
        //Control Inputs
        .mem_read_in(MemReadIdEx), .mem_write_in(memWriteIdEx),
        .halt_in(haltIdEx),
        .mem_to_reg_in(memToRegIdEx), .reg_write_in(regWriteIdEx), 
        //Register Inputs
        .Rs_in(RsIdEx), .Rt_in(RtIdEx), .Rd_in(RdIdEx),
        //Outputs
        .alu_result_out(aluResExMem), .readData1Out(readData1ExMem), .write_reg_out(writeRegExMem),
        //Control Outputs
        .mem_read_out(MemReadExMem), .mem_write_out(MemWriteExMem),
        .halt_out(HaltExMem),
        .mem_to_reg_out(MemToRegExMem), .reg_write_out(RegWriteExMem), 
        //Register Outputs
        .Rs_out(RsExMem), .Rt_out(RtExMem), .Rd_out(RdExMem));

    dmemory memory0(/* input */ .memWrite(MemWriteExMem), .MemRead(MemReadExMem), .aluRes(aluResExMem), 
        .writedata(readData1ExMem), .halt(HaltExMem), .clk(clk), .rst(rst), 
        /* output */ .readData(memData));  
    
    memwb_reg MEM_WB(/* input */
        .data_mem_in(memData), .alu_result_in(aluResExMem), .write_reg_in(writeRegExMem),
        //Control Inputs
        .mem_to_reg_in(MemToRegExMem), .reg_write_in(RegWriteExMem), 
        .clk(clk), .rst(rst),
        //Register Inputs
        .Rs_in(RsExMem), .Rt_in(RtExMem), .Rd_in(RdExMem), 
        //Outputs
        .data_mem_out(memDataMemWb), .alu_result_out(aluResMemWb), .write_reg_out(writeRegMemWb),
        //Control Outputs
        .mem_to_reg_out(MemToRegMemWb), .reg_write_out(regWriteMemWb),
        //Register Outputs
        .Rs_out(RsMemWb), .Rt_out(RtMemWb), .Rd_out(RdMemWb));

    wb wb0 (/* input */ .aluRes(aluResMemWb), .memData(memDataMemWb), .memToReg(MemToRegMemWb), 
        /* output */.writeData(writeDataWb)); 
    
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
