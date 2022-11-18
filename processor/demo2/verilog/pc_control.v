module pc_control(/* input */ immVal, zero, Branch, ltz, readData2, pc, jumpDistIn, AluOp
        /* output */ brAddr, jumpAddr, branchTake, err);
    input zero, Branch, ltz;           
    input [15:0] immVal, pc, readData2, jumpDistIn;
    input [4:0] AluOp;
    
    output [15:0] brAddr, jumpAddr;
    output branchTake, err;

    wire notZ, gez, brCond, ;
    wire brOfl, jrInstr, jalrInstr, jmpOfl;
    wire [15:0] pcOrJReg;
    wire [1:0] brOp;

    assign brOp = AluOp[1:0];

    // Calc Branch Addr
    cla_16b CLAB(.a(pc), .b(immVal), .c_in(1'b0), .sign(1'b0), .sum(brAddr), .ofl(brOfl));
    
    // Calculate Jump addr
    equal #(.INPUT_WIDTH(5)) EQ1(.in1(AluOp), .in2(5'b00111), .eq(jalrInstr));
    equal #(.INPUT_WIDTH(5)) EQ2(.in1(AluOp), .in2(5'b00101), .eq(jrInstr));
    mux2_1_16b MXJA(.InA(pc), .InB(readData2), .S(jrInstr|jalrInstr), .Out(pcOrJReg));
    cla_16b CLAJ(.a(pcOrJReg), .b(jumpDistIn), .c_in(1'b0), .sign(1'b1), 
            .sum(jumpAddr), .ofl(jmpOfl));

    // Choose between Branch, PC and Jump address
    assign gez = ~ltz;
    assign notZ = ~zero;
    mux4_1 MXB(.InA(zero), .InB(notZ), .InC(ltz), .InD(gez), .S(brOp), .Out(brCond));
    assign branchTake = Branch & brCond;

    assign err = brOfl | jmpOfl;
endmodule