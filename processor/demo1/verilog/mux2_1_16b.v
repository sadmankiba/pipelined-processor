module mux2_1_16b(InA, InB, S, Out);
	input [15:0] InA, InB;
	input S;

	output [15:0] Out;

	mux2_1_4b MX0 (.InA(InA[3:0]),  .InB(InB[3:0]),    .S(S), .Out(Out[3:0]));
	mux2_1_4b MX1 (.InA(InA[7:4]), .InB(InB[7:4]),    .S(S), .Out(Out[7:4]));
	mux2_1_4b MX2 (.InA(InA[11:8]),  .InB(InB[11:8]),  .S(S), .Out(Out[11:8]));
	mux2_1_4b MX3 (.InA(InA[15:12]), .InB(InB[15:12]), .S(S), .Out(Out[15:12]));
endmodule
