module ifid_reg(/*input */ pc_in, instr_in, validInsIn, clk, rst, 
                /* output */ pc_out, instr_out, validInsOut);

  input clk, rst;
  input [15:0] pc_in;
  input [15:0] instr_in;
  input validInsIn;

  output [15:0] pc_out;
  output [15:0] instr_out;
  output validInsOut;

  dff RP [15:0]  (.q(pc_out), .d(pc_in), .clk(clk), .rst(rst));
  dff RI [15:0] (.q(instr_out), .d(instr_in), .clk(clk), .rst(rst));
  dff RV [15:0] (.q(validInsOut), .d(validInsIn), .clk(clk), .rst(rst));

endmodule
