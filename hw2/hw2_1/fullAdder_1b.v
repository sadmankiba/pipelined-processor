/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 1
    
    a 1-bit full adder
*/
module fullAdder_1b(s, c_out, a, b, c_in);
    output s;
    output c_out;
	input  a, b;
    input  c_in;

    // YOUR CODE HERE
    xor3 XTR0(s, c_in, a, b);

    wire axb;
    xor2 XTW0(axb, a, b);
    
    wire inx, idx;
    nand2 ND0(inx, c_in, axb);
    not1 NT0(idx, inx);

    wire anb, adb;
    nand2 ND1(anb, a, b);
    not1 NT1(adb, anb);

    wire nco;
    nor2 NR0(nco, idx, adb);
    not1 NT2(c_out, nco);

endmodule
