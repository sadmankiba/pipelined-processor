/*
   CS/ECE 552 Spring '20
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
   
module execute(aluControl, ALUSrc, read1data, read2data, immVal, pc, invA, invB, cin, sign,
              passThroughA, passThroughB, aluOp, memWrite, jump_in, jump_out,
              aluRes, branch_result, zero, ltz, err);
    // TODO: Your code here
    input [2:0] aluControl;   
    input ALUSrc;         
    input [15:0] read1data;
    input [15:0] read2data;
    input [15:0] immVal;
    input [15:0] pc;       
    input invA, invB;      
    input cin;
    input sign;
    input passThroughA;
    input passThroughB;
    input [4:0] aluOp;
    input memWrite;
    input [15:0] jump_in;
    
    output [15:0] jump_out;
    output [15:0] aluRes; 
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
    wire [15:0] btr_result, aluRes_temp;
    
    wire [15:0] nRead1data, newRead1data;
    wire isRotateRight;
    wire [2:0] ror_or_aluControl;

    wire [15:0] nRead1, rotateVal;
    wire isRORI;

    wire [15:0] a_in;
    wire jalrInstr, jrInstr;

    assign isRORI = ((~aluOp[0]) & aluOp[1] & aluOp[2] & (~aluOp[3]) & aluOp[4]);

    mux2_1_16b RORI(.InB(immVal), .InA(read1data), .S(isRORI), .Out(rotateVal));
    inv NREAD1(.In(rotateVal), .sign(1'b1), .Out(nRead1data));
    assign nRead1 = nRead1data + 1;
    assign isRotateRight = ((~aluControl[0]) & aluControl[1] & (~aluControl[2]));  
    assign ror_or_aluControl = (isRotateRight) ? 3'b000 : aluControl;

    mux2_1_16b ROTATERIGHT(.InB(nRead1), .InA(read1data), .S(isRotateRight), .Out(newRead1data));

    assign isBTR = (aluOp[0] & (~aluOp[1]) & (~aluOp[2]) & aluOp[3] & aluOp[4]);
    assign btr_result = {read2data[0],read2data[1],read2data[2],read2data[3],read2data[4],read2data[5],read2data[6],
                        read2data[7], read2data[8],read2data[9],read2data[10],read2data[11],read2data[12],
                        read2data[13],read2data[14],read2data[15]}; 

    assign isSLBI = ((~aluOp[0]) & aluOp[1] & (~aluOp[2]) & (~aluOp[3]) & aluOp[4]);
    assign shiftBits_SLBI = read2data << 8;

    mux4_1_16b ALU_IN1(.InD(read2data), .InC(shiftBits_SLBI), .InB(read1data), .InA(read2data), .S({isSLBI, memWrite}), .Out(alu_in1));

    wire [15:0] alu_in2_temp;
    mux4_1_16b ALU_IN2(.InD(immVal), .InC(immVal), .InB(read2data), .InA(newRead1data), .S({ALUSrc,memWrite}), .Out(alu_in2_temp));

    wire isBranch;
    assign isBranch = ((~aluOp[4]) & aluOp[3] & aluOp[2]);
    mux2_1_16b ALU2_BRANCH (.InB(16'h0000), .InA(alu_in2_temp), .S(isBranch), .Out(alu_in2));
    alu ALU(
            .InA(alu_in1), .InB(alu_in2), .Cin(cin), .Oper(ror_or_aluControl), .invA(invA), .invB(invB), .sign(sign), 
            .Out(result), .Zero(zero), .Ofl(alu_ofl), .Ltz(ltz));

    mux4_1_16b RESULT(.InD(result), .InC(alu_in2), .InB(read1data), .InA(result), .S({passThroughB, passThroughA}), .Out(temp_result));

    assign seq = ((~aluOp[1]) & (~aluOp[0])) & zero;
    assign slt = ((~aluOp[1]) & aluOp[0]) & ltz;
    assign sle = (aluOp[1] & (~aluOp[0])) & (zero | ltz);
    assign sco = (aluOp[1] & aluOp[0]) & alu_ofl;
    
    assign isSetOP = ((aluOp[2] & aluOp[3]) & aluOp[4]);
    assign set_condition_result = (seq | slt | sle | sco) ? 16'h0001 : 16'h0000;
    
    mux2_1_16b SETRESULT(.InB(set_condition_result), .InA(temp_result), .S(isSetOP), .Out(aluRes_temp));
    mux2_1_16b BTRresult(.InB(btr_result), .InA(aluRes_temp), .S(isBTR), .Out(aluRes));

    
    cla_16b ADD(
        .a(pc), .b(immVal), .c_in(cin_for_branch), .sign(sign_branch), 
                .sum(branch_result), .ofl(branch_ofl));
    
    equal #(.INPUT_WIDTH(5)) EQ1(.in1(aluOp), .in2(5'b00111), .eq(jalrInstr));
    equal #(.INPUT_WIDTH(5)) EQ2(.in1(aluOp), .in2(5'b00101), .eq(jrInstr));

    mux2_1_16b AIN(.InB(read2data), .InA(pc), .S(jrInstr|jalrInstr), .Out(a_in));
    
    // Jump addr
    cla_16b CLAJ(.a(a_in), .b(jump_in), .c_in(1'b0), .sign(1'b1), .sum(jump_out), .ofl(jump_ofl));
    
    // Error bit
    assign err = (branch_ofl | alu_ofl) & (~(passThroughA | passThroughB));

endmodule
