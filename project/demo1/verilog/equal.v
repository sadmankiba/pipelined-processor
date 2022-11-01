module equal(in1, in2, eq);
    parameter INPUT_WIDTH = 16;
    
    input [INPUT_WIDTH - 1:0] in1, in2;
    output eq;

    wire [INPUT_WIDTH - 1:0] nd;
    assign nd = in1 ^ in2;
    
    zero #(.INPUT_WIDTH(5)) ZR(.in(nd), .zero(eq));
endmodule