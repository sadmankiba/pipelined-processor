module pc_control(immVal, zero, branch, ltz, readData2, pc, jumpAddrIn, 
                    aluOp, jumpAddrOut, brPcAddr, err);
    input zero, branch, ltz;           
    input [15:0] immVal, pc, readData2, jumpAddrIn;
    input [4:0] aluOp;
    
    output [15:0] jumpAddrOut, brPcAddr;
    output err;

    wire notZ, gez, brCond, branchTake;
    wire brOfl, jrInstr, jalrInstr;
    wire [15:0] brAddr, pcOrJrImm;
    wire [1:0] branch_op;

    assign branch_op = aluOp[1:0];

    // Calc Branch Addr
    cla_16b CLAB(.a(pc), .b(immVal), .c_in(1'b0), .sign(1'b0), .sum(brAddr), .ofl(brOfl));
    
    // Calculate Jump addr
    equal #(.INPUT_WIDTH(5)) EQ1(.in1(aluOp), .in2(5'b00111), .eq(jalrInstr));
    equal #(.INPUT_WIDTH(5)) EQ2(.in1(aluOp), .in2(5'b00101), .eq(jrInstr));
    mux2_1_16b MXJA(.InA(pc), .InB(readData2), .S(jrInstr|jalrInstr), .Out(pcOrJrImm));
    cla_16b CLAJ(.a(pcOrJrImm), .b(jumpAddrIn), .c_in(1'b0), .sign(1'b1), 
            .sum(jumpAddrOut), .ofl(jump_ofl));

    // Choose between branch and PC address
    assign gez = ~ltz;
    assign notZ = ~zero;
    mux4_1 MXB(.InA(zero), .InB(notZ), .InC(ltz), .InD(gez), .S(branch_op), .Out(brCond));
    assign branchTake = branch & brCond;
    mux2_1_16b MXBT(.InA(pc), .InB(brAddr), .S(branchTake), .Out(brPcAddr));

    assign err = brOfl;
endmodule