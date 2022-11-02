module regFile (// Outputs
                read1Data, read2Data, err,
                // Inputs
                clk, rst, read1RegSel, read2RegSel, writeRegSel, writedata, writeEn
                );

	input        clk, rst;
	input [2:0]  read1RegSel;
	input [2:0]  read2RegSel;
	input [2:0]  writeRegSel;
	input [15:0] writedata;
	input        writeEn;

	output [15:0] read1Data;
	output [15:0] read2Data;
	output        err;

	/* YOUR CODE HERE */
	parameter REG_SIZE = 16;
	parameter NUM_REG = 8;

	wire [REG_SIZE - 1:0] read0, read1, read2, read3, read4, read5, read6, read7;
	wire [NUM_REG - 1:0] writeRegNum, write, wEnExt;

	decoder3_8 DCDW(.in(writeRegSel[2:0]), .out(writeRegNum[7:0]));	

    // sign_ext #(.INPUT_WIDTH(1), .OUTPUT_WIDTH(8)) SX (.in(writeEN), .out(wEnExt));
    // assign write = writeRegNum & wEnExt;
	assign write[0] = writeRegNum[0] & writeEn;
	assign write[1] = writeRegNum[1] & writeEn;
	assign write[2] = writeRegNum[2] & writeEn;
	assign write[3] = writeRegNum[3] & writeEn;
	assign write[4] = writeRegNum[4] & writeEn;
	assign write[5] = writeRegNum[5] & writeEn;
	assign write[6] = writeRegNum[6] & writeEn;
	assign write[7] = writeRegNum[7] & writeEn;

	register R0 (.writeData(writedata), .write(write[0]), .clk(clk), .rst(rst), .readReg(read0));
	register R1 (.writeData(writedata), .write(write[1]), .clk(clk), .rst(rst), .readReg(read1));
	register R2 (.writeData(writedata), .write(write[2]), .clk(clk), .rst(rst), .readReg(read2));
	register R3 (.writeData(writedata), .write(write[3]), .clk(clk), .rst(rst), .readReg(read3));
	register R4 (.writeData(writedata), .write(write[4]), .clk(clk), .rst(rst), .readReg(read4));
	register R5 (.writeData(writedata), .write(write[5]), .clk(clk), .rst(rst), .readReg(read5));
	register R6 (.writeData(writedata), .write(write[6]), .clk(clk), .rst(rst), .readReg(read6));
	register R7 (.writeData(writedata), .write(write[7]), .clk(clk), .rst(rst), .readReg(read7));

	mux8_1_16b MXR1(.InA(read0), .InB(read1), .InC(read2), .InD(read3), .InE(read4), 
        .InF(read5), .InG(read6), .InH(read7), .S(read1RegSel), .Out(read1Data));
	
    mux8_1_16b MXR2(.InA(read0), .InB(read1), .InC(read2), .InD(read3), .InE(read4), 
        .InF(read5), .InG(read6), .InH(read7), .S(read2RegSel), .Out(read2Data));
    
	assign err = 0;

endmodule
