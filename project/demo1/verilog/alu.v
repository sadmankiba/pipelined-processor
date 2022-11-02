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
module alu (InA, InB, Cin, Oper, invA, invB, sign, Out, Zero, Ofl, Ltz);

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
    output                      Ltz ; // Less than 0

    /* YOUR CODE HERE */
    /*
    Opcode Function Result
    000 rll Rotate left
    001 sll Shift left logical
    010 ror Rotate right
    011 srl Shift right logical
    100 ADD A+B
    101 OR A OR B
    110 XOR A XOR B
    111 AND A AND B
    */
    wire [15:0] aInv, bInv, A, B;
	wire [15:0] addRes, orRes, xorRes, andRes, logicalRes, shiftRes;
	wire aOfl, ltzi;

	inv AInv(.In(InA), .sign(sign), .Out(aInv));
    inv BInv(.In(InB), .sign(sign), .Out(bInv));

	// Inversion MUX
	mux2_1_16b MXA (.InB(aInv), .InA(InA), .S(invA), .Out(A));
	mux2_1_16b MXB (.InB(bInv), .InA(InB), .S(invB), .Out(B));

    cla_16b CLA (.sum(addRes), .ofl(aOfl), .sign(sign), 
        .a(A), .b(B), .c_in(Cin));
	and16   AD (.A(A), .B(B), .Out(andRes));
	or16    OR (.A(A), .B(B), .Out(orRes));
	xor16   XR (.A(A), .B(B), .Out(xorRes));
	shifter	SFT (.In(A), .ShAmt(B[3:0]), .Oper(Oper[1:0]), .Out(shiftRes));

    // Output Mux
	mux4_1_16b MXL (.InA(addRes), .InB(orRes), .InC(xorRes), .InD(andRes),  
        .S(Oper[1:0]), .Out(logicalRes));
	mux2_1_16b MXOUT(.InA(shiftRes), .InB(logicalRes), .S(Oper[2]), .Out(Out)); 

	// Overflow
    wire no0, no1;
    not1 NT0 (.out(no0), .in1(Oper[0]));
    not1 NT1 (.out(no1), .in1(Oper[1]));
	and4 AD1 (Ofl, Oper[2], no1, no0, aOfl);

	// Zero
    assign Zero = ~|Out;
    assign ltzi = (Out[15] == 1) ? 1'b1 : 1'b0;
    assign Ltz = ((Ofl & (Out[15] ^ A[15])) == 1'b1)  ? ~ltzi : ltzi;
    
endmodule
