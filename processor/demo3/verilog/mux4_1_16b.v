module mux4_1_16b(InA, InB, InC, InD, S, Out);
	input [15:0] InA, InB, InC, InD;
	input [1:0] S;

	output [15:0] Out;
	
	wire [15:0] mx0, mx1;
	mux2_1_16b MX0 (.InA(InA[15:0]), .InB(InB[15:0]), .S(S[0]), .Out(mx0[15:0]));
	mux2_1_16b MX1 (.InA(InC[15:0]), .InB(InD[15:0]), .S(S[0]), .Out(mx1[15:0]));
	mux2_1_16b MX2 (.InA(mx0[15:0]), .InB(mx1[15:0]), .S(S[1]), .Out(Out[15:0]));
endmodule
