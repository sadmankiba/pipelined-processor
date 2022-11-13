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
    wire [15:0] writeData, pcFinal, brPcAddr, memData;

    wire [15:0] nxtPc, instr, nxtPcIfId, instrIfId;
    wire fetchErr;

    wire regDst, jump, branch, memRead, memToReg, memWrite, aluSrc, regWrite; 
    wire [4:0] aluOp;
    wire cntrlErr, halt, i1Fmt, zeroExt;

    wire errDcd;
    wire [15:0] readData1, readData2, immVal, jumpDist, nxtPcIdEx, 
        readData1IdEx, readData2IdEx, immValIdEx, jumpDistIdEx;
    wire [2:0] Rs, Rt, Rd, writeReg, RsIdEx, RtIdEx, RdIdEx, writeRegIdEx;
    wire [4:0] aluOpIdEx;
    wire aluSrcIdEx, memReadIdEx, memWriteIdEx, branchIdEx, haltIdEx, memToRegIdEx,
        jumpIdEx, regWriteIdEx; 
    wire [1:0] functIdEx;

    wire [2:0] aluControl;
    wire invA, invB, sign, cIn;    
    
    wire zero, aluErr, ltz;
    wire [15:0] aluRes, brAddr, jumpDistOut;

    wire [15:0] aluResExMem, branch_result_from_ex_mem, jumpaddr_from_ex_mem, readData1ExMem, next_pc_from_ex_mem;
    wire [4:0] ALU_op_from_ex_mem;
    wire [2:0] writeRegExMem;
    wire zero_from_ex_mem, ltz_from_ex_mem, Branch_from_ex_mem, MemReadExMem, MemWriteExMem, HaltExMem, MemToRegExMem, RegWriteExMem, JumpExMem;
    wire [2:0] RsExMem, RtExMem, RdExMem;
    wire Rs_valid_ex_mem, Rt_valid_ex_mem, Rd_valid_ex_mem;

    //MEM_WB Outputs
    wire [15:0] data_mem_from_mem_wb, ALU_result_from_mem_wb;
    wire [2:0] writeRegMemWb;
    wire MemToRegMemWb, RegWrite_from_mem_wb;
    wire [2:0] RsMemWb, RtMemWb, RdMemWb;
    wire Rs_valid_mem_wb, Rt_valid_mem_wb, Rd_valid_mem_wb;

    //Reg control Outputs
    // wire [2:0] Rs, Rt, Rd;
    // wire Rs_valid, Rt_valid, Rd_valid;

    //Data forwarding unit Outputs
    wire [1:0] forwardA,forwardB;

    //Hazard Detection Outputs
    wire PCWrite, IF_ID_Write, controlZero;

    wire [15:0] read2out_ex;

    fetch fetch0(/* input */.pc(pcFinal), .clk(clk), .rst(rst), 
        /* output */ .instr(instr), .pcOut(nxtPc), .err(fetchErr));

    ifid_reg ifid0(/* input */ .clk(clk), .rst(rst), .pc_in(nxtPc), .instr_in(instr),  
        /* output */ .pc_out(nxtPcIfId), .instr_out(instrIfId));
    
    control control0(/* input */ .opcode(instrIfId[15:11]), 
        /* output */ .regDst(regDst), .aluSrc(aluSrc),.aluOp(aluOp), 
        .branch(branch), .memRead(memRead), .memWrite(memWrite), .jump(jump), .memToReg(memToReg), .halt(halt),
        .regWrite(regWrite), .err(cntrlErr),.i1Fmt(i1Fmt), .zeroExt(zeroExt));

    decode decode0(/* input */ .instr(instrIfId), .regDst(regDst), .regWrite(regWriteMemWb),
        .writeData(writeData), .pc(nxtPc), .i1Fmt(i1Fmt), .aluSrc(aluSrc), .zeroExt(zeroExt), 
        .jump(jump), .clk(clk), .rst(rst), 
        /* output */ .Rs(Rs), .Rt(Rt), .Rd(Rd), .jumpDist(jumpDist), .readData1(readData1), .readData2(readData2), 
        .immVal(immVal), .writeReg(writeReg), .err(errDcd));  

    idex_reg idex0 (/* input */
        .clk(clk), .rst(rst), .pc_in(nxtPcIfId), .read1_in(readData1), .read2_in(readData2), 
        .imm_in(immVal), .jumpaddr_in(jumpDist), .funct_in(instrIfId[1:0]), 
        .write_reg_in(writeReg),
        .alu_op_in(aluOp), .alu_src_in(aluSrc), /* EX Control Inputs */
        .branch_in(branch), .mem_read_in(memRead), .mem_write_in(memWrite), .halt_in(halt), //MEM Control Inputs
        .mem_to_reg_in(memToReg), .reg_write_in(RegWrite), .jump_in(Jump), //WB Control Inputs
        .Rs_in(Rs), .Rt_in(Rt), .Rd_in(Rd), //Register Inputs
        .controlZero(controlZero),
        /* output */
        .pc_out(nxtPcIdEx), .read1_out(readData1IdEx), .read2_out(readData2IdEx), 
        .imm_out(immValIdEx), .jumpaddr_out(jumpDistIdEx), .funct_out(functIdEx[1:0]), 
        .write_reg_out(writeRegIdEx),
        //Control Outputs
        .alu_op_out(aluOpIdEx), .alu_src_out(aluSrcIdEx), 
        .branch_out(branchIdEx), .mem_read_out(memReadIdEx), .mem_write_out(memWriteIdEx),
        .halt_out(haltIdEx),
        .mem_to_reg_out(memToRegIdEx), .reg_write_out(regWriteIdEx), .jump_out(jumpIdEx),
        //Register Outputs
        .Rs_out(RsIdEx), .Rt_out(RtIdEx), .Rd_out(RdIdEx));
    
    alu_control actl0(/* input */ .aluOp(aluOpIdEx), .funct(functIdEx), 
        /* output */ .invA(invA), .invB(invB), .aluControl(aluControl), 
        .cIn(cIn), .sign(sign));
    
    execute exec0 (/* input */ .readData1(readData1IdEx), .readData2(readData2IdEx), .immVal(immValIdEx), 
        .aluControl(aluControl), .aluSrc(aluSrcIdEx), .invA(invA), .invB(invB), 
        .cIn(cIn), .sign(sign), .aluOp(aluOpIdEx), .memWrite(memWriteIdEx), 
        /* output */ .aluRes(aluRes), .zero(zero), .ltz(ltz), .err(aluErr));

    pc_control pcControl0(/*input */ .immVal(immValIdEx), .readData2(readData2IdEx), .zero(zero), .branch(branchIdEx), 
        .pc(nxtPcIdEx), .jumpDistIn(jumpDistIdEx), .ltz(ltz), .aluOp(aluOpIdEx), 
        /* output */ .jumpDistOut(jumpDistOut), .brPcAddr(brPcAddr), .err(pcErr));  

    exmem_reg EX_MEM (/* input */
        .clk(clk), .rst(rst), .alu_result_in(aluRes), .readData1In(readData1IdEx),
        .alu_op_in(aluOpIdEx), .write_reg_in(writeRegIdEx),
        //Control Inputs
        .branch_in(branchIdEx), .mem_read_in(memReadIdEx), .mem_write_in(memWriteIdEx),
        .halt_in(haltIdEx),
        .mem_to_reg_in(memToRegIdEx), .reg_write_in(regWriteIdEx), .jump_in(jumpIdEx),
        //Register Inputs
        .Rs_in(RsIdEx), .Rt_in(RtIdEx), .Rd_in(RdIdEx),
        //Outputs
        .alu_result_out(aluResExMem), 
        .readData1Out(readData1ExMem), .alu_op_out(ALU_op_from_ex_mem), .write_reg_out(writeRegExMem),
        //Control Outputs
        .mem_read_out(MemReadExMem), .mem_write_out(MemWriteExMem),
        .halt_out(HaltExMem),
        .mem_to_reg_out(MemToRegExMem), .reg_write_out(RegWriteExMem), .jump_out(JumpExMem),
        //Register Outputs
        .Rs_out(RsExMem), .Rt_out(RtExMem), .Rd_out(RdExMem));

    dmemory memory0(/* input */ .memWrite(MemWriteExMem), .memRead(MemReadExMem), .aluRes(aluResExMem), 
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
        .Rs_out(RsMemWb), .Rt_out(RtMemWb), .Rd_out(RdMemWb), 
        );

    wb wb0 (/* input */ .aluRes(aluResMemWb), .memData(memDataMemWb), .memToReg(MemToRegMemWb), .brPcAddr(brPcAddr), 
        .jumpDist(jumpDistOut), .jump(jump), .writeData(writeData), 
        /* output */ .pc(pcFinal)); 
    
    data_forward_unit FWD(
        /* input */ .RsIdEx(RsIdEx), .RtIdEx(RtIdEx), .RsExMem(RsExMem),  
        .RdExMem(RdExMem), .RdMemWb(RdMemWb),
        .WriteReg_ex_mem(RegWriteExMem), .WriteReg_mem_wb(RegWrite_from_mem_wb),
        .MemRead_ex_mem(MemReadExMem),
        /* output */ .forwardA(forwardA), .forwardB(forwardB));

    hazard_detection_unit HZD(/* input */ .MemRead_id_ex(memReadIdEx), 
        .RtIdEx(RtIdEx), .Rs_if_id(Rs), .Rt_if_id(Rt),
        /* output */ .PCWrite(PCWrite), .IF_ID_Write(IF_ID_Write), .controlZero(controlZero)
        );

endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
