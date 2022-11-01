module data_mem(memWrite, memRead, aluRes, writedata, zero, branch, ltz, branchAddr, pc, 
            halt, branch_op, clk, rst, branch_or_pc, readData);

    input memWrite, memRead;
    input [15:0] aluRes, writedata;
    input zero, branch, ltz;           
    input [15:0] branchAddr, pc;        
    input halt;
    input [1:0] branch_op;
    input clk, rst;

    output [15:0] branch_or_pc, readData;    

    wire notZ, gez, brCond, branchTake, breCond, brzCond;
    wire memEnable;

    wire [15:0] aluResult, writeData;

    assign gez = ~ltz;
    assign notZ = ~zero;
    assign memEnable = (~halt) & memRead;
    
    mux2_1 MXE(.InA(ltz), .InB(gez), .S(branch_op[0]), .Out(breCond));
    mux2_1 MXZ(.InA(zero), .InB(notZ), .S(branch_op[0]), .Out(brzCond));
    mux2_1 MXBC(.InA(brzCond), .InB(breCond), .S(branch_op[1]), .Out(brCond));
    
    assign branchTake = branch & brCond;
    mux2_1_16b MXBT(.InA(pc), .InB(branchAddr), .S(branchTake), .Out(branch_or_pc));
    
    mux2_1_16b MXAD(.InA(writedata), .InB(aluRes), .S(memRead), .Out(aluResult));
    mux2_1_16b MXW(.InA(aluRes), .InB(writedata), .S(memRead), .Out(writeData));

    memory2c MEMD(.data_out(readData), .data_in(writeData), .addr(aluResult), .enable(memEnable), 
            .wr(memWrite), .createdump(halt), .clk(clk), .rst(rst));  
endmodule
