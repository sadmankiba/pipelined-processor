module and4(out, in1, in2, in3, in4);
    input in1, in2, in3, in4;
    output out;

    wire d;
    and3 AD0(d, in1, in2, in3);
    and2 AD1(out, d, in4);
endmodule