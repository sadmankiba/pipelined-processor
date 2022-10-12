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
    
    wire g0, p0;
    pg PG0(p0, g0, a[0], b[0]);
    pg PG1(p1, g1, a[1], b[1]);
    pg PG2(p2, g2, a[2], b[2]);
    pg PG3(p3, g3, a[3], b[3]);

    wire pdc0, c1;
    and2 AD0(pdc0, p0, c_in);
    or2 OR0(c1, g0, pdc0);
    
    wire pdg0, pdg1, c2; 
    and2 AD1(pdg0, p1, g0);
    and3 AD2(pdg1, p1, p0, c_in);
    or3 OR1(c2, g1, pdg0, pdg1);

    // C3 = G2 + P2C2 = G2 + P2G1 + P2P1G0 + P2P1P0C0
    wire pdg2, pdg3, pdg4, c3;
    and2 AD2(pdg2, p2, g1);
    and3 AD3(pdg3, p2, p1, g0);
    and4 AD4(pdg4, p2, p1, p0, c_in);
    or4 OR2(c3, g2, pdg2, pdg3, pdg4);

    // C4 = G3 + P3*G2 + p3*p2*g1 + p3*p2*p1*g0 + p3*p2*p1*p0*c0
    wire pdg5, pdg6, pdg7, pdg8, pdg9, prg;
    and2 AD5(pdg5, p3, g2);
    and3 AD6(pdg6, p3, p2, g1);
    and4 AD7(pdg7, p3, p2, p1, g0);
    and4 AD8(pdg8, p2, p1, p0, c_in);
    and2 AD9(pdg9, p3, pdg8);
    or4 OR3(prg, pdg5, pdg6, pdg7, pdg9);
    or2 OR4(c_out, g3, prg);
    
    xor2 XR0(sum[0], p0, c_in);
    xor2 XR1(sum[1], p1, c1);
    xor2 XR2(sum[2], p2, c2);
    xor3 XR3(sum[3], p3, c3);

endmodule
