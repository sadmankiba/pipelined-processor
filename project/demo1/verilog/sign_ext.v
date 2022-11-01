module sign_ext(in, out);
    parameter INPUT_WIDTH = 1;
    parameter OUTPUT_WIDTH = 16;

	input [INPUT_WIDTH - 1:0] in;
	output [OUTPUT_WIDTH - 1:0] out;

    assign out = { { (OUTPUT_WIDTH - INPUT_WIDTH){in[INPUT_WIDTH - 1]} }, in};

endmodule
