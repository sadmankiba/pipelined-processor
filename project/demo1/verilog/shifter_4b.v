module shifter_4b (In, ShAmt, Oper, Out);
   
  	input [15:0] In;
  	input ShAmt;
  	input [1:0]  Oper;
  	output [15:0] Out;
	wire [15:0]  shOut;
	
	mux4_1 OP0 (.InD(In[4]), .InC(In[4]), .InB(1'b0), .InA(In[12]), .S(Oper), .Out(shOut[0]));
	mux2_1 POS0 (.InB(shOut[0]), .InA(In[0]), .S(ShAmt), .Out(Out[0]));
	
	mux4_1 OP1 (.InD(In[5]), .InC(In[5]), .InB(1'b0), .InA(In[13]), .S(Oper), .Out(shOut[1]));
	mux2_1 POS1 (.InB(shOut[1]), .InA(In[1]),  .S(ShAmt), .Out(Out[1]));
	
	mux4_1 OP2 (.InD(In[6]), .InC(In[6]), .InB(1'b0), .InA(In[14]), .S(Oper), .Out(shOut[2]));
	mux2_1 POS2 (.InB(shOut[2]), .InA(In[2]),  .S(ShAmt), .Out(Out[2]));
	
	mux4_1 OP3 (.InD(In[7]), .InC(In[7]), .InB(1'b0), .InA(In[15]), .S(Oper), .Out(shOut[3]));
	mux2_1 POS3 (.InB(shOut[3]), .InA(In[3]),  .S(ShAmt), .Out(Out[3]));
	
	mux2_1 OP4 (.InB(In[8]), .InA(In[0]), .S(Oper[1]), .Out(shOut[4]));
	mux2_1 POS4 (.InB(shOut[4]), .InA(In[4]),  .S(ShAmt), .Out(Out[4]));
	
	mux2_1 OP5 (.InB(In[9]), .InA(In[1]), .S(Oper[1]), .Out(shOut[5]));
	mux2_1 POS5 (.InB(shOut[5]), .InA(In[5]),  .S(ShAmt), .Out(Out[5]));
	
	mux2_1 OP6 (.InB(In[10]), .InA(In[2]), .S(Oper[1]), .Out(shOut[6]));
	mux2_1 POS6 (.InB(shOut[6]), .InA(In[6]),  .S(ShAmt), .Out(Out[6]));
	
	mux2_1 OP7 (.InB(In[11]), .InA(In[3]), .S(Oper[1]), .Out(shOut[7]));
	mux2_1 POS7 (.InB(shOut[7]), .InA(In[7]),  .S(ShAmt), .Out(Out[7]));
	
	mux2_1 OP8 (.InB(In[12]), .InA(In[4]), .S(Oper[1]), .Out(shOut[8]));
	mux2_1 POS8 (.InB(shOut[8]), .InA(In[8]),  .S(ShAmt), .Out(Out[8]));
	
	mux2_1 OP9 (.InB(In[13]), .InA(In[5]), .S(Oper[1]), .Out(shOut[9]));
	mux2_1 POS9 (.InB(shOut[9]), .InA(In[9]),  .S(ShAmt), .Out(Out[9]));
	
	mux2_1 OP10(.InB(In[14]), .InA(In[6]), .S(Oper[1]), .Out(shOut[10]));
	mux2_1 POS10(.InB(shOut[10]), .InA(In[10]), .S(ShAmt), .Out(Out[10]));
	
	mux2_1 OP11(.InB(In[15]), .InA(In[7]), .S(Oper[1]), .Out(shOut[11]));
	mux2_1 POS11(.InB(shOut[11]), .InA(In[11]), .S(ShAmt), .Out(Out[11]));
	
	mux4_1 OP12(.InD(1'b0), .InC(In[15]), .InB(In[8]), .InA(In[8]), .S(Oper), .Out(shOut[12]));
	mux2_1 POS12(.InB(shOut[12]), .InA(In[12]), .S(ShAmt), .Out(Out[12]));
	
	mux4_1 OP13(.InD(1'b0), .InC(In[15]), .InB(In[9]), .InA(In[9]), .S(Oper), .Out(shOut[13]));
	mux2_1 POS13(.InB(shOut[13]), .InA(In[13]), .S(ShAmt), .Out(Out[13]));
	
	mux4_1 OP14(.InD(1'b0), .InC(In[15]), .InB(In[10]), .InA(In[10]), .S(Oper), .Out(shOut[14]));
	mux2_1 POS14(.InB(shOut[14]), .InA(In[14]), .S(ShAmt), .Out(Out[14]));
	
	mux4_1 OP15(.InD(1'b0), .InC(In[15]), .InB(In[11]), .InA(In[11]), .S(Oper), .Out(shOut[15]));
	mux2_1 POS15(.InB(shOut[15]), .InA(In[15]), .S(ShAmt), .Out(Out[15]));  
endmodule
