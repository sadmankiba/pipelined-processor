/*
   CS/ECE 552 Spring '20
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
   
module execute(/* input */ readData1, readData2, immVal, aluControl, aluSrc, invA, invB, cIn, sign,
             aluOp, memWrite, forwardA, forwardB, aluResExMem, aluResMemWb, memDataMemWb
             /* output */ aluRes, zero, ltz, err);
    // TODO: Your code here
    input [2:0] aluControl;   
    input aluSrc;         
    input [15:0] readData1;   // Rd in I1, Rt in R-format
    input [15:0] readData2;   // Rs in I1, I2, R-format
    input [15:0] immVal;       
    input invA, invB;      
    input cIn, sign;
    input [4:0] aluOp;
    input memWrite;
    
    output [15:0] aluRes; 
    output zero, err, ltz;

    wire [15:0] aluInp1Pref, aluInp2Pref, aluInp1, aluInp2, aluSrcOut;       
    wire isBranch, aluOvf;
    wire [15:0] aluOutput, temp_result, aluOut;
    wire isSetOP, setVal;
    wire [15:0] setInstrVal; 
    
    wire isLbi, isSlbi;
    wire [15:0] slbiShftVal;

    wire isBtr;
    wire [15:0] btrOut, aluOutSet;
    
    // Handle alu input for slbi and lbi
    equal #(.INPUT_WIDTH(5)) EQ3(.in1(aluOp), .in2(5'b10010), .eq(isSlbi));
    equal #(.INPUT_WIDTH(5)) EQ33(.in1(aluOp), .in2(5'b11000), .eq(isLbi));
    assign slbiShftVal = readData2 << 8;
    mux4_1_16b MXSLB(.InA(readData2), .InB(slbiShftVal), .InC(16'h0000), .InD(readData2), // InD never 
            .S({isLbi, isSlbi}), .Out(aluInp1Pref));

    // Handle alu input for beqz, bnez, bltz, bgez
    mux2_1_16b MXALSRC(.InA(readData1), .InB(immVal), .S(aluSrc), .Out(aluSrcOut));
    equal #(.INPUT_WIDTH(3)) EQ10(.in1(aluOp[4:2]), .in2(3'b011), .eq(isBranch));
    mux2_1_16b MXALB(.InA(aluSrcOut), .InB(16'h0000), .S(isBranch), .Out(aluInp2Pref));

    // ALU 
    mux4_1_16b MXALI1(InA(aluInp1Pref), .InB(aluResMemWb), .InC(aluResExMem), .InD(memDataMemWb),  
            .S(forwardA), .Out(aluInp1));
    mux4_1_16b MXALI1(InA(aluInp2Pref), .InB(aluResMemWb), .InC(aluResExMem), .InD(memDataMemWb),  
            .S(forwardB), .Out(aluInp2));        
    alu ALU(.InA(aluInp1), .InB(aluInp2), .Cin(cIn), .Oper(aluControl), 
            .invA(invA), .invB(invB), 
            .sign(sign), .Out(aluOut), .Zero(zero), .Ofl(aluOvf), .Ltz(ltz));

    // Whether use set Instr value
    equal #(.INPUT_WIDTH(3)) EQ27(.in1(aluOp[4:2]), .in2(3'b111), .eq(isSetOP));
    mux4_1 MXS(.InA(zero), .InB(ltz), .InC(zero | ltz), .InD(aluOvf), 
        .S(aluOp[1:0]), .Out(setVal));
    zero_ext #(.OUTPUT_WIDTH(16)) ZX(.in(setVal), .out(setInstrVal));
    mux2_1_16b MXST(.InA(aluOut), .InB(setInstrVal), .S(isSetOP), .Out(aluOutSet));
    
    // Calc btr Instr result
    equal #(.INPUT_WIDTH(5)) EQ22(.in1(aluOp), .in2(5'b11001), .eq(isBtr));
    rev RV(.in(readData2), .out(btrOut));
    mux2_1_16b MXBT(.InA(aluOutSet), .InB(btrOut), .S(isBtr), .Out(aluRes));    
    
    // Error bit
    assign err = aluOvf;

endmodule
