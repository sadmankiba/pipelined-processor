module mux2_1(InA, InB, S, Out);
	input InA, InB, S;
	output Out;

	wire ns;
	wire aNdS, bNdS;

	not1 NT(.in1(S), .out(ns));
	
	nand2 ND1(.in1(InA), .in2(ns), .out(aNdS));
	nand2 ND2(.in1(InB), .in2(S), .out(bNdS));
	nand2 ND3(.in1(bNdS), .in2(aNdS), .out(Out));

endmodule
