module tb_fulladder4;
    reg [4:0] A;
    reg [4:0] B;
    reg [4:0] Cin;
    reg [4:0] Sumcalc;

    wire [3:0] S;
    wire Cout;
     
    wire Clk, rst, err;
    clkrst my_clkrst( .clk(Clk), .rst(rst), .err(err));
     
    fulladder4 DUT (.A(A[3:0]), .B(B[3:0]), .Cin(Cin[0]), .S(S), .Cout(Cout));

    initial
    begin
        A = 5'b0_0000;
        B = 5'b0_0000;
        Cin = 5'b0_0000;
        #8000 $finish;
    end

    always@(posedge Clk) 
    begin
        A[3:0] = $random;
        B[3:0] = $random;
        Cin[0] = $random;
    end

    always@(negedge Clk)
    begin
        Sumcalc = A + B + Cin;
        $display("A : %x, B : %x, Cin : %x, Sum : %x", A, B, Cin, Sumcalc);

        if (Sumcalc[3:0] !== S) $display ("ERRORCHECK Sum error");
        if (Sumcalc[4] !== Cout) $display ("ERRORCHECK Cout error");
    end

endmodule