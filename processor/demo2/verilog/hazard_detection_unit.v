module hazard_detection_unit(/* input */ MemReadIdEx, writeRegIdEx, RsIfId, RtIfId,
        writeRegValidIdEx, RsValidIfId, RtValidIfId,
        /* output */ PCWrite, IfIdWrite, controlZero);
  
    /* Load-use */ 
    input MemReadIdEx;
    input [2:0] writeRegIdEx, RsIfId, RtIfId;
    input writeRegValidIdEx, RsValidIfId, RtValidIfId;
    
    output PCWrite, IfIdWrite, controlZero; 
    
    assign isHazard = MemReadIdEx && 
            (((writeRegIdEx == RsIfId) & writeRegValidIdEx & RsValidIfId) || 
            ((writeRegIdEx == RtIfId) & writeRegValidIdEx & RtValidIfId));

    assign PCWrite = (isHazard) ? 1'b0 : 1'b1;
    assign IfIdWrite  = (isHazard) ? 1'b0 : 1'b1;
    assign controlZero = (isHazard) ? 1'b1 : 1'b0;
endmodule
