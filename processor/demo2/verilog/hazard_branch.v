module hazard_pc(/* input */ branchTake, jump,
        /* output */ flushIf, controlZeroIdEx, controlZeroExMem);
  
    /* Load-use */ 
    input branchTake, jump;
    
    output flushIf, controlZeroIdEx, controlZeroExMem; 

    wire isHazard;
    
    assign isHazard = brachTake | jump;

    assign flushIf = (isHazard) ? 1'b1 : 1'b0;
    assign controlZeroIdEx = (isHazard) ? 1'b1 : 1'b0;
    assign controlZeroExMem = (isHazard) ? 1'b1 : 1'b0;
endmodule
