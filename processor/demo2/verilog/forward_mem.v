module forward_mem(/* input */ MemWriteExMem, MemReadMemWb, writeRegExMem, writeRegMemWb
    /* output */ forwardC);
    assign forwardC = (MemWriteExMem & MemReadMemWb & (writeRegExMem == writeRegMemWb))? 1'b1: 1'b0;
    
endmodule
