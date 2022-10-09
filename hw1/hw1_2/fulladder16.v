module fulladder16 (A, B, S, Cout);
    input [15:0] A, B;
    output [15:0] S;
    output Cout;

    wire co1, co2, c03;
    fulladder4 F1(.A(A[3:0]), .B(B[3:0]), .Cin(1'b0), .S(S[3:0]), .Cout(co1));
    fulladder4 F2(.A(A[7:4]), .B(B[7:4]), .Cin(co1), .S(S[7:4]), .Cout(co2));
    fulladder4 F3(.A(A[11:8]), .B(B[11:8]), .Cin(co2), .S(S[11:8]), .Cout(co3));
    fulladder4 F4(.A(A[15:12]), .B(B[15:12]), .Cin(co3), .S(S[15:12]), .Cout(Cout));
endmodule