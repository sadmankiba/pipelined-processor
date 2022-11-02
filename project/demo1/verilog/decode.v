/*
   CS/ECE 552 Spring '20
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
module decode(instr, writeData, regDst, regWrite, pc, zeroExt, memWrite, jump, aluSrc,
                i1Fmt, clk, rst, jumpDist, readData1, readData2, immVal, err);
   
    // TODO: Your code here
    /*
    Decode: From an instruction and control signals, determine rwo register
    values, immediate value and jump address. 
    */

    input [15:0] instr; 
    input [15:0] writeData;
    input regWrite, regDst; 
    input [15:0] pc;
    input zeroExt, memWrite, jump, aluSrc, i1Fmt;
    input clk, rst;

    output err;
    output [15:0] jumpDist;   // Jump distance for 4 jump instructions
    output [15:0] readData1;  // Rd in I1, Rt in R-format
    output [15:0] readData2;  // Rs in I1, I2, R-format
    output [15:0] immVal;

    wire [15:0] immI2, immI1, temp_immediate, immI2ZExt, immI1ZExt, immZExt;
    wire [2:0] writeRegRI2I1StuJl, writeRegRI2;
    wire [2:0] readReg1, readReg2, writeRegR;
    wire [2:0] stuReg, writeRegRI2I1, writeRegRI2I1Stu;
    wire [4:0] opcode;
    wire isStu;
    wire jalInstr, jalrInstr, jmpLnk, jrInstr, jmpRg;
    wire [15:0]writeDataFinal;
    wire [15:0] jumpDistJ, jumpDistJr;

    /*
    Formats:
    J-format: j, jal
        15..11. 10..0.
        5 bits [opc]. 11 bits [displc]
    I-format 1: addi, subi, xori, st, ld, stu
        15..11. 10..8.  7..5.  4..0.
        5 [opc]. 3 [Rs]. 3 [Rd]. 5 [Imm]
    I-format 2: beqz, bltz, jr, jalr
        15..11. 10..8.  7..0.
        5 [opc]. 3 [Rs]. 8 [Imm]
    R-format: add, sub, xor
        15..11. 10..8.  7..5.   4..2.    1..0.
        5 [opc]. 3 [Rs]. 3 [Rt]. 3 [Rd]. 2 [Ext]
    */

    assign opcode = instr[15:11];
    assign readReg1 = instr[10:8];    // Rs in I1, I2, R-format
    assign readReg2 = instr[7:5];     // Rd in I1, Rt in R-format
    assign writeRegR = instr[4:2];
    
    assign stuReg = readReg1;
    equal #(.INPUT_WIDTH(5)) EQ1(.in1(opcode), .in2(5'b10011), .eq(isStu));

    equal #(.INPUT_WIDTH(5)) EQ2(.in1(opcode), .in2(5'b00110), .eq(jalInstr));
    equal #(.INPUT_WIDTH(5)) EQ3(.in1(opcode), .in2(5'b00111), .eq(jalrInstr));
    equal #(.INPUT_WIDTH(5)) EQ4(.in1(opcode), .in2(5'b00101), .eq(jrInstr));
    assign jmpLnk = jalInstr | jalrInstr;
    assign jmpRg = jrInstr | jalrInstr;
    
    assign writeRegRI2 = (regDst) ? writeRegR: readReg1;            // R-format or I-format2 writeReg
    assign writeRegRI2I1 = (i1Fmt) ? readReg2 : writeRegRI2;         // If I-format1 writeReg
    assign writeRegRI2I1Stu = (isStu) ? stuReg : writeRegRI2I1;          // If STU writeReg
    assign writeRegRI2I1StuJl = (jmpLnk) ? 3'b111 : writeRegRI2I1Stu; 
    assign writeDataFinal = (jmpLnk) ? pc : writeData;
    
    regFile regFile0(.read1Data(readData1), .read2Data(readData2), .err(err),
            .clk(clk), .rst(rst), .read1RegSel(readReg2), .read2RegSel(readReg1), 
            .writeRegSel(writeRegRI2I1StuJl), .writedata(writeDataFinal), .writeEn(regWrite));
    
    sign_ext #(.INPUT_WIDTH(11), .OUTPUT_WIDTH(16)) SXJ1(.in(instr[10:0]), .out(jumpDistJ));
    sign_ext #(.INPUT_WIDTH(8), .OUTPUT_WIDTH(16)) SXJ2(.in(instr[7:0]), .out(jumpDistJr));
    
    mux2_1_16b MXJADR(.InA(jumpDistJ), .InB(jumpDistJr),  
        .S(jump & aluSrc), .Out(jumpDist));
    
    sign_ext #(.INPUT_WIDTH(8), .OUTPUT_WIDTH(16)) SXI1(.in(instr[7:0]), .out(immI2));
    sign_ext #(.INPUT_WIDTH(5), .OUTPUT_WIDTH(16)) SXI2(.in(instr[4:0]), .out(immI1));
    zero_extend5bit ZX1(.in(instr[4:0]), .out(immI1ZExt));
    zero_extend8bit Zx2(.in(instr[7:0]), .out(immI2ZExt));

    mux2_1_16b  MXIM(.InA(immI2), .InB(immI1), .S(i1Fmt), .Out(temp_immediate));
    mux2_1_16b MXZI2IM(.InA(immI2ZExt), .InB(immI1ZExt), .S(i1Fmt), .Out(immZExt));
    mux2_1_16b MXZIM(.InA(temp_immediate), .InB(immZExt), .S(zeroExt), .Out(immVal));
endmodule

