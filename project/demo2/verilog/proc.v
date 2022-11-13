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

    wire [15:0] aluResExMem, branch_result_from_ex_mem, jumpaddr_from_ex_mem, read2_from_ex_mem, next_pc_from_ex_mem;
    wire [4:0] ALU_op_from_ex_mem;
    wire [2:0] write_reg_from_ex_mem;
    wire zero_from_ex_mem, ltz_from_ex_mem, Branch_from_ex_mem, MemRead_from_ex_mem, MemWrite_from_ex_mem, halt_from_ex_mem, MemToReg_from_ex_mem, RegWrite_from_ex_mem, Jump_from_ex_mem;
    wire [2:0] Rs_ex_mem, Rt_ex_mem, Rd_ex_mem;
    wire Rs_valid_ex_mem, Rt_valid_ex_mem, Rd_valid_ex_mem;

    //Reg control Outputs
    // wire [2:0] Rs, Rt, Rd;
    // wire Rs_valid, Rt_valid, Rd_valid;

    //Data forwarding unit Outputs
    wire [1:0] forwardA,forwardB;

    //Hazard Detection Outputs
    wire PCWrite, IF_ID_Write, zero_control_signals;

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
        .zero_control_signals(zero_control_signals),
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
    
    execute exec0 (/* input */ .readData1(readData1), .readData2(readData2), .immVal(immVal), 
        .aluControl(aluControl), .aluSrc(aluSrc), .invA(invA), .invB(invB), 
        .cIn(cIn), .sign(sign), .aluOp(aluOpIdEx), .memWrite(memWrite), 
        /* output */ .aluRes(aluRes), .zero(zero), .ltz(ltz), .err(aluErr));

    pc_control pcControl0(/*input */ .immVal(immValIdEx), .readData2(readData2IdEx), .zero(zero), .branch(branchIdEx), 
        .pc(nxtPcIdEx), .jumpDistIn(jumpDistIdEx), .ltz(ltz), .aluOp(aluOpIdEx), 
        /* output */ .jumpDistOut(jumpDistOut), .brPcAddr(brPcAddr), .err(pcErr));  

    exmem_reg EX_MEM (/* input */
        .clk(clk), .rst(rst), .alu_result_in(aluRes), 
        .read2data_in(read2out_ex), .alu_op_in(aluOpIdEx), .write_reg_in(writeRegIdEx),
        //Control Inputs
        .branch_in(branchIdEx), .mem_read_in(memReadIdEx), .mem_write_in(memWriteIdEx),
        .halt_in(haltIdEx),
        .mem_to_reg_in(memToRegIdEx), .reg_write_in(regWriteIdEx), .jump_in(jumpIdEx),
        //Register Inputs
        .Rs_in(RsIdEx), .Rt_in(RtIdEx), .Rd_in(RdIdEx),
        //Outputs
        .alu_result_out(aluResExMem), 
        .read2data_out(read2_from_ex_mem), .alu_op_out(ALU_op_from_ex_mem), .write_reg_out(write_reg_from_ex_mem),
        //Control Outputs
        .mem_read_out(MemRead_from_ex_mem), .mem_write_out(MemWrite_from_ex_mem),
        .halt_out(halt_from_ex_mem),
        .mem_to_reg_out(MemToReg_from_ex_mem), .reg_write_out(RegWrite_from_ex_mem), .jump_out(Jump_from_ex_mem),
        //Register Outputs
        .Rs_out(Rs_ex_mem), .Rt_out(Rt_ex_mem), .Rd_out(Rd_ex_mem), 
        );

    dmemory memory0(/* input */ .memWrite(MemWrite_from_ex_mem), .memRead(MemRead_from_ex_mem), .aluRes(aluResExMem), .writedata(readData1), 
        .halt(halt), .clk(clk), .rst(rst), 
        /* output */ .readData(memData));  
    
    // MEM_WB flip flop
    memwb_reg MEM_WB(//Inputs
        .data_mem_in(data_mem_out), .alu_result_in(aluResExMem), .write_reg_in(write_reg_from_ex_mem),
        //Control Inputs
        .mem_to_reg_in(MemToReg_from_ex_mem), .reg_write_in(RegWrite_from_ex_mem), 
        .clk(clk), .rst(rst),
        //Register Inputs
        .Rs_in(Rs_ex_mem), .Rt_in(Rt_ex_mem), .Rd_in(Rd_ex_mem), 
        //Outputs
        .data_mem_out(data_mem_from_mem_wb), .alu_result_out(ALU_result_from_mem_wb), .write_reg_out(write_reg_from_mem_wb),
        //Control Outputs
        .mem_to_reg_out(MemToReg_from_mem_wb), .reg_write_out(regWriteMemWb),
        //Register Outputs
        .Rs_out(Rs_mem_wb), .Rs_valid_out(Rs_valid_mem_wb), .Rt_out(Rt_mem_wb), .Rt_valid_out(Rt_valid_mem_wb), 
        .Rd_out(Rd_mem_wb), .Rd_valid_out(Rd_valid_mem_wb)
        );

    wb wb0 (/* input */ .aluRes(aluRes), .memData(memData), .memToReg(memToReg), .brPcAddr(brPcAddr), 
                .jumpDist(jumpDistOut), .jump(jump), .writeData(writeData), 
            /* output */ .pc(pcFinal)); 
    
    // register control unit
    // register_control REG_CTL(.instruction(instruction_from_if_id), 
    //                        .Rs(Rs), .Rt(Rt), .Rd(Rd), 
    //                        .Rs_valid(Rs_valid), .Rt_valid(Rt_valid), .Rd_valid(Rd_valid));

  //DATA FORWARDING UNIT
  data_forward_unit FWD(
                    /* input */ .RsIdEx(RsIdEx), .Rs_valid_id_ex(Rs_valid_id_ex), .RtIdEx(RtIdEx), .Rt_valid_id_ex(Rt_valid_id_ex), 
                    .Rs_ex_mem(Rs_ex_mem), .Rs_valid_ex_mem(Rs_valid_ex_mem), //.Rt_ex_mem(Rt_ex_mem), .Rt_valid_ex_mem(Rt_ex_mem), 
                    .Rd_ex_mem(Rd_ex_mem), .Rd_valid_ex_mem(Rd_valid_ex_mem), .Rd_mem_wb(Rd_mem_wb), .Rd_valid_mem_wb(Rd_valid_mem_wb),
                    .WriteReg_ex_mem(RegWrite_from_ex_mem), .WriteReg_mem_wb(RegWrite_from_mem_wb),
                    .MemRead_ex_mem(MemRead_from_ex_mem),
                    /* output */ .forwardA(forwardA), .forwardB(forwardB));

  //HAZARD DETECTION UNIT
  hazard_detection_unit HZD(/* input */
                            .MemRead_id_ex(memReadIdEx), 
                            .RtIdEx(RtIdEx), .Rs_if_id(Rs), .Rt_if_id(Rt),
                            .Rt_valid_id_ex(Rt_valid_id_ex), .Rs_valid_if_id(Rs_valid), .Rt_valid_if_id(Rt_valid),
                            /* output */
                            .PCWrite(PCWrite), .IF_ID_Write(IF_ID_Write), .zero_control_signals(zero_control_signals)
                           );

endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
