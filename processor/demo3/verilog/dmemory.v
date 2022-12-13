module dmemory(/* input */ MemWrite, MemRead, memAddr, writeData, 
    forwardC, memDataMemWb, HaltIn, errIn, clk, rst, 
    /*output */ readData, writeExMem, writeIdEx, err);

    input MemWrite, MemRead;
    input [15:0] memAddr, writeData, memDataMemWb;        
    input HaltIn, forwardC, errIn;
    input clk, rst;

    output [15:0] readData;
    output writeExMem, writeIdEx, err;

    wire memEnable, Halt, Done, Stall, CacheHit;
    wire [15:0] writeDataFinal;

    assign memEnable = (MemRead | MemWrite) & (~Halt);
    assign writeDataFinal = (forwardC)? memDataMemWb: writeData; 

    // stallmem MEMD (.DataOut(readData), .Done(Done), .Stall(Stall), .CacheHit(CacheHit), .err(err), 
    //     .Addr(memAddr), .DataIn(writeDataFinal), .Rd(MemRead), .Wr(MemWrite), 
    //     .createdump(Halt), .clk(clk), .rst(rst));

    memory2c_align MEMD(.data_out(readData), .data_in(writeDataFinal), .addr(memAddr), .enable(memEnable), 
            .wr(MemWrite), .createdump(Halt), .clk(clk), .rst(rst), .err(err));  

    assign Done = 1'b1;
    assign writeExMem = Done;
    assign writeIdEx = Done;
    assign Halt = HaltIn | errIn | err;
endmodule
