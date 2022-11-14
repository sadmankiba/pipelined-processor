module or2(out, in1, in2);
    input in1, in2;
    output out;

    wire nr;
    nor2 NR(nr, in1, in2);
    not1 NT(.out(out), .in1(nr));
endmodule