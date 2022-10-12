module tb_cla_4b;
   reg [4:0] A;
   reg [4:0] B;
   reg [4:0] Sumcalc;
   reg 		  c_in;
   wire [3:0] SUM;
   wire        CO;
   wire        Clk;
   //2 dummy wires
   wire 	   rst;
   wire 	   err;

   clkrst my_clkrst( .clk(Clk), .rst(rst), .err(err));
   cla_4b DUT (.sum(SUM), .c_out(CO), .a(A[3:0]), .b(B[3:0]), .c_in(c_in));

   initial begin
      A = 5'b0_0000;
      B = 5'b0_0000;
      c_in = 1'b0;
      #3200 $finish;
   end
   
   always@(posedge Clk) begin
      A[3:0] = $random;
      B[3:0] = $random;
      c_in = $random;
   end
   
   always@(negedge Clk) begin
      Sumcalc = A+B+c_in;
      $display("A: 0x%x, B: 0x%x, C_in: 0x%x, Sum: 0x%x, Golden Sum: 0x%x, C_out: 0x%x", A, B, c_in, SUM, Sumcalc, CO);

      if (Sumcalc[3:0] !== SUM) $display ("ERRORCHECK Sum error");
      if (Sumcalc[4] !== CO) $display ("ERRORCHECK CO error");
   end
endmodule
