module fulladder1 (A, B, Cin, S, Cout);
    input A, B, Cin;
    output S, Cout;

    wire axrb;
    xor2 XR1(.in1(A), .in2(B), .out(axrb));
    
    xor2 XR2(.in1(axrb), .in2(Cin), .out(S));

    wire cnd, cndn;
    nand2 ND1(.in1(axrb), .in2(Cin), .out(cnd));
    not1 NT1(.in1(cnd), .out(cndn));

    wire abnd, abndn;
    nand2 ND2(.in1(A), .in2(B), .out(abnd));
    not1 NT2(.in1(abnd), .out(abndn));

    wire abcr;
    nor2 NR1(.in1(abndn), .in2(cndn), .out(abcr));
    not1 NT3(.in1(abcr), .out(Cout));
endmodule