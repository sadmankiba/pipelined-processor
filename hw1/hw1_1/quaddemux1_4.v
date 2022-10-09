module quaddemux1_4 (Inp, S, OutA, OutB, OutC, OutD);
    input [3:0] Inp;
    input [1:0] S;
    output [3:0] OutA, OutB, OutC, OutD;

    demux1_4 DX1(.in(Inp[0]), .s(S), .out1(OutA[0]), .out2(OutB[0]), 
        .out3(OutC[0]), .out4(OutD[0]));

    demux1_4 DX2(.in(Inp[1]), .s(S), .out1(OutA[1]), .out2(OutB[1]), 
        .out3(OutC[1]), .out4(OutD[1]));
    
    demux1_4 DX3(.in(Inp[2]), .s(S), .out1(OutA[2]), .out2(OutB[2]), 
        .out3(OutC[2]), .out4(OutD[2]));
    
    demux1_4 DX4(.in(Inp[3]), .s(S), .out1(OutA[3]), .out2(OutB[3]), 
        .out3(OutC[3]), .out4(OutD[3]));
endmodule