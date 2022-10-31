module data_mem(memWrite, memRead, ALU_result, writedata, readData, zero, Branch, branchAddr, pc, halt,
           branch_or_pc, ltz, branch_op, clk, rst);

  input zero;             //Used for branch logic
  input Branch;           //From control: if branch
  input [15:0] branchAddr;//Branch address
  input [15:0] pc;        //PC
  input memWrite;         //Write to memory or not. from control
  input [15:0] ALU_result;//ALU unit result
  input [15:0] writedata; //From instruction decode unit
  input memRead;          //Read from Mem or not. From control
  input clk, rst;
  input halt;
  input ltz;
  input [1:0] branch_op;

  output [15:0] branch_or_pc;//Result from MUX
  output [15:0] readData;    //From Memory unit

  wire nZero;
  wire memReadorWrite;
  wire isThereABranch, toBranch;
  wire lessThan_or_greatOrEqual, equalZ_or_notEqualZ;
  wire gez; //greater or equal to zero

  wire [15:0] aluResult, writeData;

  assign nZero = ~zero;
  assign memReadorWrite = (~halt) & memRead;
  assign gez = ~ltz; 
  //JUMP logic
  //Will want to do some sort of jump logic in here...
  
  //BRANCH logic
  mux2_1 LOW1(.InB(nZero), .InA(zero), .S(branch_op[0]), .Out(equalZ_or_notEqualZ));
  mux2_1 LOW2(.InB(gez), .InA(ltz), .S(branch_op[0]), .Out(lessThan_or_greatOrEqual));
  mux2_1 HIGH(.InB(lessThan_or_greatOrEqual), .InA(equalZ_or_notEqualZ), .S(branch_op[1]), .Out(isThereABranch));
  
  assign toBranch = Branch & isThereABranch;
  mux2_1_16b BMUX(.InB(branchAddr), .InA(pc), .S(toBranch), .Out(branch_or_pc));
  //

  mux2_1_16b STADDR(.InA(writedata), .InB(ALU_result), .S(memRead), .Out(aluResult));
  mux2_1_16b STIN(.InA(ALU_result), .InB(writedata), .S(memRead), .Out(writeData));

  //Data Memory
  memory2c DMEM(.data_out(readData), .data_in(writeData), .addr(aluResult), 
                .enable(memReadorWrite), .wr(memWrite), .createdump(halt), .clk(clk), .rst(rst));  

endmodule