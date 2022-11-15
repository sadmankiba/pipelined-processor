module control(/* input */ opcode, validIns,
	/* output */ regDst, aluSrc, aluOp, branch, MemRead, memWrite,
               jump, memToReg, regWrite, halt, zeroExt, i1Fmt, err);

	input [4:0] opcode;
	input validIns;

	output reg regDst, aluSrc, branch, MemRead, memWrite, jump, memToReg, regWrite;         
	output reg halt, zeroExt, i1Fmt, err;
	output [4:0] aluOp;    

	wire newOpc; 

	assign aluOp = opcode;
	
	mux2_1 MV [4:0] (.InA(5'b0_0001), .InB(opcode), .S(validIns), .Out(newOpc));

	always @(newOpc)
	begin
		regDst   = 1'b0; /* Whether Write Register is Ins[7:5] or  Ins [4:2] */ 
		aluSrc   = 1'b0; regWrite = 1'b0; 		
		branch   = 1'b0; MemRead  = 1'b0; memWrite = 1'b0; 
		memToReg = 1'b0; jump     = 1'b0; 
		halt     = 1'b0; zeroExt = 1'b0; 
		i1Fmt = 1'b0; 
		case(newOpc)
			/* halt, nop */
			5'b0_0000: 	
				begin
					// halt = 1'b1;
				end
			5'b0_0001: 
				begin
				end
			/* I-format 1: addi, subi, xori, andni*/
			5'b0_1000: 
				begin
					aluSrc = 1'b1; regWrite = 1'b1; i1Fmt = 1'b1; 	
				end
			5'b0_1001: 
				begin
					aluSrc = 1'b1; regWrite = 1'b1; i1Fmt = 1'b1; 
				end
			5'b0_1010: 
				begin
					i1Fmt = 1'b1; aluSrc = 1'b1;
					regWrite = 1'b1; zeroExt = 1'b1;
				end
			5'b0_1011: 
				begin
					aluSrc = 1'b1; i1Fmt = 1'b1; 
					regWrite = 1'b1; zeroExt = 1'b1;
				end
			/* I-format 1: roli, slli, rori, srli */
			5'b1_0100: 
				begin
					aluSrc = 1'b1; i1Fmt = 1'b1; regWrite = 1'b1;
				end
			5'b1_0101: 
				begin
					aluSrc = 1'b1; regWrite = 1'b1; i1Fmt = 1'b1; 
				end
			5'b1_0110: 
				begin
					aluSrc = 1'b1; regWrite = 1'b1; i1Fmt = 1'b1; 
				end
			5'b1_0111:
				begin
					aluSrc = 1'b1; regWrite = 1'b1; i1Fmt = 1'b1; 
				end
			/* I-format 1: st, ld, stu */
			5'b1_0000:
				begin
					aluSrc = 1'b1; i1Fmt = 1'b1;
					memWrite = 1'b1; MemRead = 1'b1; memToReg = 1'b1;
				end
			5'b1_0001: 
				begin
					MemRead = 1'b1; memToReg = 1'b1; i1Fmt = 1'b1;
					aluSrc = 1'b1; regWrite = 1'b1;
				end
			5'b1_0011:
				begin
					regWrite = 1'b1; i1Fmt = 1'b1;
					memWrite = 1'b1; MemRead = 1'b1; aluSrc = 1'b1;
				end
			/* R-format */
			5'b1_1001:
				begin
					regWrite = 1'b1; regDst = 1'b1;
				end
			5'b1_1011: 
				begin
					regDst = 1'b1; regWrite = 1'b1;
				end
			5'b1_1010:  
				begin
					regDst = 1'b1; regWrite = 1'b1;
				end
			5'b1_1100:
				begin
					regDst = 1'b1; regWrite = 1'b1;
				end
			5'b1_1101:
				begin
					regDst = 1'b1; regWrite = 1'b1;
				end
			5'b1_1110:
				begin
					regDst = 1'b1; regWrite = 1'b1;
				end
			5'b1_1111:
				begin
					regDst = 1'b1; regWrite = 1'b1;
				end
			/* I-format 2: beqz, bnez, bltz, bgez, lbi, slbi */
			5'b0_1100: 
				begin
					aluSrc = 1'b1; branch = 1'b1;
				end
			5'b0_1101: 
				begin
					aluSrc = 1'b1; branch = 1'b1;
				end
			5'b0_1110: 
				begin
					aluSrc = 1'b1; branch = 1'b1;
				end
			5'b0_1111:
				begin
					aluSrc = 1'b1; branch = 1'b1;
				end
			5'b1_1000: 
				begin
					regWrite = 1'b1; aluSrc = 1'b1;
				end
			5'b1_0010: 
				begin
					regWrite = 1'b1; zeroExt = 1'b1; aluSrc = 1'b1; 
				end

			/* J-format: j, jr, jal, jalr */
			5'b0_0100: 
				begin
					jump = 1'b1;
				end
			5'b0_0101:
				begin
					jump = 1'b1; aluSrc = 1'b1;
				end
			5'b0_0110: 
				begin
					jump = 1'b1; regWrite = 1'b1;
				end
			5'b0_0111:
				begin
					jump = 1'b1; regWrite = 1'b1; aluSrc = 1'b1;
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
