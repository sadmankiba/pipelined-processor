module exmem_reg (/* input */ clk, rst, alu_result_in, 
    readData1In, write_reg_in, brachTakeIn, jumpIn, 
    brAddrIn, jumpAddrIn,
    mem_read_in, mem_write_in, halt_in, mem_to_reg_in, 
    writeRegValidIn, controlZeroExMem,
    /* output */ alu_result_out, readData1Out, 
    write_reg_out, branchTakeOut, jumpOut, brAddrOut, jumpAddrOut,
    mem_read_out, mem_write_out, halt_out, mem_to_reg_out, reg_write_out, writeRegValidOut);

    input clk, rst;
    input [15:0] alu_result_in, readData1In, brAddrIn, jumpAddrIn;
    input mem_read_in, mem_write_in, halt_in, mem_to_reg_in, reg_write_in;
    input [2:0] write_reg_in, writeRegValidIn;
    input controlZeroExMem;

    output [15:0] alu_result_out, readData1Out, brAddrOut, jumpAddrOut;
    output mem_read_out, mem_write_out, halt_out, mem_to_reg_out, reg_write_out;
    output [2:0] write_reg_out, writeRegValidOut;

    wire MemWriteOutFinal, RegWriteOutFinal;

    dff ALU  [15:0] (.q(alu_result_out),    .d(alu_result_in),    .clk(clk), .rst(rst));
    dff READ2[15:0] (.q(readData1Out),     .d(readData1In),     .clk(clk), .rst(rst));

    dff WRITE_REG [2:0] (.q(write_reg_out), .d(write_reg_in), .clk(clk), .rst(rst));

    dff RBA [15:0] (.q(brAddrOut), .d(brAddrIn), .clk(clk), .rst(rst));
    dff RJA [15:0] (.q(jumpAddrOut), .d(jumpAddrIn), .clk(clk), .rst(rst));

    assign MemWriteOutFinal = controlZeroExMem? 1'b0: mem_write_in;
    assign RegWriteOutFinal = controlZeroExMem? 1'b0: reg_write_in;

    dff MEMW (.q(mem_write_out),  .d(MemWriteOutFinal),  .clk(clk), .rst(rst));
    dff RWO  (.q(reg_write_out),  .d(RegWriteOutFinal),  .clk(clk), .rst(rst));
    
    dff RB (.q(branchTakeOut),   .d(branchTakeIn),   .clk(clk), .rst(rst));
    dff RJ (.q(jumpOut),   .d(jumpIn),   .clk(clk), .rst(rst));
    dff MEMR (.q(mem_read_out),   .d(mem_read_in),   .clk(clk), .rst(rst));
    
    dff HALT (.q(halt_out),       .d(halt_in),       .clk(clk), .rst(rst));
    dff MTR  (.q(mem_to_reg_out), .d(mem_to_reg_in), .clk(clk), .rst(rst));
    
    dff RS (.q(writeRegValidOut),       .d(writeRegValidIn),       .clk(clk), .rst(rst));
   
endmodule
