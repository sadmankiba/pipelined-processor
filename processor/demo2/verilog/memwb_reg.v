module memwb_reg(/*input*/ clk, rst, data_mem_in,  
                    alu_result_in, write_reg_in, mem_to_reg_in, reg_write_in, MemReadIn,
                    writeRegValidIn, 
                    /*output*/ data_mem_out, alu_result_out, 
                    write_reg_out, mem_to_reg_out, reg_write_out, MemReadOut,
                    writeRegValidOut);

    input clk, rst;
    input [15:0]data_mem_in, alu_result_in;
    input [2:0] write_reg_in;
    input mem_to_reg_in, reg_write_in, MemReadIn;
    input [2:0] writeRegValidIn;

    output [15:0] data_mem_out, alu_result_out;
    output [2:0] write_reg_out;
    output mem_to_reg_out, reg_write_out, MemReadOut;
    output [2:0] writeRegValidOut;

    dff DMEM [15:0](.q(data_mem_out),     .d(data_mem_in),     .clk(clk), .rst(rst));
    dff ALUR [15:0](.q(alu_result_out),   .d(alu_result_in),   .clk(clk), .rst(rst));

    dff WREG [2:0] (.q(write_reg_out), .d(write_reg_in), .clk(clk), .rst(rst));

    dff RMTR (.q(mem_to_reg_out), .d(mem_to_reg_in), .clk(clk), .rst(rst));
    dff RRW (.q(reg_write_out),  .d(reg_write_in),  .clk(clk), .rst(rst));
    dff RMR (.q(MemReadOut),  .d(MemReadIn),  .clk(clk), .rst(rst));
    
    dff RS [2:0] (.q(writeRegValidOut),       .d(writeRegValidIn),       .clk(clk), .rst(rst));
endmodule
