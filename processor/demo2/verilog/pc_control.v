module pc_control(immVal, zero, branch, ltz, readData2, pc, jumpDistIn, 
                    aluOp, pcFinal, err);
    input zero, branch, ltz;           
    input [15:0] immVal, pc, readData2, jumpDistIn;
    input [4:0] aluOp;
    
    output [15:0] pcFinal;
    output err;

    wire notZ, gez, brCond, branchTake;
    wire brOfl, jrInstr, jalrInstr, jmpOfl;
    wire [15:0] brAddr, pcOrJReg, brPcAddr, jumpDistOut;
    wire [1:0] brOp;

    assign brOp = aluOp[1:0];

    // Calc Branch Addr
    cla_16b CLAB(.a(pc), .b(immVal), .c_in(1'b0), .sign(1'b0), .sum(brAddr), .ofl(brOfl));
    
    // Calculate Jump addr
    equal #(.INPUT_WIDTH(5)) EQ1(.in1(aluOp), .in2(5'b00111), .eq(jalrInstr));
    equal #(.INPUT_WIDTH(5)) EQ2(.in1(aluOp), .in2(5'b00101), .eq(jrInstr));
    mux2_1_16b MXJA(.InA(pc), .InB(readData2), .S(jrInstr|jalrInstr), .Out(pcOrJReg));
    cla_16b CLAJ(.a(pcOrJReg), .b(jumpDistIn), .c_in(1'b0), .sign(1'b1), 
            .sum(jumpDistOut), .ofl(jmpOfl));

    // Choose between branch, PC and Jump address
    assign gez = ~ltz;
    assign notZ = ~zero;
    mux4_1 MXB(.InA(zero), .InB(notZ), .InC(ltz), .InD(gez), .S(brOp), .Out(brCond));
    assign branchTake = branch & brCond;
    mux2_1_16b MXBT(.InA(pc), .InB(brAddr), .S(branchTake), .Out(brPcAddr));
    mux2_1_16b MXA(.InA(brPcAddr), .InB(jumpDistOut), .S(jump), .Out(pcFinal));

    assign err = brOfl | jmpOfl;
endmodule