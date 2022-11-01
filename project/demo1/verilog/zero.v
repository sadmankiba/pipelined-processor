module zero(in, zero);
	parameter INPUT_WIDTH = 16;

	input [INPUT_WIDTH-1:0] in;
	output zero;

	assign zero = ~|in; 
endmodule
