module and2(out, in1, in2);
    input in1, in2;
    output out;

    wire nd;
    nand2 ND(nd, in1, in2);
    not1 NT(out, nd);
endmodule