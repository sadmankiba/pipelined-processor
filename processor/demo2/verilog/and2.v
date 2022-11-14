module and2(out, in1, in2);
    input in1, in2;
    output out;

    wire nd;
    nand2 ND(.out(nd), .in1(in1), .in2(in2));
    not1 NT(.out(out), .in1(nd));
endmodule