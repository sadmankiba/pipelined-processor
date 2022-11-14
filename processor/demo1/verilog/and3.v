module and3(out, in1, in2, in3);
    input in1, in2, in3;
    output out;

    wire d;
    and2 AD0(d, in1, in2);
    and2 AD1(out, d, in3);
endmodule