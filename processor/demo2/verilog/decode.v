/*
   CS/ECE 552 Spring '20
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
module decode(/* input */ instr, regDst, RegWrite, writeReg, writeData, pc, 
    i1Fmt, aluSrc, zeroExt, jump, clk, rst, 
    /* output */ Rs, Rt, Rd, jumpDist, readData1, readData2, immVal, writeRegOut, err);
   
    // TODO: Your code here
    /*
    Decode: From an instruction and control signals, determine rwo register
    values, immediate value and jump address. 
    */

    input [15:0] instr; 
    input regDst, RegWrite; 
    input [2:0] writeReg;
    input [15:0] writeData;
    input [15:0] pc;
    input i1Fmt, aluSrc, zeroExt, jump;
    input clk, rst;

    output [15:0] jumpDist;   // Jump distance for 4 jump instructions
    output [15:0] readData1;  // Rd in I1, Rt in R-format
    output [15:0] readData2;  // Rs in I1, I2, R-format
    output [15:0] immVal;
    output [2:0] writeRegOut, Rs, Rt, Rd;
    output err;

    wire [2:0] readReg1, readReg2, writeRegR;
    wire [4:0] opcode;
    wire [2:0] writeRegRI2I1StuJl, writeRegRI2;
    wire [2:0] writeRegRI2I1, writeRegRI2I1Stu;
    wire isStu, jalInstr, jalrInstr, jmpLnk, jrInstr;
    wire [15:0] writeDataFinal, jumpDistJ, jumpDistJr;
    wire [15:0] immI1, immI2, immSExt, immI2ZExt, immI1ZExt, immZExt;

    /*
    Formats:
    J-format: j, jal
        15..11. 10..0.
        5 bits [opc]. 11 bits [displc]
    I-format 1: addi, subi, xori, st, ld, stu
        15..11. 10..8.  7..5.  4..0.
        5 [opc]. 3 [Rs]. 3 [Rd]. 5 [Imm]
    I-format 2: beqz, bltz, lbi, slbi, jr, jalr
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
    assign Rs = readReg1;
    assign Rt = readReg2;
    assign Rd = writeRegR;
    
    assign writeRegRI2 = (regDst) ? writeRegR: readReg1;            // R-format or I-format2 writeReg
    assign writeRegRI2I1 = (i1Fmt) ? readReg2 : writeRegRI2;         // If I-format1 writeReg
    
    equal #(.INPUT_WIDTH(5)) EQ1(.in1(opcode), .in2(5'b10011), .eq(isStu));
    equal #(.INPUT_WIDTH(5)) EQ2(.in1(opcode), .in2(5'b00110), .eq(jalInstr));
    equal #(.INPUT_WIDTH(5)) EQ3(.in1(opcode), .in2(5'b00111), .eq(jalrInstr));
    assign jmpLnk = jalInstr | jalrInstr;
    
    assign writeRegRI2I1Stu = (isStu) ? readReg1 : writeRegRI2I1;          // If STU writeReg
    assign writeRegRI2I1StuJl = (jmpLnk) ? 3'b111 : writeRegRI2I1Stu; 
    assign writeRegOut = writeRegRI2I1StuJl;
    assign writeDataFinal = (jmpLnk) ? pc : writeData;
    
    regFile_bypass regFile0(.read1Data(readData1), .read2Data(readData2), .err(err),
            .clk(clk), .rst(rst), .read1RegSel(readReg2), .read2RegSel(readReg1), 
            .writeRegSel(writeReg), .writeData(writeData), .writeEn(RegWrite));
    
    sign_ext #(.INPUT_WIDTH(11), .OUTPUT_WIDTH(16)) SXJ1(.in(instr[10:0]), .out(jumpDistJ));
    sign_ext #(.INPUT_WIDTH(8), .OUTPUT_WIDTH(16)) SXJ2(.in(instr[7:0]), .out(jumpDistJr));
    mux2_1_16b MXJDR(.InA(jumpDistJ), .InB(jumpDistJr), .S(jump & aluSrc), .Out(jumpDist));
    
    sign_ext #(.INPUT_WIDTH(5), .OUTPUT_WIDTH(16)) SXI1(.in(instr[4:0]), .out(immI1));
    sign_ext #(.INPUT_WIDTH(8), .OUTPUT_WIDTH(16)) SXI2(.in(instr[7:0]), .out(immI2));
    zero_ext #(.INPUT_WIDTH(5), .OUTPUT_WIDTH(16)) ZXI1(.in(instr[4:0]), .out(immI1ZExt));
    zero_ext #(.INPUT_WIDTH(8), .OUTPUT_WIDTH(16)) ZXI2(.in(instr[7:0]), .out(immI2ZExt));

    mux2_1_16b MXS(.InA(immI2), .InB(immI1), .S(i1Fmt), .Out(immSExt));
    mux2_1_16b MXZ(.InA(immI2ZExt), .InB(immI1ZExt), .S(i1Fmt), .Out(immZExt));
    mux2_1_16b MXIM(.InA(immSExt), .InB(immZExt), .S(zeroExt), .Out(immVal));
endmodule

