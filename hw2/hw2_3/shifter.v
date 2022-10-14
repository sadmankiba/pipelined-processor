/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 2
    
    A barrel shifter module.  It is designed to shift a number via rotate
    left, shift left, shift right arithmetic, or shift right logical based
    on the 'Oper' value that is passed in.  It uses these
    shifts to shift the value any number of bits.
 */
module shifter (In, ShAmt, Oper, Out);
    // Opc| 00   01   10   11
	// Oper | ROL  SLL  SRA  SRL

    // declare constant for size of inputs, outputs, and # bits to shift
    parameter OPERAND_WIDTH = 16;
    parameter SHAMT_WIDTH   =  4;
    parameter NUM_OPERATIONS = 2;

    input  [OPERAND_WIDTH -1:0] In   ; // Input operand
    input  [SHAMT_WIDTH   -1:0] ShAmt; // Amount to shift/rotate
    input  [NUM_OPERATIONS-1:0] Oper ; // Operation type
    output [OPERAND_WIDTH -1:0] Out  ; // Result of shift/rotate

    /* YOUR CODE HERE */
    input [15:0] In;
    input [3:0]  ShAmt;
    input [1:0]  Oper;
    output [15:0] Out;

	wire [15:0] eight_to_four;
	wire [15:0] four_to_two;
	wire [15:0] two_to_one;

	shifter_eight_bit s3(.Out(eight_to_four),.In(In),           .ShAmt(ShAmt[3]), .Oper(Oper));
	shifter_four_bit s2 (.Out(four_to_two),  .In(eight_to_four),.ShAmt(ShAmt[2]), .Oper(Oper));
	shifter_two_bit s1  (.Out(two_to_one),   .In(four_to_two),  .ShAmt(ShAmt[1]), .Oper(Oper));
    shifter_one_bit s0  (.Out(Out),          .In(two_to_one),   .ShAmt(ShAmt[0]), .Oper(Oper));
   
endmodule
