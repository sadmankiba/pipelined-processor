/*
   CS/ECE 552, Fall '22
   Homework #3, Problem #1
  
   This module creates a 16-bit register.  It has 1 write port, 2 read
   ports, 3 register select inputs, a write enable, a reset, and a clock
   input.  All register state changes occur on the rising edge of the
   clock. 
*/
module regFile (
                // Outputs
                read1Data, read2Data, err,
                // Inputs
                clk, rst, read1RegSel, read2RegSel, writeRegSel, writeData, writeEn
                );

   input        clk, rst;
   input [2:0]  read1RegSel;
   input [2:0]  read2RegSel;
   input [2:0]  writeRegSel;
   input [15:0] writeData;
   input        writeEn;

   output [15:0] read1Data;
   output [15:0] read2Data;
   output        err;

   /* YOUR CODE HERE */
   parameter REG_SIZE = 16;
   parameter NUM_REG = 8;

   wire [REG_SIZE * NUM_REG - 1:0] rgrd;
   wire [NUM_REG - 1:0] write;
   
   // Write
   decoder3_8 DC(.in(writeRegSel), .out(write));
   assign write[0] = write[0] & writeEn;
	assign write[1] = write[1] & writeEn;
	assign write[2] = write[2] & writeEn;
	assign write[3] = write[3] & writeEn;
	assign write[4] = write[4] & writeEn;
	assign write[5] = write[5] & writeEn;
	assign write[6] = write[6] & writeEn;
	assign write[7] = write[7] & writeEn;

   reg_16b RG0(.write(write), .writeData(writeData), .readData(rgrd[REG_SIZE * 1 - 1:0]), .clk(clk), .rst(rst));
   reg_16b RG1(.write(write), .writeData(writeData), .readData(rgrd[REG_SIZE * 2 - 1:REG_SIZE * 1]), .clk(clk), .rst(rst));
   reg_16b RG2(.write(write), .writeData(writeData), .readData(rgrd[REG_SIZE * 1 - 1:0]), .clk(clk), .rst(rst));
   reg_16b RG3(.write(write), .writeData(writeData), .readData(rgrd[REG_SIZE * 1 - 1:0]), .clk(clk), .rst(rst));
   reg_16b RG4(.write(write), .writeData(writeData), .readData(rgrd[REG_SIZE * 1 - 1:0]), .clk(clk), .rst(rst));
   reg_16b RG5(.write(write), .writeData(writeData), .readData(rgrd[REG_SIZE * 1 - 1:0]), .clk(clk), .rst(rst));
   reg_16b RG6(.write(write), .writeData(writeData), .readData(rgrd[REG_SIZE * 1 - 1:0]), .clk(clk), .rst(rst));
   reg_16b RG7(.write(write), .writeData(writeData), .readData(rgrd[REG_SIZE * 1 - 1:0]), .clk(clk), .rst(rst));
   
   // Read 
   mux8_1_16b MX(.in(rgrd), .s(read1RegSel), .out(read1Data));


endmodule
