module shifter_one_bit (In, ShAmt, Oper, Out);
   
  input [15:0] In;
  input ShAmt;
  input [1:0]  Oper;
  output [15:0] Out;

	wire [15:0] cmdLogic;

	mux4_1 CMD15(.InD(1'b0), .InC(In[15]), .InB(In[14]), .InA(In[14]), .S(Oper), .Out(cmdLogic[15]));
	mux2_1 BIT15(.InB(cmdLogic[15]),  .InA(In[15]), .S(ShAmt), .Out(Out[15]));

	mux2_1 CMD14(.InB(In[15]), .InA(In[13]), .S(Oper[1]), .Out(cmdLogic[14]));
	mux2_1 BIT14(.InB(cmdLogic[14]), .InA(In[14]), .S(ShAmt), .Out(Out[14]));
	
	mux2_1 CMD13(.InB(In[14]), .InA(In[12]), .S(Oper[1]), .Out(cmdLogic[13]));
	mux2_1 BIT13(.InB(cmdLogic[13]), .InA(In[13]), .S(ShAmt), .Out(Out[13]));
	
	mux2_1 CMD12(.InB(In[13]), .InA(In[11]), .S(Oper[1]), .Out(cmdLogic[12]));
	mux2_1 BIT12(.InB(cmdLogic[12]), .InA(In[12]), .S(ShAmt), .Out(Out[12]));
	
	mux2_1 CMD11(.InB(In[12]), .InA(In[10]), .S(Oper[1]), .Out(cmdLogic[11]));
	mux2_1 BIT11(.InB(cmdLogic[11]), .InA(In[11]), .S(ShAmt), .Out(Out[11]));
	
	mux2_1 CMD10(.InB(In[11]), .InA(In[9]), .S(Oper[1]), .Out(cmdLogic[10]));
	mux2_1 BIT10(.InB(cmdLogic[10]), .InA(In[10]), .S(ShAmt), .Out(Out[10]));
	
	mux2_1 CMD9 (.InB(In[10]), .InA(In[8]), .S(Oper[1]), .Out(cmdLogic[9]));
	mux2_1 BIT9 (.InB(cmdLogic[9]), .InA(In[9]),  .S(ShAmt), .Out(Out[9]));
	
	mux2_1 CMD8 (.InB(In[9]), .InA(In[7]), .S(Oper[1]), .Out(cmdLogic[8]));
	mux2_1 BIT8 (.InB(cmdLogic[8]),  .InA(In[8]),  .S(ShAmt), .Out(Out[8]));
	
	mux2_1 CMD7 (.InB(In[8]), .InA(In[6]), .S(Oper[1]), .Out(cmdLogic[7]));
	mux2_1 BIT7 (.InB(cmdLogic[7]),  .InA(In[7]),  .S(ShAmt), .Out(Out[7]));
	
	mux2_1 CMD6 (.InB(In[7]), .InA(In[5]), .S(Oper[1]), .Out(cmdLogic[6]));
	mux2_1 BIT6 (.InB(cmdLogic[6]),  .InA(In[6]),  .S(ShAmt), .Out(Out[6]));
	
	mux2_1 CMD5 (.InB(In[6]), .InA(In[4]), .S(Oper[1]), .Out(cmdLogic[5]));
	mux2_1 BIT5 (.InB(cmdLogic[5]),  .InA(In[5]),  .S(ShAmt), .Out(Out[5]));
	
	mux2_1 CMD4 (.InB(In[5]), .InA(In[3]), .S(Oper[1]), .Out(cmdLogic[4]));
	mux2_1 BIT4 (.InB(cmdLogic[4]),  .InA(In[4]),  .S(ShAmt), .Out(Out[4]));
	
	mux2_1 CMD3 (.InB(In[4]), .InA(In[2]), .S(Oper[1]), .Out(cmdLogic[3]));
	mux2_1 BIT3 (.InB(cmdLogic[3]),  .InA(In[3]),  .S(ShAmt), .Out(Out[3]));
	
	mux2_1 CMD2 (.InB(In[3]), .InA(In[1]), .S(Oper[1]), .Out(cmdLogic[2]));
	mux2_1 BIT2 (.InB(cmdLogic[2]),  .InA(In[2]),  .S(ShAmt), .Out(Out[2]));
	
	mux2_1 CMD1 (.InB(In[2]), .InA(In[0]), .S(Oper[1]), .Out(cmdLogic[1]));
	mux2_1 BIT1 (.InB(cmdLogic[1]),  .InA(In[1]),  .S(ShAmt), .Out(Out[1]));
	
	mux4_1 CMD0 (.InD(In[1]), .InC(In[1]), .InB(1'b0), .InA(In[15]), .S(Oper), .Out(cmdLogic[0]));
	mux2_1 BIT0 (.InB(cmdLogic[0]),  .InA(In[0]),  .S(ShAmt), .Out(Out[0]));

endmodule
