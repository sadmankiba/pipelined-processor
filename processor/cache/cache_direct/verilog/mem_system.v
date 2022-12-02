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


    wire [1:0] stateRegOut, stateRegIn;
    wire [3:0] stateRegDOut;
    wire isWaitForReq, isMemWait, isReadC1, isReadDone;
    wire waitReqIn, memWaitIn, readC1In, readDoneIn;
    
    wire [1:0] bank;
    wire memStall;
    wire [3:0] memBusy;

    /*
    State register:
    0- WaitForRequest, 1- MemWait, 2- ReadCycle1, 3- ReadDone
    */
    dff STATEREG [1:0] (.q(stateRegOut), .d(stateRegIn), .clk(clk), .rst(rst));
    
    decoder2_4 DCDST(.in(stateRegOut), .out(stateRegDOut));
    assign isWaitForReq = stateRegDOut[0];
    assign isMemWait = stateRegDOut[1];
    assign isReadC1 = stateRegDOut[2];
    assign isReadDone = stateRegDOut[3];
    
    assign bank = Addr[2:1];
    mux4_1 BNBS (.InD(memBusy[3]),  .InC(memBusy[2]), .InB(memBusy[1]), .InA(memBusy[0]),   
            .S(bank), .Out(bankBusy));
    
    assign Stall = isMemWait | isReadC1 | isReadDone;
    assign Done = (Rd & isReadDone) | (Wr & (~bankBusy) & isWaitForReq);
    assign CacheHit = 0;
    
    assign memWaitIn = (isWaitForReq | isMemWait) & bankBusy;
    assign readC1In = (isMemWait | isWaitForReq) & Rd & (~bankBusy);
    assign readDoneIn = isReadC1;
    assign waitReqIn = isReadDone | ((~bankBusy) & Wr);

     
    encoder4_2 ECDST(.in({readDoneIn, readC1In, memWaitIn , waitReqIn}), .out(stateRegIn));


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
