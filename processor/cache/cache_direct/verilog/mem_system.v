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
    wire isWaitForReq, isMemWait, isReadC1;
    
    wire bank;
    wire memStall;
    wire [3:0] memBusy;

    /*
    State register:
    0- WaitForRequest, 1- MemWait, 2- ReadCycle1
    */
    dff STATEREG [1:0] (.q(StateRegOut), .d(StateRegIn), .clk(clk), .rst(rst));
    
    decoder4_2 DCDST(.in(StateRegOut), .out(StateRegDOut));
    isWaitForReq = StateRegDOut[0];
    isMemWait = StateRegDOut[1];
    isReadC1 = StateRegDOut[2];
    
    assign bank = Addr[2:1];
    mux4_1 BNBS (.InA(memBusy[0]), .InB(memBusy[1]), .InC(memBusy[2]), .InD(memBusy[3]), 
            .S(bank), .Out(bankBusy));
    
    Stall = isMemWait | isReadC1;
    Done = ~bankBusy & isWaitForReq & (Rd | Wr);
    
    MemWaitIn = (isWaitForReq | isMemWait) & bankBusy;
    ReadC1In = isMemWait & (~bankBusy) & Rd;
    WaitReqIn = (~bankBusy & Wr);

     
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
                        .stall             (memStall),
                        .busy              (memBusy),
                        .err               (err),
                        // Inputs
                        .clk               (clk),
                        .rst               (rst),
                        .createdump        (createdump),
                        .addr              (Addr),
                        .data_in           (DataIn),
                        .wr                (Wr),
                        .rd                (Rd));

    
    // your code here

    
endmodule // mem_system

// DUMMY LINE FOR REV CONTROL :9:
