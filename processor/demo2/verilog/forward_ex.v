module forward_ex(/* input */ RegWriteExMem,  RegWriteMemWb, MemReadMemWb,
    MemReadExMem, RsIdEx, RtIdEx, RdExMem, RdMemWb, RsExMem,
    /* output */ forwardA, forwardB );
    /*
    forwardA (Rs / ALU inp 1) - 00: Original, 01: Mem.aluRes, 10: Ex.aluRes, 11: Mem.memData 
    forwardB (Rt / ALU inp 2) - 00: Original, 01: Mem.aluRes, 10: Ex.aluRes, 11: Mem.memData  
    */
   
    input [2:0] RdExMem, RdMemWb, RsIdEx, RtIdEx, RsExMem;
    input RegWriteExMem, RegWriteMemWb, MemReadExMem, MemReadMemWb;
    
    output [1:0] forwardA, forwardB;

    // EX hazard
    wire exFrwdA, exFrwdB;
    assign exFrwdA = (RegWriteExMem & (RsIdEx == RdExMem) ) ? 1 : 0;
    assign exFrwdB = (RegWriteExMem & (RtIdEx == RdExMem) ) ? 1 : 0;
    
    // MEM hazard
    wire memFrwdA, memFrwdB;
    assign memFrwdA = (RegWriteMemWb & (RsIdEx == RdMemWb)) ? 1 : 0;
    assign memFrwdB = (RegWriteMemWb & (RtIdEx == RdMemWb)) ? 1 : 0;

    // Load-use forward
    wire loadUseFrwdA;
    assign loadUseFrwdA = (MemReadMemWb & (RsIdEx == RdMemWb)) ? 1 : 0;
    assign loadUseFrwdB = (MemReadMemWb & (RtIdEx == RdMemWb)) ? 1 : 0;
    
    wire [1:0] forwardAMem, forwardAMemLd, forwardAExMem;
    assign forwardAMem = memFrwdA? 2'b01: 2'b00;
    assign forwardAMemLd = loadUseFrwdA? 2'b11: forwardAMem;
    assign forwardAExMem = exFrwdA? 2'b10: forwardAMemLd;
    assign forwardA = forwardAExMem;

    wire [1:0] forwardBMem, forwardBMemLd, forwardBExMem;
    assign forwardBMem = memFrwdB? 2'b01: 2'b00;
    assign forwardBMemLd = loadUseFrwdB? 2'b11: forwardBLdUse;
    assign forwardBExMem = exFrwdB? 2'b10: forwardBMemLd;
    assign forwardB = forwardBExMem;

endmodule
