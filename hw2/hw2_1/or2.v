module or2(out, in1, in2);
    input in1, in2;
    output out;

    wire nr;
    nor2(nr, in1, in2);
    not1(out, nr);
endmodule