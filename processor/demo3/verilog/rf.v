module rf (clk, rst, read1RegSel, read2RegSel, writeRegSel, writeData, writeEn,
			read1Data, read2Data, err);
	input 			 clk;
		input 			 rst;
	input [2:0]  read1RegSel;
	input [2:0]  read2RegSel;
	input [2:0]  writeRegSel;
	input [15:0] writeData;
	input        writeEn;
	
	output [15:0] read1Data;
	output [15:0] read2Data;
	output        err;

	wire [15:0] read0, read1, read2, read3, read4, read5, read6, read7;
	wire [7:0] write_sel, write_logic;

	//If write, which one is selected
	decoder3_8 WRITE(.in(writeRegSel[2:0]), .out(write_sel[7:0]));	

	//Check if the input write signal is active
	assign write_logic[0] = write_sel[0] & writeEn;
	assign write_logic[1] = write_sel[1] & writeEn;
	assign write_logic[2] = write_sel[2] & writeEn;
	assign write_logic[3] = write_sel[3] & writeEn;
	assign write_logic[4] = write_sel[4] & writeEn;
	assign write_logic[5] = write_sel[5] & writeEn;
	assign write_logic[6] = write_sel[6] & writeEn;
	assign write_logic[7] = write_sel[7] & writeEn;

	//Pass writeData to all of the units. It will be ignored anyways if there is no write
	// eight_registers REGS(	.clk(clk), .rst(rst), .write(write_logic[7:0]), .writeData(writeData[15:0]),
	// 											.read0(read0), .read1(read1), .read2(read2), .read3(read3), .read4(read4), .read5(read5), .read6(read6), .read7(read7));	
	register R0 (.writeData(writeData), .write(write_logic[0]), .clk(clk), .rst(rst), .readReg(read0));
	register R1 (.writeData(writeData), .write(write_logic[1]), .clk(clk), .rst(rst), .readReg(read1));
	register R2 (.writeData(writeData), .write(write_logic[2]), .clk(clk), .rst(rst), .readReg(read2));
	register R3 (.writeData(writeData), .write(write_logic[3]), .clk(clk), .rst(rst), .readReg(read3));
	register R4 (.writeData(writeData), .write(write_logic[4]), .clk(clk), .rst(rst), .readReg(read4));
	register R5 (.writeData(writeData), .write(write_logic[5]), .clk(clk), .rst(rst), .readReg(read5));
	register R6 (.writeData(writeData), .write(write_logic[6]), .clk(clk), .rst(rst), .readReg(read6));
	register R7 (.writeData(writeData), .write(write_logic[7]), .clk(clk), .rst(rst), .readReg(read7));

	mux8_1_16b READ1(.InH(read7), .InG(read6), .InF(read5), .InE(read4), .InD(read3), .InC(read2), .InB(read1), .InA(read0), .S(read1RegSel[2:0]), .Out(read1Data[15:0]));
	mux8_1_16b READ2(.InH(read7), .InG(read6), .InF(read5), .InE(read4), .InD(read3), .InC(read2), .InB(read1), .InA(read0), .S(read2RegSel[2:0]), .Out(read2Data[15:0]));
	
	assign err = 0;

endmodule
