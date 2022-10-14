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
    wire [15:0] a_inv, b_inv, muxed_A, muxed_B;
	wire [15:0] add_out, or_out, xor_out, and_out, logical_out, shift_out;
	wire add_Ofl, Ofl_temp;

	inverter A_INV(.In(InA[15:0]), .sign(sign), .Out(a_inv[15:0]));
    inverter B_INV(.In(InB[15:0]), .sign(sign), .Out(b_inv[15:0]));

	// Inversion MUX
	mux2_1_16bit A_OR_AINV (.InB(a_inv[15:0]), .InA(InA[15:0]), .S(invA), .Out(muxed_A[15:0]));
	mux2_1_16bit B_OR_BINV (.InB(b_inv[15:0]), .InA(InB[15:0]), .S(invB), .Out(muxed_B[15:0]));

    cla_16b CLA (.sum(add_out[15:0]), .ofl(add_Ofl), .sign(sign), 
        .a(muxed_A[15:0]), .b(muxed_B[15:0]), .c_in(Cin));
	// adder16 A0(.Out(add_out[15:0]), .Ofl(add_Ofl), .A(muxed_A[15:0]), .B(muxed_B[15:0]), .Cin(Cin), .sign(sign));
	
	or16    OR0 (.A(muxed_A[15:0]), .B(muxed_B[15:0]), .Out(or_out[15:0]));
	xor16   XOR0 (.A(muxed_A[15:0]), .B(muxed_B[15:0]), .Out(xor_out[15:0]));
	and16   AND0 (.A(muxed_A[15:0]), .B(muxed_B[15:0]), .Out(and_out[15:0]));

	shifter	SHIFT0(.In(muxed_A[15:0]), .ShAmt(muxed_B[3:0]), .Oper(Oper[1:0]), .Out(shift_out[15:0]));

    // Output Mux
	mux4_1_16bit LOGICAL_MUX (.InD(xor_out[15:0]), .InC(or_out[15:0]), .InB(and_out[15:0]), .InA(add_out[15:0]), .S(Oper[1:0]), .Out(logical_out[15:0]));
	mux2_1_16bit SHIFT_OR_ALU(.InB(logical_out[15:0]), .InA(shift_out[15:0]), .S(Oper[2]), .Out(Out[15:0])); 

	// Overflow
	mux2_1 OFLMUX1(.InB(add_Ofl), .InA(1'b0), .S(Oper[2]), .Out(Ofl_temp));
	mux4_1 OFLMUX2(.InD(1'b0), .InC(1'b0), .InB(1'b0), .InA(Ofl_temp), .S(Oper[1:0]), .Out(Ofl));

	// Zero
	zero_detector ZERO(Out[15:0], Zero);
    
endmodule
