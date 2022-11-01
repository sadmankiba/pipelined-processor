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
    
    wire [15:0] wb_out, wb_pc, branch_or_pc, data_mem_out;

    wire [15:0] next_pc, instr;
    wire fetch_err;

    wire regDst, jump, branch, MemRead, MemToReg, memWrite, ALU_Src, regWrite; 
    wire [4:0] aluOp;
    wire control_err, halt, i1Fmt, zeroExt, alu_ofl;

    wire errDcd;
    wire [15:0] jumpAddr, read1data, read2data, immVal;
    
    wire zero, alu_err, ltz;
    wire [15:0] aluRes, branch_result, jump_out;
    
    wire [2:0] aluControl;
    wire invA, invB, sign, cin, passA, passB;

    
    fetch fetch0(.pc(wb_pc), .clk(clk), .rst(rst), .pcOut(next_pc), .instr(instr), .err(fetch_err));
    
    control control0(.opcode(instr[15:11]), .regDst(regDst), .jump(jump), 
                .branch(branch), .memRead(MemRead), .memToReg(MemToReg), .halt(halt),
                .aluOp(aluOp), .memWrite(memWrite), .aluSrc(ALU_Src), .regWrite(regWrite), .err(control_err),
                    .i1Fmt(i1Fmt), .zeroExt(zeroExt));

    decode decode0(.instr(instr), .writeData(wb_out), .regDst(regDst), .regWrite(regWrite),
                .pc(next_pc[15:0]), .zeroExt(zeroExt), .memWrite(memWrite), .i1Fmt(i1Fmt), 
                .clk(clk), .rst(rst), .jumpAddr(jumpAddr), .read1data(read1data), .read2data(read2data), 
                .immVal(immVal),.err(errDcd));  
    
    alu_control actl0(.aluOp(aluOp), .funct(instr[1:0]), 
                    .invA(invA), .invB(invB), .aluControl(aluControl), 
                    .cin(cin), .sign(sign), .passA(passA), .passB(passB));

    execute exec0 (.aluControl(aluControl), .ALUSrc(ALU_Src), .read1data(read1data), .read2data(read2data), 
            .immVal(immVal), .pc(next_pc), .invA(invA), .invB(invB), .cin(cin), .sign(sign),  
            .passThroughA(passA), .passThroughB(passB), .aluOp(aluOp), .memWrite(memWrite),
            .jump_in(jumpAddr), .aluRes(aluRes), .branch_result(branch_result), .zero(zero), .err(alu_err),
            .ltz(ltz), .jump_out(jump_out));  
    
    data_mem memory0(.memWrite(memWrite), .memRead(MemRead), .aluRes(aluRes), .writedata(read2data), 
                    .readData(data_mem_out), .zero(zero), .branch(branch), .branchAddr(branch_result), .pc(next_pc), 
                    .halt(halt), .ltz(ltz), .branch_op(aluOp[1:0]), .branch_or_pc(branch_or_pc), .clk(clk), .rst(rst));  

    wb wb0 (.aluRes(aluRes), .memData(data_mem_out), .memToReg(MemToReg), .brPcAddr(branch_or_pc), 
                    .jumpAddr(jump_out), .jump(jump), .writeData(wb_out), .pc(wb_pc)); 
    
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
