
module forward_mem(/* input */ MemWriteExMem, MemReadMemWb, writeRegExMem, writeRegMemWb,
    writeRegValidExMem, writeRegValidMemWb,
    /* output */ forwardC);
    input MemWriteExMem, MemReadMemWb, writeRegValidExMem, writeRegValidMemWb;
    input [2:0] writeRegExMem, writeRegMemWb;
    output forwardC;

    assign forwardC = (MemWriteExMem & MemReadMemWb & writeRegValidExMem & writeRegValidMemWb &
        (writeRegExMem == writeRegMemWb))? 1'b1: 1'b0;
    
endmodule
