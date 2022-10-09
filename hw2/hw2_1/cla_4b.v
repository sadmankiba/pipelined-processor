/*
    CS/ECE 552 FALL'22
    Homework #2, Problem 1
    
    a 4-bit CLA module
*/
module cla_4b(sum, c_out, a, b, c_in);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 4;

    output [N-1:0] sum;
    output         c_out;
    input [N-1: 0] a, b;
    input          c_in;

    // YOUR CODE HERE

endmodule
