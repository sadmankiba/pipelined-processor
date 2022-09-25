module demux1_2 (in, s, out1, out2);
    input in;
    input s;
    output out1;
    output out2;

    wire sc;
    not1 NT1(.in1(s), .out(sc));
    
    wire scind;
    nand2 ND1(.in1(sc), .in2(in), .out(scind));
    not1 NT2(.in1(scind), .out(out1));

    wire sind;
    nand2 ND2(.in1(s), .in2(in), .out(sind));
    not1 NT3(.in1(sind), .out(out2));
endmodule 