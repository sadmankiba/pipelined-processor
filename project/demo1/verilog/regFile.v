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
	wire [NUM_REG - 1:0] write_sel, write_logic, wEnExt;

	decode3_8 WRITE(.in(writeRegSel[2:0]), .out(write_sel[7:0]));	

    // sign_ext #(.INPUT_WIDTH(1), .OUTPUT_WIDTH(8)) SX (.in(writeEN), .out(wEnExt));
    // assign write_logic = write_sel & wEnExt;
	assign write_logic[0] = write_sel[0] & writeEn;
	assign write_logic[1] = write_sel[1] & writeEn;
	assign write_logic[2] = write_sel[2] & writeEn;
	assign write_logic[3] = write_sel[3] & writeEn;
	assign write_logic[4] = write_sel[4] & writeEn;
	assign write_logic[5] = write_sel[5] & writeEn;
	assign write_logic[6] = write_sel[6] & writeEn;
	assign write_logic[7] = write_sel[7] & writeEn;

	
	eight_registers REGS(.clk(clk), .rst(rst), .write(write_logic[7:0]), .writedata(writedata[15:0]),
					.read0(read0), .read1(read1), .read2(read2), .read3(read3), .read4(read4), .read5(read5), .read6(read6), .read7(read7));	

	mux8_1_16b READ1(.InA(read0), .InB(read1), .InC(read2), .InD(read3), .InE(read4), 
        .InF(read5), .InG(read6), .InH(read7), .S(read1RegSel), .Out(read1Data));
	
    mux8_1_16b READ2(.InA(read0), .InB(read1), .InC(read2), .InD(read3), .InE(read4), 
        .InF(read5), .InG(read6), .InH(read7), .S(read2RegSel), .Out(read2Data));
    
	assign err = 0;

endmodule
