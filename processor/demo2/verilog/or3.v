module or3(out, in1, in2, in3);
    input in1, in2, in3;
    output out;

    wire r;
    or2 R0(r, in1, in2);
    or2 R1(out, r, in3);
endmodule