module fulladder4 (A, B, Cin, S, Cout);
    input [3:0] A, B;
    input Cin;
    output [3:0] S;
    output Cout;

    wire co1, co2, c03;
    fulladder1 F1(.A(A[0]), .B(B[0]), .Cin(Cin), .S(S[0]), .Cout(co1));
    fulladder1 F2(.A(A[1]), .B(B[1]), .Cin(co1), .S(S[1]), .Cout(co2));
    fulladder1 F3(.A(A[2]), .B(B[2]), .Cin(co2), .S(S[2]), .Cout(co3));
    fulladder1 F4(.A(A[3]), .B(B[3]), .Cin(co3), .S(S[3]), .Cout(Cout));
endmodule