module idex_reg(/* input */ clk, rst, pc_in, read1_in, read2_in, imm_in, jumpaddr_in,
    funct_in, write_reg_in,
    alu_op_in, alu_src_in, branch_in, mem_read_in, mem_write_in,
    mem_to_reg_in, reg_write_in, jump_in, halt_in,
    Rs_in, Rt_in, RsValidIn, RtValidIn, writeRegValidIn, controlZero,
    /* output */ read1_out, read2_out, pc_out, imm_out, jumpaddr_out, funct_out,
    write_reg_out, alu_op_out, alu_src_out, branch_out, mem_read_out, mem_write_out,
    mem_to_reg_out, reg_write_out, jump_out, halt_out,
    Rs_out, Rt_out, RsValidOut, RtValidOut, writeRegValidOut);

    input clk, rst;
    input [15:0] pc_in, read1_in, read2_in, imm_in, jumpaddr_in;
    input [4:0] alu_op_in;
    input [2:0] write_reg_in;
    input [1:0] funct_in;
    input alu_src_in, branch_in, mem_read_in, mem_write_in, mem_to_reg_in;
    input reg_write_in, jump_in, halt_in;
    input [2:0] Rs_in, Rt_in, RsValidIn, RtValidIn, writeRegValidIn;
    input controlZero;

    output [4:0] alu_op_out;
    output [2:0] write_reg_out;
    output [1:0] funct_out;
    output alu_src_out, branch_out, mem_read_out, mem_write_out, mem_to_reg_out;
    output reg_write_out, jump_out, halt_out;
    output [15:0] read1_out, read2_out, pc_out, imm_out, jumpaddr_out;
    output [2:0] Rs_out, Rt_out, RsValidOut, RtValidOut, writeRegValidOut;

    wire mem_write_in_actual, reg_write_in_actual;

    dff PC_FF    [15:0] (.q(pc_out),        .d(pc_in),        .clk(clk), .rst(rst));
    dff READ1_FF [15:0] (.q(read1_out),     .d(read1_in),     .clk(clk), .rst(rst));
    dff READ2_FF [15:0] (.q(read2_out),     .d(read2_in),     .clk(clk), .rst(rst));
    dff IMM_FF   [15:0] (.q(imm_out),       .d(imm_in),       .clk(clk), .rst(rst));
    dff JUMPA_FF [15:0] (.q(jumpaddr_out),  .d(jumpaddr_in),  .clk(clk), .rst(rst));

    dff OP_FF [4:0] (.q(alu_op_out),     .d(alu_op_in),     .clk(clk), .rst(rst));
    
    dff WRITE_REG [2:0] (.q(write_reg_out), .d(write_reg_in), .clk(clk), .rst(rst));

    dff INSTR [1:0] (.q(funct_out), .d(funct_in), .clk(clk), .rst(rst));

    dff SRC_FF      (.q(alu_src_out),    .d(alu_src_in),    .clk(clk), .rst(rst));
    dff BR_FF       (.q(branch_out),     .d(branch_in),     .clk(clk), .rst(rst));
    dff MEMR_FF     (.q(mem_read_out),   .d(mem_read_in),   .clk(clk), .rst(rst));
    
    //Signals to be zero'd
    assign mem_write_in_actual = (controlZero) ? 1'b0 : mem_write_in;
    assign reg_write_in_actual = (controlZero) ? 1'b0 : reg_write_in;

    dff MEMW_FF     (.q(mem_write_out),  .d(mem_write_in_actual),  .clk(clk), .rst(rst));
    dff RW_FF       (.q(reg_write_out),  .d(reg_write_in_actual),  .clk(clk), .rst(rst));

    dff MEMTR_FF    (.q(mem_to_reg_out), .d(mem_to_reg_in), .clk(clk), .rst(rst));
    dff JUMP_FF     (.q(jump_out),       .d(jump_in),       .clk(clk), .rst(rst));
    dff HALT_FF     (.q(halt_out),       .d(halt_in),       .clk(clk), .rst(rst));

    dff RRS [2:0] (.q(Rs_out), .d(Rs_in), .clk(clk), .rst(rst));
    dff RRT [2:0] (.q(Rt_out), .d(Rt_in), .clk(clk), .rst(rst));
    dff RRSV [2:0] (.q(RsValidOut), .d(RsValidIn), .clk(clk), .rst(rst));
    dff RRTV [2:0] (.q(RtValidOut), .d(RtValidIn), .clk(clk), .rst(rst));
    dff RRDV [2:0] (.q(writeRegValidOut), .d(writeRegValidIn), .clk(clk), .rst(rst));
endmodule
