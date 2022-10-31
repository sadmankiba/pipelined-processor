/*
   CS/ECE 552 Spring '20
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
module wb(mem_data, ALU_result, MemToReg, 
         jumpAddr, branch_or_pc, Jump, pc, out_data);
   // TODO: Your code here
  input [15:0] jumpAddr;
  input [15:0] branch_or_pc;
  input Jump;                //To jump or not. From control
  input [15:0] mem_data;
  input [15:0] ALU_result;
  input MemToReg;            //Memory result or alu result. From control

  output [15:0] pc;          //New PC. either jump, branch, or pc + 2
  output [15:0] out_data;    //Either mem_data or alu_result

  
  mux2_1_16b PC_MUX (.InB(jumpAddr), .InA(branch_or_pc), .S(Jump), .Out(pc));
  mux2_1_16b DATA_MUX(.InB(mem_data), .InA(ALU_result), .S(MemToReg), .Out(out_data));

endmodule

