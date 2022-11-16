module forward_mem(/* input */ MemWriteExMem, MemReadMemWb, RdExMem, RdMemWb
    /* output */ forwardC);
    assign forwardC = (MemWriteExMem & MemReadMemWb & (RdExMem == RdMemWb))? 1'b1: 1'b0;
    
endmodule
