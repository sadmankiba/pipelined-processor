module dmemory(/* input */ MemWrite, MemRead, memAddr, writeData, 
    forwardC, memDataMemWb, HaltIn, errIn, clk, rst, 
    /*output */ readData, writeExMem, writeIdEx, writeIfId, writePc, controlZeroMemWb, err);

    input MemWrite, MemRead;
    input [15:0] memAddr, writeData, memDataMemWb;        
    input HaltIn, forwardC, errIn;
    input clk, rst;

    output [15:0] readData;
    output writeExMem, writeIdEx, writeIfId, writePc, controlZeroMemWb, err;

    wire Halt, Done, Stall, go, CacheHit;
    wire [15:0] writeDataFinal;

    assign writeDataFinal = (forwardC)? memDataMemWb: writeData; 

    stallmem MEMD (.DataOut(readData), .Done(Done), .Stall(Stall), .CacheHit(CacheHit), .err(err), 
        .Addr(memAddr), .DataIn(writeDataFinal), .Rd(MemRead), .Wr(MemWrite), 
        .createdump(Halt), .clk(clk), .rst(rst));

    assign go = (~rst) & (~Stall); // or, go = (~(MemRead | MemWrite)) | Done
    assign writeExMem = go;
    assign writeIdEx = go;
    assign writeIfId = go;
    assign writePc =  go;
    assign controlZeroMemWb = ~go;
    assign Halt = HaltIn | errIn | err;
endmodule
