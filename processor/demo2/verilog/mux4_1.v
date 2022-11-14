module mux4_1(InA, InB, InC, InD, S, Out);
	input InA, InB, InC, InD;
	input [1:0] S;
	output Out;

	wire mx0, mx1;

	mux2_1 MX0 (.InA(InA), .InB(InB), .S(S[0]), .Out(mx0));
	mux2_1 MX1 (.InA(InC), .InB(InD), .S(S[0]), .Out(mx1));
	mux2_1 MX2 (.InA(mx0), .InB(mx1), .S(S[1]), .Out(Out));

endmodule

