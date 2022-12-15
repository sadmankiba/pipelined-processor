module dmemory(/* input */ MemWrite, MemRead, memAddr, writeData, 
    forwardC, memDataMemWb, HaltIn, errIn, clk, rst, 
    /*output */ readData, writeExMem, writeIdEx, writeIfId, writePc, controlZeroMemWb, err);

    input MemWrite, MemRead;
    input [15:0] memAddr, writeData, memDataMemWb;        
    input HaltIn, forwardC, errIn;
    input clk, rst;

    output [15:0] readData;
    output writeExMem, writeIdEx, writeIfId, writePc, controlZeroMemWb, err;

    wire Halt, Done, Stall, go, stallPipe, CacheHit;
    wire [15:0] memAddrFinal, writeDataFinal;

    assign writeDataFinal = (forwardC)? memDataMemWb: writeData; 

    /* Avoid odd address */
    assign memAddrFinal = (MemRead | MemWrite)? memAddr: 16'h0000;

    mem_system MEMD (.DataOut(readData), .Done(Done), .Stall(Stall), .CacheHit(CacheHit), .err(err), 
        .Addr(memAddrFinal), .DataIn(writeDataFinal), .Rd(MemRead), .Wr(MemWrite), 
        .createdump(Halt), .clk(clk), .rst(rst));

    // assign go = (~(MemRead | MemWrite)) | Done; 
    assign stallPipe = (MemRead | MemWrite) & (~Done);
    assign writeExMem = ~stallPipe;
    assign writeIdEx = ~stallPipe;
    assign writeIfId = ~stallPipe;
    assign writePc =  ~stallPipe;
    assign controlZeroMemWb = stallPipe;
    assign Halt = HaltIn | errIn | err;
endmodule
