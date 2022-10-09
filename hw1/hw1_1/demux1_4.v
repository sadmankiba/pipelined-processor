module demux1_4 (in, s, out1, out2, out3, out4);
    input in;
    input [1:0] s;
    output out1, out2, out3, out4;

    wire d11, d12;
    demux1_2 DX1(.in(in), .s(s[1]), .out1(d11), .out2(d12));
    
    demux1_2 DX2(.in(d11), .s(s[0]), .out1(out1), .out2(out2));

    demux1_2 DX3(.in(d12), .s(s[0]), .out1(out3), .out2(out4));
endmodule