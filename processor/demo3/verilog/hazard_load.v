module hazard_load(/* input */ MemReadIdEx, writeRegIdEx, RsIfId, RtIfId,
        writeRegValidIdEx, RsValidIfId, RtValidIfId,
        /* output */ writePc, writeIfId, controlZeroIdEx);
  
    /* Load-use */ 
    input MemReadIdEx;
    input [2:0] writeRegIdEx, RsIfId, RtIfId;
    input writeRegValidIdEx, RsValidIfId, RtValidIfId;
    
    output writePc, writeIfId, controlZeroIdEx; 
    
    assign isHazard = MemReadIdEx &
            (((writeRegIdEx == RsIfId) & writeRegValidIdEx & RsValidIfId) | 
            ((writeRegIdEx == RtIfId) & writeRegValidIdEx & RtValidIfId));

    assign writePc = (isHazard) ? 1'b0 : 1'b1;
    assign writeIfId  = (isHazard) ? 1'b0 : 1'b1;
    assign controlZeroIdEx = (isHazard) ? 1'b1 : 1'b0;
endmodule
