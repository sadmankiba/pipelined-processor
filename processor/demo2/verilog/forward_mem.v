
module forward_mem(/* input */ MemWriteExMem, MemReadMemWb, writeRegExMem, writeRegMemWb,
    writeRegValidExMem, writeRegValidMemWb,
    /* output */ forwardC);
    input MemWriteExMem, MemReadMemWb, writeRegExMem, writeRegMemWb, writeRegValidExMem, writeRegValidMemWb;
    output forwardC;

    assign forwardC = (MemWriteExMem & MemReadMemWb & writeRegValidExMem & writeRegValidMemWb &
        (writeRegExMem == writeRegMemWb))? 1'b1: 1'b0;
    
endmodule
