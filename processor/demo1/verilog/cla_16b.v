/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 1
    
    a 16-bit CLA module
*/
module cla_16b(sum, ofl, sign, a, b, c_in);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 16;

    output [N-1:0] sum;
    output         ofl;
    input [N-1: 0] a, b;
    input          c_in;
    input          sign;  // signed or unsigned op
    wire  [N:0]   c;
    assign c[0] = c_in;

    // YOUR CODE HERE
    wire c4, c8, c12;
    cla_4b CA0(sum[3:0], c[4:1], a[3:0], b[3:0], c_in);
    cla_4b CA1(sum[7:4], c[8:5], a[7:4], b[7:4], c[4]);
    cla_4b CA2(sum[11:8], c[12:9], a[11:8], b[11:8], c[8]);
    cla_4b CA3(sum[15:12], c[16:13], a[15:12], b[15:12], c[12]);

    // Overflow
    wire cx;
    xor2 XR(.out(cx), .in1(c[15]), .in2(c[16]));
    mux2_1 MX(.InA(c[16]), .InB(cx), .S(sign), .Out(ofl));

endmodule
