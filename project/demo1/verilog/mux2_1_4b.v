module mux2_1_4b(InB, InA, S, Out);

	input [3:0] InA, InB;
	input S;
	output [3:0] Out;

	mux2_1 MX0 (.InB(InB[0]), .InA(InA[0]), .S(S), .Out(Out[0]));
	mux2_1 MX1 (.InB(InB[1]), .InA(InA[1]), .S(S), .Out(Out[1]));
	mux2_1 MX2 (.InB(InB[2]), .InA(InA[2]), .S(S), .Out(Out[2]));
	mux2_1 MX3 (.InB(InB[3]), .InA(InA[3]), .S(S), .Out(Out[3]));

endmodule
