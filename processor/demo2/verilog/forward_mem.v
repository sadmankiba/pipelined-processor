
module forward_mem(/* input */ MemWriteExMem, MemReadMemWb, RtExMem, writeRegMemWb,
    RtValidExMem, writeRegValidMemWb,
    /* output */ forwardC);
    // not used
    input MemWriteExMem, MemReadMemWb, RtValidExMem, writeRegValidMemWb;
    input [2:0] RtExMem, writeRegMemWb;
    output forwardC;

    assign forwardC = (MemWriteExMem & MemReadMemWb & RtValidExMem & writeRegValidMemWb &
        (RtExMem == writeRegMemWb))? 1'b1: 1'b0;
    
endmodule
