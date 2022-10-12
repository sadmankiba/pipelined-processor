module or4(out, in1, in2, in3, in4);
    input in1, in2, in3, in4;
    output out;

    wire r;
    or3 R0(r, in1, in2, in3);
    or2 R1(out, r, in3);
endmodule