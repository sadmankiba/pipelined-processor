module control(/* input */ opcode, validIns,
	/* output */ RegDst, AluSrc, AluOp, Branch, MemRead, MemWrite,
               Jump, memToReg, RegWrite, halt, zeroExt, i1Fmt, err);

	input [4:0] opcode;
	input validIns;

	output reg RegDst, AluSrc, Branch, MemRead, MemWrite, Jump, memToReg, RegWrite;         
	output reg halt, zeroExt, i1Fmt, err;
	output [4:0] AluOp;    

	wire [4:0] newOpc; 

	mux2_1 MV [4:0] (.InA(5'b0_0001), .InB(opcode), .S(validIns), .Out(newOpc));

	assign AluOp = newOpc;
	
	always @(newOpc)
	begin
		RegDst   = 1'b0; /* Whether Write Register is Ins[7:5] as in I1 or  Ins [4:2] as in R-format */ 
		AluSrc   = 1'b0; RegWrite = 1'b0; 		
		Branch   = 1'b0; MemRead  = 1'b0; MemWrite = 1'b0; 
		memToReg = 1'b0; Jump     = 1'b0; 
		halt     = 1'b0; zeroExt = 1'b0; 
		i1Fmt = 1'b0; err = 1'b0;
		case(newOpc)
			/* halt */
			5'b0_0000: 	
				begin
					// Sets halt in memory that finishes testbench execution. 
					halt = 1'b1; 
				end
			/* nop */ 
			5'b0_0001: 
				begin
				end
			/* I-format 1: addi, subi, xori, andni*/
			5'b0_1000: 
				begin
					AluSrc = 1'b1; RegWrite = 1'b1; i1Fmt = 1'b1; 	
				end
			5'b0_1001: 
				begin
					AluSrc = 1'b1; RegWrite = 1'b1; i1Fmt = 1'b1; 
				end
			5'b0_1010: 
				begin
					i1Fmt = 1'b1; AluSrc = 1'b1;
					RegWrite = 1'b1; zeroExt = 1'b1;
				end
			5'b0_1011: 
				begin
					AluSrc = 1'b1; i1Fmt = 1'b1; 
					RegWrite = 1'b1; zeroExt = 1'b1;
				end
			/* I-format 1: roli, slli, rori, srli */
			5'b1_0100: 
				begin
					AluSrc = 1'b1; i1Fmt = 1'b1; RegWrite = 1'b1;
				end
			5'b1_0101: 
				begin
					AluSrc = 1'b1; RegWrite = 1'b1; i1Fmt = 1'b1; 
				end
			5'b1_0110: 
				begin
					AluSrc = 1'b1; RegWrite = 1'b1; i1Fmt = 1'b1; 
				end
			5'b1_0111:
				begin
					AluSrc = 1'b1; RegWrite = 1'b1; i1Fmt = 1'b1; 
				end
			/* I-format 1: st, ld, stu */
			5'b1_0000:
				begin
					AluSrc = 1'b1; i1Fmt = 1'b1;
					MemWrite = 1'b1; 
				end
			5'b1_0001: 
				begin
					MemRead = 1'b1; memToReg = 1'b1; i1Fmt = 1'b1;
					AluSrc = 1'b1; RegWrite = 1'b1;
				end
			5'b1_0011:
				begin
					RegWrite = 1'b1; i1Fmt = 1'b1;
					MemWrite = 1'b1; AluSrc = 1'b1;
				end
			/* R-format */
			5'b1_1001:
				begin
					RegWrite = 1'b1; RegDst = 1'b1;
				end
			5'b1_1011: 
				begin
					RegDst = 1'b1; RegWrite = 1'b1;
				end
			5'b1_1010:  
				begin
					RegDst = 1'b1; RegWrite = 1'b1;
				end
			5'b1_1100:
				begin
					RegDst = 1'b1; RegWrite = 1'b1;
				end
			5'b1_1101:
				begin
					RegDst = 1'b1; RegWrite = 1'b1;
				end
			5'b1_1110:
				begin
					RegDst = 1'b1; RegWrite = 1'b1;
				end
			5'b1_1111:
				begin
					RegDst = 1'b1; RegWrite = 1'b1;
				end
			/* I-format 2: beqz, bnez, bltz, bgez, lbi, slbi */
			5'b0_1100: 
				begin
					AluSrc = 1'b1; Branch = 1'b1;
				end
			5'b0_1101: 
				begin
					AluSrc = 1'b1; Branch = 1'b1;
				end
			5'b0_1110: 
				begin
					AluSrc = 1'b1; Branch = 1'b1;
				end
			5'b0_1111:
				begin
					AluSrc = 1'b1; Branch = 1'b1;
				end
			5'b1_1000: 
				begin
					RegWrite = 1'b1; AluSrc = 1'b1;
				end
			5'b1_0010: 
				begin
					RegWrite = 1'b1; zeroExt = 1'b1; AluSrc = 1'b1; 
				end

			/* J-format: j, jr, jal, jalr */
			5'b0_0100: 
				begin
					Jump = 1'b1;
				end
			5'b0_0101:
				begin
					Jump = 1'b1; AluSrc = 1'b1;
				end
			5'b0_0110: 
				begin
					Jump = 1'b1; RegWrite = 1'b1;
				end
			5'b0_0111:
				begin
					Jump = 1'b1; RegWrite = 1'b1; AluSrc = 1'b1;
				end
			/* siic */
			5'b0_0010:
				begin

				end
			/* nop */
			5'b0_0011: 
				begin

				end
			default:
				begin
					err = 1'b1; 
				end
		endcase
	end
endmodule
