module dmemory(/* input */ MemWrite, MemRead, memAddr, writeData, 
    forwardC, memDataMemWb, HaltIn, errIn, clk, rst, 
    /*output */ readData, err);

    input MemWrite, MemRead;
    input [15:0] memAddr, writeData, memDataMemWb;        
    input HaltIn, forwardC, errIn;
    input clk, rst;

    output [15:0] readData;
    output err;

    wire memEnable, Halt;
    wire [15:0] writeDataFinal;

    assign memEnable = (MemRead | MemWrite) & (~Halt);
    assign writeDataFinal = (forwardC)? memDataMemWb: writeData; 

    memory2c_align MEMD(.data_out(readData), .data_in(writeDataFinal), .addr(memAddr), .enable(memEnable), 
            .wr(MemWrite), .createdump(Halt), .clk(clk), .rst(rst), .err(err));  

    assign Halt = HaltIn | errIn | err;
endmodule
