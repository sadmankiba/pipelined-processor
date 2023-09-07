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

    //Cout = Cin(a ⊕ b) + ab
    wire axb;
    xor2 XTW0(axb, a, b);
    
    wire inx, idx;
    nand2 ND0(.out(inx), .in1(c_in), .in2(axb));
    not1 NT0(.out(idx), .in1(inx));

    wire anb, adb;
    nand2 ND1(.out(anb), .in1(a), .in2(b));
    not1 NT1(.out(adb), .in1(anb));

    wire nco;
    nor2 NR0(nco, idx, adb);
    not1 NT2(.out(c_out), .in1(nco));

endmodule
