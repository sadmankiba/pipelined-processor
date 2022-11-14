module exmem_reg (/* input */ clk, rst, alu_result_in, 
    readData1In, write_reg_in,
    mem_read_in, mem_write_in, halt_in, mem_to_reg_in, 
    reg_write_in, Rs_in, Rd_in, Rt_in,
    /* output */ alu_result_out, readData1Out, 
    write_reg_out, mem_read_out, mem_write_out, halt_out,
    mem_to_reg_out, reg_write_out,
    Rs_out, Rd_out, Rt_out);

    input clk, rst;
    input [15:0] alu_result_in, readData1In;
    input mem_read_in, mem_write_in, halt_in, mem_to_reg_in, reg_write_in;
    input [2:0] write_reg_in;
    input [2:0] Rs_in, Rd_in, Rt_in;

    output [15:0] alu_result_out, readData1Out;
    output mem_read_out, mem_write_out, halt_out, mem_to_reg_out, reg_write_out;
    output [2:0] write_reg_out;
    output [2:0] Rs_out, Rd_out, Rt_out;

    dff ALU  [15:0] (.q(alu_result_out),    .d(alu_result_in),    .clk(clk), .rst(rst));
    dff READ2[15:0] (.q(readData1Out),     .d(readData1In),     .clk(clk), .rst(rst));

    dff WRITE_REG [2:0] (.q(write_reg_out), .d(write_reg_in), .clk(clk), .rst(rst));

    dff MEMR (.q(mem_read_out),   .d(mem_read_in),   .clk(clk), .rst(rst));
    dff MEMW (.q(mem_write_out),  .d(mem_write_in),  .clk(clk), .rst(rst));
    dff HALT (.q(halt_out),       .d(halt_in),       .clk(clk), .rst(rst));
    dff MTR  (.q(mem_to_reg_out), .d(mem_to_reg_in), .clk(clk), .rst(rst));
    dff RWO  (.q(reg_write_out),  .d(reg_write_in),  .clk(clk), .rst(rst));
    
    dff RS [2:0] (.q(Rs_out),       .d(Rs_in),       .clk(clk), .rst(rst));
    dff RT [2:0] (.q(Rt_out),       .d(Rt_in),       .clk(clk), .rst(rst));
    dff RD [2:0] (.q(Rd_out),       .d(Rd_in),       .clk(clk), .rst(rst));
endmodule
