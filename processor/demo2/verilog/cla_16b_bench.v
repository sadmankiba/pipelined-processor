module cla_16b_bench;
   // A, B, and Sumcalc use an extra bit so we don't need to calculate the carry out bit separately.  Thus, Sumcalc[16] is the golden carry-out bit in the below calculations.
   reg [16:0] A;
   reg [16:0] B;
   reg [16:0] Sumcalc;
   reg 		  c_in;
   wire [15:0] SUM;
   wire        ofl;
   wire        Clk;
   //2 dummy wires
   wire 	   rst;
   wire 	   err;

   clkrst my_clkrst( .clk(Clk), .rst(rst), .err(err));
   cla_16b DUT (.sum(SUM), .ofl(ofl), .sign(1'b1), .a(A[15:0]), .b(B[15:0]), .c_in(c_in));

   initial begin
      A = 17'b0_0000_0000_0000_0000;
      B = 17'b0_0000_0000_0000_0000;
      c_in = 1'b0;
      #3200 $finish;
   end
   
   always@(posedge Clk) begin
      // only initialize lower 16 bits of A and B to ensure that if the last bit is 1, it's because there was a carry out
      A[15:0] = $random;
      B[15:0] = $random;
      c_in = $random;
   end
   
   always@(negedge Clk) begin
      Sumcalc = A+B+c_in;
      $display("A: 0x%x, B: 0x%x, C_in: 0x%x, Sum: 0x%x, Golden Sum: 0x%x, Ofl: 0x%x", A, B, c_in, SUM, Sumcalc, ofl);

      if (Sumcalc[15:0] !== SUM) $display ("ERRORCHECK Sum error");
   end
endmodule // cla_16b_bench
