module zero_ext(in, out);
    parameter INPUT_WIDTH = 1;
    parameter OUTPUT_WIDTH = 16;
    parameter ZERO_TO_ADD = OUTPUT_WIDTH - INPUT_WIDTH;

	input [INPUT_WIDTH - 1:0] in;
	output [OUTPUT_WIDTH - 1:0] out;

    assign out = { { (ZERO_TO_ADD){1'b0} }, in};
endmodule
