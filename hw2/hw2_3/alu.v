/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 3

    A multi-bit ALU module (defaults to 16-bit). It is designed to choose
    the correct operation to perform on 2 multi-bit numbers from rotate
    left, shift left, shift right arithmetic, shift right logical, add,
    or, xor, & and.  Upon doing this, it should output the multi-bit result
    of the operation, as well as drive the output signals Zero and Overflow
    (OFL).
*/
module alu (InA, InB, Cin, Oper, invA, invB, sign, Out, Zero, Ofl);

    parameter OPERAND_WIDTH = 16;    
    parameter NUM_OPERATIONS = 3;
       
    input  [OPERAND_WIDTH -1:0] InA ; // Input operand A
    input  [OPERAND_WIDTH -1:0] InB ; // Input operand B
    input                       Cin ; // Carry in
    input  [NUM_OPERATIONS-1:0] Oper; // Operation type
    input                       invA; // Signal to invert A
    input                       invB; // Signal to invert B
    input                       sign; // Signal for signed operation
    output [OPERAND_WIDTH -1:0] Out ; // Result of computation
    output                      Ofl ; // Signal if overflow occured
    output                      Zero; // Signal if Out is 0

    /* YOUR CODE HERE */
    wire [15:0] aInv, bInv, A, B;
	wire [15:0] addOut, orOut, xorOut, andOut, logicalOut, shiftOut;
	wire aOfl;

	inv AInv(.In(InA[15:0]), .sign(sign), .Out(aInv[15:0]));
    inv BInv(.In(InB[15:0]), .sign(sign), .Out(bInv[15:0]));

	// Inversion MUX
	mux2_1_16b MXA (.InB(aInv[15:0]), .InA(InA[15:0]), .S(invA), .Out(A[15:0]));
	mux2_1_16b MXB (.InB(bInv[15:0]), .InA(InB[15:0]), .S(invB), .Out(B[15:0]));

    cla_16b CLA (.sum(addOut[15:0]), .ofl(aOfl), .sign(sign), 
        .a(A[15:0]), .b(B[15:0]), .c_in(Cin));
	and16   AD (.A(A[15:0]), .B(B[15:0]), .Out(andOut[15:0]));
	or16    OR (.A(A[15:0]), .B(B[15:0]), .Out(orOut[15:0]));
	xor16   XR (.A(A[15:0]), .B(B[15:0]), .Out(xorOut[15:0]));
	shifter	SFT (.In(A[15:0]), .ShAmt(B[3:0]), .Oper(Oper[1:0]), .Out(shiftOut[15:0]));

    // Output Mux
	mux4_1_16b MXL (.InD(xorOut[15:0]), .InC(orOut[15:0]), .InB(andOut[15:0]), .InA(addOut[15:0]), .S(Oper[1:0]), .Out(logicalOut[15:0]));
	mux2_1_16b MXOUT(.InB(logicalOut[15:0]), .InA(shiftOut[15:0]), .S(Oper[2]), .Out(Out[15:0])); 

	// Overflow
    wire no0, no1;
    not1 NT0 (no0, Oper[0]);
    not1 NT1 (no1, Oper[1]);
	and4 AD1 (Ofl, Oper[2], no1, no0, aOfl);

	// Zero
	// zero_detector ZERO(Out[15:0], Zero);
    assign Zero = ~|Out[15:0];
    
endmodule
