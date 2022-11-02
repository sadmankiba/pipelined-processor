/*
   CS/ECE 552 Spring '20
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
module wb(aluRes, memData, memToReg, brPcAddr, jumpDist, jump, writeData, pc);
    // TODO: Your code here
    input [15:0] aluRes;
    input [15:0] memData;
    input memToReg;            
    input [15:0] brPcAddr;
    input [15:0] jumpDist;
    input jump;                
    
    output [15:0] writeData;
    output [15:0] pc;          
    
    mux2_1_16b MXD(.InA(aluRes), .InB(memData), .S(memToReg), .Out(writeData));
    mux2_1_16b MXA(.InA(brPcAddr), .InB(jumpDist), .S(jump), .Out(pc));
    

endmodule

