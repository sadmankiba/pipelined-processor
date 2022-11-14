module dmemory(memWrite, MemRead, aluRes, writedata, halt, clk, rst, readData);

    input memWrite, MemRead;
    input [15:0] aluRes, writedata;        
    input halt;
    input clk, rst;

    output [15:0] readData;

    wire memEnable;
    wire [15:0] aluResult, writeData;

    assign memEnable = MemRead & (~halt);
    
    mux2_1_16b MXAD(.InA(writedata), .InB(aluRes), .S(MemRead), .Out(aluResult));
    mux2_1_16b MXW(.InA(aluRes), .InB(writedata), .S(MemRead), .Out(writeData));

    memory2c MEMD(.data_out(readData), .data_in(writeData), .addr(aluResult), .enable(memEnable), 
            .wr(memWrite), .createdump(halt), .clk(clk), .rst(rst));  
endmodule
