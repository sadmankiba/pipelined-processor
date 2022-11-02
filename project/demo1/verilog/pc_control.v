module pc_control(zero, branch, ltz, branchAddr, pc, branch_op, brPcAddr);
    input zero, branch, ltz;           
    input [15:0] branchAddr, pc;
    input [1:0] branch_op;
    
    output [15:0] brPcAddr;

    wire notZ, gez, brCond, branchTake;

    assign gez = ~ltz;
    assign notZ = ~zero;

    mux4_1 MXB(.InA(zero), .InB(notZ), .InC(ltz), .InD(gez), .S(branch_op), .Out(brCond));

    assign branchTake = branch & brCond;
    mux2_1_16b MXBT(.InA(pc), .InB(branchAddr), .S(branchTake), .Out(brPcAddr));
endmodule