/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module proc_hier_my_pbench();

   /* BEGIN DO NOT TOUCH */
   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   // End of automatics
   

   wire [15:0] PC;
   wire [15:0] Inst;           /* This should be the 15 bits of the FF that
                                  stores instructions fetched from instruction memory
                               */
   wire        RegWrite;       /* Whether register file is being written to */
   wire [2:0]  WriteRegister;  /* What register is written */
   wire [15:0] WriteData;      /* Data */
   wire        MemWrite;       /* Similar as above but for memory */
   wire        MemRead;
   wire [15:0] MemAddress;
   wire [15:0] MemDataIn;
   wire [15:0] MemDataOut;
   wire        DCacheHit;
   wire        ICacheHit;
   wire        DCacheReq;
   wire        ICacheReq;
   

   wire        Halt;         /* Halt executed and in Memory or writeback stage */
   
   wire  [15:0]  PcIn, NxtPcIfId, InstrIfId;
   wire     FlushIf, WritePc, ValidInsIfId, WriteIfId;

   wire [2:0] ReadReg1, ReadReg2;
   wire [15:0] InstrDcd, Read1DataInit, Read2DataInit;
   wire WriteEn, IsHzdLd;

   wire [4:0] NewOpc;
   wire RegDst, ALUSrc, ControlZeroIdEx1, ControlZeroIdEx2, RegWriteInIdEx, 
      RsValidInIdEx, MemWriteInIdEx;
   wire [15:0] ReadData1InIdEx, ReadData2InIdEx, ImmValInIdEx;
   wire [2:0] RsInIdEx;
   
   wire [15:0] AluRes, AluInp1, AluInp2;
   wire [2:0] AluControl;
   wire [1:0] ForwardA, ForwardB;
   wire [4:0] AluOp;
   wire MemForwardA;

   wire ForwardC, IsHzdPc, ControlZeroIdExHzd, BranchTakeInExMem;
   wire [15:0] MemWriteDataExMem;
   wire MemWriteInExMem, MemToRegExMem, RegWriteInExMem, ControlZeroExMem;
   wire MemToRegMemWb, RegWriteMemWb;
        
   integer     inst_count;
   integer     trace_file;
   integer     sim_log_file;
     
   integer     DCacheHit_count;
   integer     ICacheHit_count;
   integer     DCacheReq_count;
   integer     ICacheReq_count;
   
   proc_hier DUT();

   

   initial begin
      $display("Hello world...simulation starting");
      $display("See verilogsim.log and verilogsim.ptrace for output");
      inst_count = 0;
      DCacheHit_count = 0;
      ICacheHit_count = 0;
      DCacheReq_count = 0;
      ICacheReq_count = 0;

      trace_file = $fopen("verilogsim.ptrace");
      sim_log_file = $fopen("verilogsim.log");
      
   end

   always @ (posedge DUT.c0.clk) begin
      if (!DUT.c0.rst) begin
         if (Halt || RegWrite || MemWrite) begin
            inst_count = inst_count + 1;
         end
         if (DCacheHit) begin
            DCacheHit_count = DCacheHit_count + 1;      
         end    
         if (ICacheHit) begin
            ICacheHit_count = ICacheHit_count + 1;      
         end    
         if (DCacheReq) begin
            DCacheReq_count = DCacheReq_count + 1;      
         end    
         if (ICacheReq) begin
            ICacheReq_count = ICacheReq_count + 1;      
         end    

         $fdisplay(sim_log_file, "SIMLOG:: Cycle %d PC: %4x Ins: %4x R: %d %3d %8x M: %d %d %8x %8x",
                   DUT.c0.cycle_count,
                   PC,
                   Inst,
                   RegWrite,
                   WriteRegister,
                   WriteData,
                   MemRead,
                   MemWrite,
                   MemAddress,
                   MemDataIn);
         $fdisplay(sim_log_file, "FETCH: pcIn: %4x  writePc: %d", 
                  PcIn, WritePc);
         $fdisplay(sim_log_file, "IF/ID: nxtPc: %4x I: %4x validIns: %d flushIf: %d writeIfId: %d", 
                  NxtPcIfId, InstrIfId, ValidInsIfId, FlushIf, WriteIfId);
         $fdisplay(sim_log_file, "CONTROL: newOpc: %5b RegDst: %d ALUSrc: %d Halt: %d", 
                  NewOpc, RegDst, ALUSrc, Halt);
         $fdisplay(sim_log_file, "DECODE: I: %4x readReg1: %d readReg2: %d", 
                  InstrDcd, ReadReg1, ReadReg2);
         $fdisplay(sim_log_file, "HZDLD: isHzd: %d", IsHzdLd);
         // $fdisplay(sim_log_file, "REGFILE: read1DataInit: %4x read2DataInit: %4x", 
         //          Read1DataInit, Read2DataInit);         
         $fdisplay(sim_log_file, "ID/EX: rD1: %4x rD2: %4x imV: %4x, ctrl01: %d ctrl02: %d RgW: %d MmW: %d Rs: %d RsValid: %d", 
                  ReadData1InIdEx, ReadData2InIdEx, ImmValInIdEx,
                  ControlZeroIdEx1, ControlZeroIdEx2, RegWriteInIdEx, MemWriteInIdEx, RsInIdEx, RsValidInIdEx);   
         $fdisplay(sim_log_file, "EXEC: AluOp: %5b frwdAB: %2b %2b aluInp1: %4x aluInp2: %4x aluCtrl: %3b",
                  AluOp, ForwardA, ForwardB, AluInp1, AluInp2, AluControl);
         $fdisplay(sim_log_file, "FWDX: mmFwA: %d", MemForwardA);  
         $fdisplay(sim_log_file, "EX/MEM: aluRes: %4x BrTk: %d MmW: %d mmWD %4x M2R: %d RgW: %d ctrl0: %d ", 
                  AluRes, BranchTakeInExMem, MemWriteInExMem, MemWriteDataExMem, 
                  MemToRegExMem, RegWriteInExMem, ControlZeroExMem); 
         $fdisplay(sim_log_file, "MEM: MemRead: %d MemWrite: %d forwardC: %d memAddr: %x writeData: %4x", 
                  MemRead, MemWrite, ForwardC, MemAddress, MemDataIn);
         $fdisplay(sim_log_file, "HZDPC: isHzd: %d ctrl0IdEx: %d", IsHzdPc, ControlZeroIdExHzd);
         $fdisplay(sim_log_file, "MEM/WB: MemtoReg: %d RegWrite: %d", 
                  MemToRegMemWb, RegWriteMemWb); 
         $fdisplay(sim_log_file, "WB: RegWrite %d writeReg %d writeData %4x writeEn %d", 
                   RegWrite, WriteRegister, WriteData, WriteEn);
         if (RegWrite) begin
            $fdisplay(trace_file,"REG: %d VALUE: 0x%04x", 
                      WriteRegister,
                      WriteData );            
         end
         if (MemRead) begin
            $fdisplay(trace_file,"LOAD: ADDR: 0x%04x VALUE: 0x%04x",
                      MemAddress, MemDataOut );
         end

         if (MemWrite) begin
            $fdisplay(trace_file,"STORE: ADDR: 0x%04x VALUE: 0x%04x",
                      MemAddress, MemDataIn  );
         end
         if (Halt) begin
            $fdisplay(sim_log_file, "SIMLOG:: Processor halted\n");
            $fdisplay(sim_log_file, "SIMLOG:: sim_cycles %d\n", DUT.c0.cycle_count);
            $fdisplay(sim_log_file, "SIMLOG:: inst_count %d\n", inst_count);
            $fdisplay(sim_log_file, "SIMLOG:: dcachehit_count %d\n", DCacheHit_count);
            $fdisplay(sim_log_file, "SIMLOG:: icachehit_count %d\n", ICacheHit_count);
            $fdisplay(sim_log_file, "SIMLOG:: dcachereq_count %d\n", DCacheReq_count);
            $fdisplay(sim_log_file, "SIMLOG:: icachereq_count %d\n", ICacheReq_count);

            $fclose(trace_file);
            $fclose(sim_log_file);
            #5;
            $finish;
         end 
         $fdisplay(sim_log_file, "");
      end
      
   end

   /* END DO NOT TOUCH */

   /* Assign internal signals to top level wires
      The internal module names and signal names will vary depending
      on your naming convention and your design */

   // Edit the example below. You must change the signal
   // names on the right hand side
    
   assign PC = DUT.p0.fetch0.pcOut;
   assign Inst = DUT.p0.fetch0.instr;
   
   assign RegWrite = DUT.p0.decode0.RegWrite;
   // Is register file being written to, one bit signal (1 means yes, 0 means no)
   //    
   assign WriteRegister = DUT.p0.decode0.regFile0.writeRegSel;
   // The name of the register being written to. (3 bit signal)
   
   assign WriteData = DUT.p0.decode0.regFile0.writeData;
   // Data being written to the register. (16 bits)
   
   assign MemRead =  DUT.p0.memory0.MemRead; // & ~DUT.p0.notdonem);
   // Is memory being read, one bit signal (1 means yes, 0 means no)
   
   assign MemWrite = (DUT.p0.memory0.memEnable & DUT.p0.memory0.MemWrite); // & ~DUT.p0.notdonem);
   // Is memory being written to (1 bit signal)
   
   assign MemAddress = DUT.p0.memory0.memAddr;
   // Address to access memory with (for both reads and writes to memory, 16 bits)
   
   assign MemDataIn = DUT.p0.memory0.writeDataFinal;
   // Data to be written to memory for memory writes (16 bits)
   
   assign MemDataOut = DUT.p0.memory0.readData;
   // Data read from memory for memory reads (16 bits)

   // new added 05/03
   assign ICacheReq = DUT.p0.readData1;
   // Signal indicating a valid instruction read request to cache
   // Above assignment is a dummy example
   
   assign ICacheHit = DUT.p0.readData1;
   // Signal indicating a valid instruction cache hit
   // Above assignment is a dummy example

   assign DCacheReq = DUT.p0.readData1;
   // Signal indicating a valid instruction data read or write request to cache
   // Above assignment is a dummy example
   //    
   assign DCacheHit = DUT.p0.readData1;
   // Signal indicating a valid data cache hit
   // Above assignment is a dummy example
   
   assign Halt = DUT.p0.memory0.halt;
   // Processor halted
   
   
   /* Add anything else you want here */
   assign PcIn = DUT.p0.fetch0.pcIn;
   assign WritePc = DUT.p0.fetch0.writePc;
   assign NxtPcIfId = DUT.p0.ifid0.pcIn;
   assign InstrIfId = DUT.p0.ifid0.instrFinal;
   assign ValidInsIfId = DUT.p0.ifid0.validInsIn;
   assign WriteIfId = DUT.p0.ifid0.writeIfId;
   assign FlushIf = DUT.p0.ifid0.flushIf;

   assign NewOpc = DUT.p0.control0.newOpc;
   assign RegDst = DUT.p0.RegDst;
   assign ALUSrc = DUT.p0.AluSrc;

   assign InstrDcd = DUT.p0.decode0.instr;
   assign ReadReg1 = DUT.p0.decode0.readReg1;
   assign ReadReg2 = DUT.p0.decode0.readReg2;
   assign Read1DataInit = DUT.p0.decode0.regFile0.read1DataInit;
   assign Read2DataInit = DUT.p0.decode0.regFile0.read2DataInit;
   assign WriteEn = DUT.p0.decode0.regFile0.writeEn;
   assign IsHzdLd = DUT.p0.hzdLoad0.isHazard;

   assign ReadData1InIdEx = DUT.p0.idex0.read1_in;
   assign ReadData2InIdEx = DUT.p0.idex0.read2_in;
   assign RsInIdEx = DUT.p0.idex0.RsIn;
   assign RsValidInIdEx = DUT.p0.idex0.RsValidIn;
   assign ImmValInIdEx = DUT.p0.idex0.imm_in;
   assign ControlZeroIdEx1 = DUT.p0.idex0.controlZeroIdEx1;
   assign ControlZeroIdEx2 = DUT.p0.idex0.controlZeroIdEx2;
   assign MemWriteInIdEx = DUT.p0.idex0.MemWriteInFinal; 
   assign RegWriteInIdEx = DUT.p0.idex0.RegWriteInFinal;
   
   assign AluOp = DUT.p0.exec0.AluOp;
   assign ForwardA = DUT.p0.exec0.forwardA;
   assign ForwardB = DUT.p0.exec0.forwardB;
   assign AluInp1 = DUT.p0.exec0.aluInp1;
   assign AluInp2 = DUT.p0.exec0.aluInp2;
   assign AluRes = DUT.p0.exmem0.aluResIn;
   assign AluControl = DUT.p0.exec0.aluControl;
   assign MemForwardA = DUT.p0.fex0.memFrwdA;

   assign ForwardC = DUT.p0.memory0.forwardC;
   assign IsHzdPc = DUT.p0.hzdBr0.isHazard;
   assign ControlZeroIdExHzd = DUT.p0.hzdBr0.controlZeroIdEx;
   assign BranchTakeInExMem = DUT.p0.exmem0.branchTakeIn;
   assign MemWriteDataExMem = DUT.p0.exmem0.memWriteDataIn;
   assign ControlZeroExMem = DUT.p0.exmem0.controlZeroExMem;
   assign MemWriteInExMem = DUT.p0.exmem0.MemWriteInFinal;
   assign MemToRegExMem = DUT.p0.exmem0.MemToRegIn;
   assign RegWriteInExMem = DUT.p0.exmem0.RegWriteInFinal;
   assign MemToRegMemWb = DUT.p0.memwb0.MemToRegIn;
   assign RegWriteMemWb = DUT.p0.memwb0.RegWriteIn;
   
endmodule

// DUMMY LINE FOR REV CONTROL :0:
