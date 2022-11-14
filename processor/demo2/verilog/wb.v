/*
   CS/ECE 552 Spring '20
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
module wb(aluRes, memData, memToReg, writeData);
    // TODO: Your code here
    input [15:0] aluRes;
    input [15:0] memData;
    input memToReg;                 
    
    output [15:0] writeData;       
    
    mux2_1_16b MXD(.InA(aluRes), .InB(memData), .S(memToReg), .Out(writeData));
endmodule

