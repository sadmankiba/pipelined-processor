module and2(out, in1, in2);
    input in1, in2;
    output out;

    wire nd;
    nand2(nd, in1, in2);
    not1(out, nd);
endmodule