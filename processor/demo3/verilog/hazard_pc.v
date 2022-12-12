module hazard_pc(/* input */ branchTake, Jump,
        /* output */ flushIf, controlZeroIdEx, controlZeroExMem);
  
    /* Load-use */ 
    input branchTake, Jump;
    
    output flushIf, controlZeroIdEx, controlZeroExMem; 

    wire isHazard;
    
    assign isHazard = branchTake | Jump;

    assign flushIf = (isHazard) ? 1'b1 : 1'b0;
    assign controlZeroIdEx = (isHazard) ? 1'b1 : 1'b0;
    assign controlZeroExMem = (isHazard) ? 1'b1 : 1'b0;
endmodule
