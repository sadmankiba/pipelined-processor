module rf_bypass (
           // Outputs
           readData1, readData2, err,
           // Inputs
           clk, rst, read1RegSel, read2RegSel, writeRegSel, writedata, write
           );
  input clk, rst;
  input [2:0] read1RegSel;
  input [2:0] read2RegSel;
  input [2:0] writeRegSel;
  input [15:0] writedata;
  input        write;

  output [15:0] readData1;
  output [15:0] readData2;
  output        err;

	wire [15:0] readData1init, readData2init;

	assign readData1 = write && (read1RegSel == writeRegSel) ? writedata : readData1init;
	assign readData2 = write && (read2RegSel == writeRegSel) ? writedata : readData2init;

	rf REG(.readData1(readData1init), .readData2(readData2init), .err(err), .clk(clk), .rst(rst), .read1RegSel(read1RegSel), .read2RegSel(read2RegSel), .writeRegSel(writeRegSel), .writedata(writedata), .write(write));

endmodule
