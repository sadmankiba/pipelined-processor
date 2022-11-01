/*
   CS/ECE 552 Spring '20
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
   
module execute(readData1, readData2, immVal, aluControl, aluSrc, pc, invA, invB, cin, sign,
              passThroughA, passThroughB, aluOp, memWrite, jumpAddrIn, jumpAddrOut,
              aluRes, brAddr, zero, ltz, err);
    // TODO: Your code here
    input [2:0] aluControl;   
    input aluSrc;         
    input [15:0] readData1;
    input [15:0] readData2;
    input [15:0] immVal;
    input [15:0] pc;       
    input invA, invB;      
    input cin;
    input sign;
    input passThroughA;
    input passThroughB;
    input [4:0] aluOp;
    input memWrite;
    input [15:0] jumpAddrIn;
    
    output [15:0] jumpAddrOut;
    output [15:0] aluRes; 
    output [15:0] brAddr; 
    output zero, err, ltz;

    wire [15:0] aluInp1, aluInp2, aluSrcInp2;
    wire [1:0] sll;         
    wire toShift;           
    wire cin_for_branch, sign_branch, isBranch, brOfl;        
    wire alu_ofl, jump_ofl;
    wire [15:0] aluOutput, temp_result;
    wire isSetOP;           
    wire seq, slt, sle, sco;
    wire [15:0] setInstrVal; 

    assign sll = 2'b01;
    assign toShift = 1'b1;
    assign cin_for_branch = 1'b0; 
    assign sign_branch = 1'b0;

    wire isSLBI;
    wire [15:0] slbiShftImm;

    wire isBTR;
    wire [15:0] btr_result, aluRes_temp;
    
    wire [15:0] nRead1data, newRead1data;
    wire isRotateRight;
    wire [2:0] ror_or_aluControl;

    wire [15:0] nRead1, rotateVal;
    wire isRORI;

    wire [15:0] a_in;
    wire jalrInstr, jrInstr;

    // Calc Rotate Right result
    equal #(.INPUT_WIDTH(5)) EQ5(.in1(aluOp), .in2(5'b10110), .eq(isRORI));
    mux2_1_16b MXRRI(.InA(readData1), .InB(immVal), .S(isRORI), .Out(rotateVal));
    inv NREAD1(.In(rotateVal), .sign(1'b1), .Out(nRead1data));
    assign nRead1 = nRead1data + 1;  
    equal #(.INPUT_WIDTH(3)) EQ9(.in1(aluControl[2:0]), .in2(3'b010), .eq(isRotateRight));
    mux2_1_16b ROTATERIGHT(.InB(nRead1), .InA(readData1), .S(isRotateRight), .Out(newRead1data)); 

    // Calc ALU inps and perform ALU
    equal #(.INPUT_WIDTH(5)) EQ11(.in1(aluOp), .in2(5'b10010), .eq(isSLBI));
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
            .Out(aluOutput), .Zero(zero), .Ofl(alu_ofl), .Ltz(ltz));

    mux4_1_16b MXR(.InA(aluOutput), .InB(readData1), .InC(aluInp2), .InD(aluOutput), 
        .S({passThroughB, passThroughA}), .Out(temp_result));

    // Whether use set Instr value
    assign seq = ((~aluOp[1]) & (~aluOp[0])) & zero;
    assign slt = ((~aluOp[1]) & aluOp[0]) & ltz;
    assign sle = (aluOp[1] & (~aluOp[0])) & (zero | ltz);
    assign sco = (aluOp[1] & aluOp[0]) & alu_ofl;
    equal #(.INPUT_WIDTH(3)) EQ15(.in1(aluOp[4:2]), .in2(3'b111), .eq(isSetOP));
    assign setInstrVal = (seq | slt | sle | sco) ? 16'h0001 : 16'h0000;
    mux2_1_16b MXST(.InB(setInstrVal), .InA(temp_result), .S(isSetOP), .Out(aluRes_temp));
    
    // Calc btr Instr result
    equal #(.INPUT_WIDTH(5)) EQ22(.in1(aluOp), .in2(5'b11001), .eq(isBTR));
    rev RV(.in(readData2), .out(btr_result));
    mux2_1_16b MXBT(.InA(aluRes_temp), .InB(btr_result), .S(isBTR), .Out(aluRes));    
    
    // Calc Branch Addr
    cla_16b CLAB(.a(pc), .b(immVal), .c_in(cin_for_branch), .sign(sign_branch), 
                .sum(brAddr), .ofl(brOfl));
    
    // Calculate Jump addr
    equal #(.INPUT_WIDTH(5)) EQ1(.in1(aluOp), .in2(5'b00111), .eq(jalrInstr));
    equal #(.INPUT_WIDTH(5)) EQ2(.in1(aluOp), .in2(5'b00101), .eq(jrInstr));
    mux2_1_16b AIN(.InB(readData2), .InA(pc), .S(jrInstr|jalrInstr), .Out(a_in));
    cla_16b CLAJ(.a(a_in), .b(jumpAddrIn), .c_in(1'b0), .sign(1'b1), .sum(jumpAddrOut), .ofl(jump_ofl));
    
    // Error bit
    assign err = (brOfl | alu_ofl) & (~(passThroughA | passThroughB));

endmodule
