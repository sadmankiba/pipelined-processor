// jalr test 2
// This test has jalr jumping to an ealier part of the program and sets r7 to 0xa
lbi r0, 0x0            // r0 used for jump address calculation
lbi r1, 0xfd        // r1 acts as a loop counter
lbi r4, 12
addi r1, r1, 0x01
slbi r4, 98
bgez r1, .done        //after 3 total executions of add, go to halt
jalr r0, 0x4
.done:
halt