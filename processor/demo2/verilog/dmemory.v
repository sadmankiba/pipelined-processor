module dmemory(/* input */ MemWrite, MemRead, memAddr, writeData, 
    forwardC, memDataMemWb, halt, clk, rst, 
    /*output */ readData);

    input MemWrite, MemRead;
    input [15:0] memAddr, writeData, memDataMemWb;        
    input halt, forwardC;
    input clk, rst;

    output [15:0] readData;

    wire memEnable;
    wire [15:0] writeDataFinal;

    assign memEnable = (MemRead | MemWrite) & (~halt);
    assign writeDataFinal = (forwardC)? memDataMemWb: writeData; 

    memory2c MEMD(.data_out(readData), .data_in(writeDataFinal), .addr(memAddr), .enable(memEnable), 
            .wr(MemWrite), .createdump(halt), .clk(clk), .rst(rst));  
endmodule
