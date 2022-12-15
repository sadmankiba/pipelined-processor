module sign_ext(in, out);
    parameter INPUT_WIDTH = 1;
    parameter OUTPUT_WIDTH = 16;
    parameter SIGN_TO_ADD = OUTPUT_WIDTH - INPUT_WIDTH;

	input [INPUT_WIDTH - 1:0] in;
	output [OUTPUT_WIDTH - 1:0] out;

    wire sign;
    assign sign = in[INPUT_WIDTH - 1];
    assign out = { { (SIGN_TO_ADD){sign} }, in};

endmodule
