/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

module mem_system(/*AUTOARG*/
    // Outputs
    DataOut, Done, Stall, CacheHit, err,
    // Inputs
    Addr, DataIn, Rd, Wr, createdump, clk, rst
    );
    
    input [15:0] Addr;
    input [15:0] DataIn;
    input        Rd;
    input        Wr;
    input        createdump;
    input        clk;
    input        rst;
    
    output [15:0] DataOut;
    output Done;
    output Stall;
    output CacheHit;
    output err;


    wire [3:0] StateRegOut, StateRegIn;
    wire [7:0] StateRegDOut;
    wire isIdle, isMemWait, isRdIs, isRd1, isRdOut, isWrIs;
    wire [3:0] memBusy;

    /*
    State register:
    0- Idle, 1- MemWait, 2- ReadIssue, 
    3- Read1Cycle, 4- ReadOut, 5- WriteIssue
    */
    dff STATEREG [2:0] (.q(StateRegOut), .d(StateRegIn), .clk(clk), .rst(rst));
    
    decoder3_8 DCDST(.in(StateRegOut), .out(StateRegDOut));
    isIdle = StateRegDOut[0];
    isMemWait = StateRegDOut[1];
    isRdIs = StateRegDOut[2];
    isRd1 = StateRegDOut[3];
    isRdOut = StateRegDOut[4];
    isWrIs = StateRegDOut[5];

    Stall = isMemWait | isRdIs | isRd1 | isRdOut | isWrIs;
    MemWaitIn = isIdle & (Rd | Wr);
    encoder8_3 ECDST(.in({0, MemWaitIn, 6b'000000 }), .out(StateRegIn));


    /* data_mem = 1, inst_mem = 0 *
        * needed for cache parameter */
    parameter memtype = 0;
    cache #(0 + memtype) c0(// Outputs
                            .tag_out              (),
                            .data_out             (),
                            .hit                  (),
                            .dirty                (),
                            .valid                (),
                            .err                  (),
                            // Inputs
                            .enable               (),
                            .clk                  (),
                            .rst                  (),
                            .createdump           (),
                            .tag_in               (),
                            .index                (),
                            .offset               (),
                            .data_in              (),
                            .comp                 (),
                            .write                (),
                            .valid_in             ());
    
    four_bank_mem mem(// Outputs
                        .data_out          (DataOut),
                        .stall             (),
                        .busy              (memBusy),
                        .err               (err),
                        // Inputs
                        .clk               (),
                        .rst               (),
                        .createdump        (),
                        .addr              (),
                        .data_in           (),
                        .wr                (),
                        .rd                ());

    
    // your code here

    
endmodule // mem_system

// DUMMY LINE FOR REV CONTROL :9:
