module mux8_1_16b(InA, InB, InC, InD, InE, InF, InG, InH, S, Out);
	input  [15:0] InA, InB, InC, InD, InE, InF, InG, InH;
	input  [2:0] S;
	output [15:0] Out;

	wire [15:0] low, high;

	mux4_1_16b LOW (.InA(InA), .InB(InB), .InC(InC), .InD(InD), .S(S[1:0]), .Out(low));
	mux4_1_16b HIGH(.InA(InE), .InB(InF), .InC(InG), .InD(InH), .S(S[1:0]), .Out(high));
	mux2_1_16b TOP (.InA(low), .InB(high), .S(S[2]), .Out(Out));
	
endmodule
