/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 1
    
    a 16-bit CLA module
*/
module cla_16b(sum, c_out, ofl, sign, a, b, c_in);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 16;

    output [N-1:0] sum;
    output         c_out, ofl;
    input [N-1: 0] a, b;
    input          c_in;
    input          sign;

    // YOUR CODE HERE
    wire c4, c8, c12;
    cla_4b CA0(sum[3:0], c4, a[3:0], b[3:0], c_in);
    cla_4b CA1(sum[7:4], c8, a[7:4], b[7:4], c4);
    cla_4b CA2(sum[11:8], c12, a[11:8], b[11:8], c8);
    cla_4b CA3(sum[15:12], c_out, a[15:12], b[15:12], c12);

endmodule
