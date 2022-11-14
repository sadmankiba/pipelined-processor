module tb_fullAdder_1b;
    reg [1:0] A;
    reg [1:0] B;
    reg [1:0] Cin;
    reg [1:0] Sumcalc;

    wire S;
    wire Cout;
     
    wire Clk, rst, err;
    clkrst my_clkrst( .clk(Clk), .rst(rst), .err(err));
     
    fullAdder_1b DUT (S, Cout, A[0], B[0], Cin[0]);

    initial
    begin
        A = 2'b00;
        B = 2'b00;
        Cin = 2'b00;
        #8000 $finish;
    end

    always@(posedge Clk) 
    begin
        A[0] = $random;
        B[0] = $random;
        Cin[0] = $random;
    end

    always@(negedge Clk)
    begin
        Sumcalc = A + B + Cin;
        $display("A : %x, B : %x, Cin : %x, Act sum : %x, Cout: %x, S: %x", A, B, Cin, Sumcalc, Cout, S);

        if (Sumcalc[0] !== S) $display ("ERRORCHECK Sum error");
        if (Sumcalc[1] !== Cout) $display ("ERRORCHECK Cout error");
    end

endmodule
