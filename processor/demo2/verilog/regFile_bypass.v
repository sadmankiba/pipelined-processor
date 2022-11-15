module regFile_bypass (/* input */ clk, rst, read1RegSel, read2RegSel, writeRegSel, writeData, writeEn,
           /* output */ read1Data, read2Data, err);
    input clk, rst;
    input [2:0] read1RegSel, read2RegSel, writeRegSel;
    input [15:0] writeData;
    input        writeEn;

    output [15:0] read1Data, read2Data;
    output        err;

	wire [15:0] read1DataInit, read2DataInit;

	assign read1Data = (writeEn && (read1RegSel == writeRegSel)) ? writeData : read1DataInit;
	assign read2Data = (writeEn && (read2RegSel == writeRegSel)) ? writeData : read2DataInit;

	regFile RF (/* input */ .clk(clk), .rst(rst), 
        .read1RegSel(read1RegSel), .read2RegSel(read2RegSel), .writeRegSel(writeRegSel), 
        .writeData(writeData), .writeEn(writeEn), 
        /*output */ .read1Data(read1DataInit), .read2Data(read2DataInit), .err(err));

endmodule
