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

    /* cache controller */
    wire [2:0] stateRegOut, stateRegIn;
    wire [8:0] stateRegDOut;
    wire isWaitForReq, isRead, isReadC1, isAllocate, isWrite,
        isCompareTag;
    wire bankBusy, readBankNBusy, isRBNZero;
    wire writeDoneIn, writeDone;
    wire waitReqIn, readIn, readC1In, allocateIn, compareTagIn, writeIn;
    
    /* mem/cache */
    wire cDataIn;
    wire [1:0] cOffsetIn;
    wire cWriteIn, cEnable, cValidIn;
    wire cHit, cDirty, cValid, cErr, cHitAndValid;
    wire [4:0] cTagIn, cTagOut;

    wire [15:0] memDataOut, memAddrIn;
    wire [1:0] bank, readBankNIn, readBankN;
    wire memStall, memErr;
    wire [3:0] memBusy;

    /*
    State register:
    0- WaitForRequest, 1- Read, 2- ReadCycle1, 3- Allocate,
    4- Write, 5- CompareTag
    */
    dff STATEREG [2:0] (.q(stateRegOut), .d(stateRegIn), .clk(clk), .rst(rst));
    
    /* Get current state */
    decoder3_8 DCDST(.in(stateRegOut), .out(stateRegDOut));
    assign isWaitForReq = stateRegDOut[0];
    assign isRead = stateRegDOut[1];
    assign isReadC1 = stateRegDOut[2];
    assign isAllocate = stateRegDOut[3];
    assign isWrite = stateRegDOut[4];
    assign isCompareTag = stateRegDOut[5];

    /* Get mem output */
    assign bank = Addr[2:1];
    mux4_1 BNBS (.InD(memBusy[3]),  .InC(memBusy[2]), .InB(memBusy[1]), .InA(memBusy[0]),   
            .S(bank), .Out(bankBusy));

    /* Get/set mem system registers */
    assign readBankNIn = isReadC1? (readBankNIn + 1) : readBankN;
    dff RBANKN [1:0] (.q(readBankN), .d(readBankNIn), .clk(clk), .rst(rst));
    mux4_1 BNNBS (.InD(memBusy[3]),  .InC(memBusy[2]), .InB(memBusy[1]), .InA(memBusy[0]),   
            .S(readBankN), .Out(readBankNBusy));
    assign isRBNZero = ~|readBankN;

    assign cHitAndValid = cHit & cValid;
    assign readDoneIn = isWaitForReq? 1'b0: (isCompareTag & cHitAndValid);
    dff RDDONE (.q(readDone), .d(readDoneIn), .clk(clk), .rst(rst));

    assign writeDoneIn = isWaitForReq? 1'b0: isWrite & (~bankBusy);
    dff WRDONE (.q(writeDone), .d(writeDoneIn), .clk(clk), .rst(rst));
    
    /* Set mem/cache input */
    assign memAddrIn = (Wr)? Addr: {Addr[15:3], readBankN, 1'b0};
    assign cDataIn = (isCompareTag & Wr)? DataIn: memDataOut;
    assign cOffsetIn = (isAllocate)? {readBankN, 1'b0} : Addr[2:0];
    assign cWriteIn = isAllocate | (isCompareTag & Wr);
    assign cValidIn = isAllocate;
    assign cEnable = ~rst;

    /* Set mem system output signals */
    assign Stall = isCompareTag | isRead | isReadC1 | isAllocate | isWrite;
    assign Done = readDone | writeDone;
    assign CacheHit = cHitAndValid & Rd;
    assign err = cErr | memErr;
    
    /* Set next state */
    assign waitReqIn = (isCompareTag & cHitAndValid & Rd) | (isWrite & (~bankBusy));
    assign compareTagIn = (isWaitForReq & (~readDone) & (~writeDone)) 
            | (isAllocate & isRBNZero);
    assign readIn = (isCompareTag & Rd & (~cHitAndValid)) | (isRead & readBankNBusy)
            | (isAllocate & (~isRBNZero));
    assign readC1In = isRead & (~readBankNBusy);
    assign allocateIn = isReadC1;
    assign writeIn = (isCompareTag & Wr) | (isWrite & bankBusy);
     
    encoder8_3 ECDST(.in({2'b00, compareTagIn, writeIn, allocateIn, 
        readC1In, readIn , waitReqIn}), 
        .out(stateRegIn));


    /* data_mem = 1, inst_mem = 0 *
        * needed for cache parameter */
    parameter memtype = 0;
    cache #(0 + memtype) c0(// Outputs
                            .tag_out              (cTagOut),
                            .data_out             (DataOut),
                            .hit                  (cHit),
                            .dirty                (cDirty),
                            .valid                (cValid),
                            .err                  (cErr),
                            // Inputs
                            .enable               (cEnable),
                            .clk                  (clk),
                            .rst                  (rst),
                            .createdump           (createdump),
                            .tag_in               (Addr[15:11]),
                            .index                (Addr[10:3]),
                            .offset               (cOffsetIn),
                            .data_in              (cDataIn),
                            .comp                 (isCompareTag),
                            .write                (cWriteIn),
                            .valid_in             (cValidIn));
    
    four_bank_mem mem(// Outputs
                        .data_out          (memDataOut),
                        .stall             (memStall),
                        .busy              (memBusy),
                        .err               (memErr),
                        // Inputs
                        .clk               (clk),
                        .rst               (rst),
                        .createdump        (createdump),
                        .addr              (memAddrIn),
                        .data_in           (DataIn),
                        .wr                (Wr),
                        .rd                (Rd));

    
    // your code here

    
endmodule // mem_system

// DUMMY LINE FOR REV CONTROL :9:
