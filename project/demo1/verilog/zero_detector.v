module zero_detector(In, Z, ltz);

	input [15:0] In;
  output ltz;
	output Z;

	assign Z = ~|In; 
  assign ltz = (In[15] == 1) ? 1'b1 : 1'b0;

endmodule
