/*
   CS/ECE 552 Spring '20
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
   
module execute(alu_op, ALUSrc, read1data, read2data, immediate, pc, invA, invB, cin, sign,
              passThroughA, passThroughB, instr_op, MemWrite, jump_in, jump_out,
              ALU_result, branch_result, zero, ltz, err);
   // TODO: Your code here
  input [2:0] alu_op;   
  input ALUSrc;         
  input [15:0] read1data;
  input [15:0] read2data;
  input [15:0] immediate;
  input [15:0] pc;       
  input invA, invB;      
  input cin;
  input sign;
  input passThroughA;
  input passThroughB;
  input [4:0] instr_op;
  input MemWrite;
  input [15:0] jump_in;
  
  output [15:0] jump_out;
  output [15:0] ALU_result; 
  output [15:0] branch_result; 
  output zero;
  output err;
  output ltz;

  wire [15:0] alu_in1, alu_in2;
  wire [1:0] sll;         
  wire toShift;           
  wire cin_for_branch;
  wire sign_branch;
  wire branch_ofl;        
  wire alu_ofl, jump_ofl;
  wire [15:0] result, temp_result;
  wire isSetOP;           
  wire seq, slt, sle, sco;
  wire [15:0] set_condition_result; 

  assign sll = 2'b01;
  assign toShift = 1'b1;
  assign cin_for_branch = 1'b0; 
  assign sign_branch = 1'b0;

  wire isSLBI;
  wire [15:0] shiftBits_SLBI;

  wire isBTR;
  wire [15:0] btr_result, ALU_result_temp;
  
  wire [15:0] nRead1data, newRead1data;
  wire isRotateRight;
  wire [2:0] ror_or_alu_op;

  wire [15:0] nRead1, rotateVal;
  wire isRORI;

  assign isRORI = ((~instr_op[0]) & instr_op[1] & instr_op[2] & (~instr_op[3]) & instr_op[4]);

  mux2_1_16b RORI(.InB(immediate), .InA(read1data), .S(isRORI), .Out(rotateVal));
  inv NREAD1(.In(rotateVal), .sign(1'b1), .Out(nRead1data));
  assign nRead1 = nRead1data + 1;
  assign isRotateRight = ((~alu_op[0]) & alu_op[1] & (~alu_op[2]));  
  assign ror_or_alu_op = (isRotateRight) ? 3'b000 : alu_op;

  mux2_1_16b ROTATERIGHT(.InB(nRead1), .InA(read1data), .S(isRotateRight), .Out(newRead1data));

  assign isBTR = (instr_op[0] & (~instr_op[1]) & (~instr_op[2]) & instr_op[3] & instr_op[4]);
  assign btr_result = {read2data[0],read2data[1],read2data[2],read2data[3],read2data[4],read2data[5],read2data[6],
                       read2data[7], read2data[8],read2data[9],read2data[10],read2data[11],read2data[12],
                       read2data[13],read2data[14],read2data[15]}; 

  assign isSLBI = ((~instr_op[0]) & instr_op[1] & (~instr_op[2]) & (~instr_op[3]) & instr_op[4]);
  assign shiftBits_SLBI = read2data << 8;

  mux4_1_16b ALU_IN1(.InD(read2data), .InC(shiftBits_SLBI), .InB(read1data), .InA(read2data), .S({isSLBI, MemWrite}), .Out(alu_in1));

  wire [15:0] alu_in2_temp;
  mux4_1_16b ALU_IN2(.InD(immediate), .InC(immediate), .InB(read2data), .InA(newRead1data), .S({ALUSrc,MemWrite}), .Out(alu_in2_temp));

  wire isBranch;
  assign isBranch = ((~instr_op[4]) & instr_op[3] & instr_op[2]);
  mux2_1_16b ALU2_BRANCH (.InB(16'h0000), .InA(alu_in2_temp), .S(isBranch), .Out(alu_in2));
  alu ALU(
          .InA(alu_in1), .InB(alu_in2), .Cin(cin), .Oper(ror_or_alu_op), .invA(invA), .invB(invB), .sign(sign), 
          .Out(result), .Zero(zero), .Ofl(alu_ofl), .Ltz(ltz));

  mux4_1_16b RESULT(.InD(result), .InC(alu_in2), .InB(read1data), .InA(result), .S({passThroughB, passThroughA}), .Out(temp_result));

  assign seq = ((~instr_op[1]) & (~instr_op[0])) & zero;
  assign slt = ((~instr_op[1]) & instr_op[0]) & ltz;
  assign sle = (instr_op[1] & (~instr_op[0])) & (zero | ltz);
  assign sco = (instr_op[1] & instr_op[0]) & alu_ofl;
  
  assign isSetOP = ((instr_op[2] & instr_op[3]) & instr_op[4]);
  assign set_condition_result = (seq | slt | sle | sco) ? 16'h0001 : 16'h0000;
  
  mux2_1_16b SETRESULT(.InB(set_condition_result), .InA(temp_result), .S(isSetOP), .Out(ALU_result_temp));
  mux2_1_16b BTRresult(.InB(btr_result), .InA(ALU_result_temp), .S(isBTR), .Out(ALU_result));

  
  cla_16b ADD(
      .a(pc), .b(immediate), .c_in(cin_for_branch), .sign(sign_branch), 
              .sum(branch_result), .ofl(branch_ofl));
  
  wire [15:0] a_in;
  wire jalr, jr, any_jump;
  assign jalr = (~instr_op[4]) & (~instr_op[3]) & instr_op[2] & instr_op[1] & instr_op[0];
  assign jr = (~instr_op[4]) & (~instr_op[3]) & instr_op[2] & (~instr_op[1]) & (instr_op[0]);
  assign any_jump = jalr | jr;
  mux2_1_16b AIN(.InB(read2data), .InA(pc), .S(jr|jalr), .Out(a_in));
  cla_16b JUMP(.a(a_in), .b(jump_in), .c_in(1'b0), .sign(1'b1), .sum(jump_out), .ofl(jump_ofl));

  assign err = (branch_ofl | alu_ofl) & (~(passThroughA | passThroughB));

endmodule
