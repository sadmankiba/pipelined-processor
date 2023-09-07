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
	// Oper | ROL  SLL  ROR  SRL

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

	wire [15:0] eightOut, fourOut, twoOut, oneOut;
    wire [15:0] ShAmtExt, ShAmtInv, SixteenMinusShAmt;
    wire ofl;

	shifter_8b s3(.Out(eightOut),.In(In), .ShAmt(ShAmt[3]), .Oper(Oper));
	shifter_4b s2 (.Out(fourOut), .In(eightOut),.ShAmt(ShAmt[2]), .Oper(Oper));
	shifter_2b s1  (.Out(twoOut), .In(fourOut),  .ShAmt(ShAmt[1]), .Oper(Oper));
    shifter_1b s0  (.Out(oneOut), .In(twoOut),.ShAmt(ShAmt[0]), .Oper(Oper));

    // Rotate right
    sign_ext #(.INPUT_WIDTH(4), .OUTPUT_WIDTH(16)) SX (.in(ShAmt), .out(ShAmtExt));
    xor16 XR(.A(ShAmtExt), .B(16'hffff), .Out(ShAmtInv));
    cla_16b CLA (.sum(SixteenMinusShAmt), .ofl(ofl), .sign(1'b1), .a(16'h0010), .b(ShAmtInv), .c_in(1'b1));
    assign Out = (Oper == 2'b10)? ((In >> ShAmt) | (In << (16 - ShAmt))): oneOut;
   
endmodule
