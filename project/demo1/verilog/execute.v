/*
   CS/ECE 552 Spring '20
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
   
module execute(readData1, readData2, immVal, aluControl, aluSrc, invA, invB, cin, sign,
             aluOp, memWrite, aluRes, zero, ltz, err);
    // TODO: Your code here
    input [2:0] aluControl;   
    input aluSrc;         
    input [15:0] readData1, readData2, immVal;       
    input invA, invB;      
    input cin, sign;
    input [4:0] aluOp;
    input memWrite;
    
    output [15:0] aluRes; 
    output zero, err, ltz;

    wire [15:0] aluInp1, aluInp2, aluSrcInp2;
    wire [1:0] sll;         
    wire toShift, isBranch, aluOvf;
    wire [15:0] aluOutput, temp_result;
    wire isSetOP, setVal;
    wire [15:0] setInstrVal; 

    assign sll = 2'b01;
    assign toShift = 1'b1; 
    
    wire isLbi, isSLBI;
    wire [15:0] slbiShftImm;

    wire isBTR;
    wire [15:0] btr_result, aluRes_temp;
    
    wire [15:0] nRead1data, newRead1data;
    wire isRotateRight;
    wire [3:0] rorShAmt;
    wire [2:0] ror_or_aluControl;

    wire [15:0] nRead1, rotateVal;
    wire isRori;

    // Calc Rotate Right result
    equal #(.INPUT_WIDTH(5)) EQ1(.in1(aluOp), .in2(5'b10110), .eq(isRori));
    mux2_1_16b MXRRI(.InA(readData1), .InB(immVal), .S(isRori), .Out(rotateVal));
    inv INVR(.In(rotateVal), .sign(1'b1), .Out(nRead1data));
    assign nRead1 = nRead1data + 1;  
    equal #(.INPUT_WIDTH(3)) EQ2(.in1(aluControl[2:0]), .in2(3'b010), .eq(isRotateRight));
    mux2_1_16b MXROR(.InA(readData1), .InB(nRead1), .S(isRotateRight), .Out(newRead1data)); 

    // New rotate right
    // assign rorShAmt = (isRori)? immVal[3:0] : readData2[3:0];
    // assign rorMux = { readData1[rorShAmt - 1: 0], { (16 - rorShAmt){1'b0} }};

    // Calc ALU inps and perform ALU
    equal #(.INPUT_WIDTH(5)) EQ3(.in1(aluOp), .in2(5'b10010), .eq(isSLBI));
    assign slbiShftImm = readData2 << 8;
    mux4_1_16b MXAL1(.InA(readData2), .InB(readData1), .InC(slbiShftImm), .InD(readData2),    
        .S({isSLBI, memWrite}), .Out(aluInp1));
    mux4_1_16b MXAL2(.InA(newRead1data), .InB(readData2), .InC(immVal), .InD(immVal), 
        .S({aluSrc, memWrite}), .Out(aluSrcInp2));
    equal #(.INPUT_WIDTH(3)) EQ10(.in1(aluOp[4:2]), .in2(3'b011), .eq(isBranch));
    mux2_1_16b MXALB(.InA(aluSrcInp2), .InB(16'h0000), .S(isBranch), .Out(aluInp2));
    assign ror_or_aluControl = (isRotateRight) ? 3'b000 : aluControl;
    
    alu ALU(.InA(aluInp1), .InB(aluInp2), .Cin(cin), .Oper(ror_or_aluControl), 
            .invA(invA), .invB(invB), .sign(sign), 
            .Out(aluOutput), .Zero(zero), .Ofl(aluOvf), .Ltz(ltz));
    equal #(.INPUT_WIDTH(5)) EQ33(.in1(aluOp), .in2(5'b11000), .eq(isLbi));
    mux2_1_16b MXR(.InA(aluOutput), .InB(aluInp2), 
        .S(isLbi), .Out(temp_result));

    // Whether use set Instr value
    equal #(.INPUT_WIDTH(3)) EQ27(.in1(aluOp[4:2]), .in2(3'b111), .eq(isSetOP));
    mux4_1 MXS(.InA(zero), .InB(ltz), .InC(zero | ltz), .InD(aluOvf), 
        .S(aluOp[1:0]), .Out(setVal));
    zero_ext #(.OUTPUT_WIDTH(16)) ZX(.in(setVal), .out(setInstrVal));

    mux2_1_16b MXST(.InB(setInstrVal), .InA(temp_result), .S(isSetOP), .Out(aluRes_temp));
    
    // Calc btr Instr result
    equal #(.INPUT_WIDTH(5)) EQ22(.in1(aluOp), .in2(5'b11001), .eq(isBTR));
    rev RV(.in(readData2), .out(btr_result));
    mux2_1_16b MXBT(.InA(aluRes_temp), .InB(btr_result), .S(isBTR), .Out(aluRes));    
    
    // Error bit
    assign err = aluOvf;

endmodule
