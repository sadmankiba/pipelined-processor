module regFile_bypass (/* input */ clk, rst, read1RegSel, read2RegSel, writeRegSel, writeData, writeEn,
           /* output */ read1Data, read2Data, err
           );
    input clk, rst;
    input [2:0] read1RegSel;
    input [2:0] read2RegSel;
    input [2:0] writeRegSel;
    input [15:0] writeData;
    input        writeEn;

    output [15:0] read1Data;
    output [15:0] read2Data;
    output        err;

	wire [15:0] read1datainit, read2datainit;

	assign read1Data = writeEn && (read1RegSel == writeRegSel) ? writeData : read1datainit;
	assign read2Data = writeEn && (read2RegSel == writeRegSel) ? writeData : read2datainit;

	rf REG(.read1Data(read1datainit), .read2Data(read2datainit), .err(err), .clk(clk), .rst(rst), .read1RegSel(read1RegSel), .read2RegSel(read2RegSel), .writeRegSel(writeRegSel), .writeData(writeData), .writeEn(writeEn));

endmodule
