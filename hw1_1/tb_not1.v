//~ `New testbench
`timescale  1ns / 1ps

module tb_not1;

// not1 Parameters
parameter PERIOD  = 10;


// not1 Inputs
reg   in1                                  = 0 ;

// not1 Outputs
wire  out                                  ;

reg clk;
reg rst_n;

initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

not1  u_not1 (
    .in1                     ( in1   ),

    .out                     ( out   )
);

initial
begin

    $finish;
end

endmodule