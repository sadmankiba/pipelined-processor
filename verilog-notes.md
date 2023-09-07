# Notes

## Writing a Verilog Design

- First, draw or think of the schematic of the module. 
- Start thinking from highest level, gradually design internal components.
- What are the reusuable+atomic modules that you will make? How will you use these?
- Ultimately, everything will be built on basic logic gates. 

## Hardware Description Language (HDL)

- HDLs allow the user to describe, design, and test a circuit in software before
it is ever manufactured.

- HDLs vs conventional programming languages (such as C)?
  - Description of hardware rather than a sequence of commands
  - Verilog code is not sequential - all statements describe a single piece of logic
  - HDL describes a static circuit/hardware. There’s no starting point.

Examples: Verilog, VHDL, SystemVerilog etc.

## Verilog Coding Styles/ Coding Constructs

- RTL/Dataflow modelling
- Structural Modelling
- Behavioral Modelling

### RTL/Dataflow modelling

```v
module half_adder (X, Y, S, C);
    input X;
    input Y;
    output S;
    output C;
    assign C = X & Y;
    assign S = (X & ~Y) | (~X & Y);
    //assign S = X ^ Y; does the same thing
endmodule
```

### Structural modelling

This one is mostly used for writing design.

```v
module half_adder (X, Y, S, C);
    input X;
    input Y;
    output S;
    output C;
    wire w1,w2;
    //Sum
    and A0(w1,X,~Y);
    and A1(w2,~X,Y);
    or O1(S,w1,w2);
    //Carry
    and A2(C,X,Y);
endmodule
```

### Behavioral modelling

Generally used for writing testbench.

```v
module half_adder (X, Y, S, C);
    input X;
    input Y;
    output reg S; // using reg
    output reg C;
    always@(X,Y)
    begin
        if(X&Y)C = 1;
        else C = 0;
        
        if( (X&~Y) | (~X&Y)) S = 1;
        else S=0;
    end
endmodule
```


## Multi-bit data
range is inclusive. 

16 bit input/output
```v
input [15:0] In;
output [15:0] Out;
```

Use 8 bit
```v 
In[7:0]
```
## Run on CSL

```sh
# TB is foo_tb.v and RTL files are foo_0.v and foo_1.v
wsrun.pl foo_tb foo_tb.v foo_0.v foo_1.v
```

It performs three steps:
1. Compiles all verilog files
2. Runs verilog simulation according to testbench.
3. Creates a dump file to view waveforms.