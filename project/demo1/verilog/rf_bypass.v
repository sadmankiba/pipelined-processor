module rf_bypass (
           // Outputs
           read1data, read2data, err,
           // Inputs
           clk, rst, read1RegSel, read2RegSel, writeRegSel, writedata, write
           );
  input clk, rst;
  input [2:0] read1RegSel;
  input [2:0] read2RegSel;
  input [2:0] writeRegSel;
  input [15:0] writedata;
  input        write;

  output [15:0] read1data;
  output [15:0] read2data;
  output        err;

	wire [15:0] read1datainit, read2datainit;

	assign read1data = write && (read1RegSel == writeRegSel) ? writedata : read1datainit;
	assign read2data = write && (read2RegSel == writeRegSel) ? writedata : read2datainit;

	rf REG(.read1data(read1datainit), .read2data(read2datainit), .err(err), .clk(clk), .rst(rst), .read1RegSel(read1RegSel), .read2RegSel(read2RegSel), .writeRegSel(writeRegSel), .writedata(writedata), .write(write));

endmodule
