module data_forward_unit(/* input */ RegWriteExMem,  RegWriteMemWb,
    MemReadExMem, RsIdEx, RtIdEx, RdExMem, RdMemWb, RsExMem,
    /* output */ forwardA, forwardB );
    /*
    forwardA (Rs / ALU inp 1) - 00: Original, 10: Ex.Rd, 01: Mem.Rd
    forwardB (Rt / ALU inp 2) - 00: Original, 10: Ex.Rd, 01: Mem.Rd  
    */
   
    input [2:0] Rd_ex_mem, Rd_mem_wb, Rs_id_ex, Rt_id_ex, Rs_ex_mem;
    input RegWriteExMem, RegWriteMemWb, MemReadExMem;
    
    output [1:0] forwardA, forwardB;

    // EX hazard
    wire Rs_ex_hazard, Rt_ex_hazard;
    assign Rs_ex_hazard = (RegWriteExMem & (Rs_id_ex == Rd_ex_mem) ) ? 1 : 0;
    assign Rt_ex_hazard = (RegWriteExMem & (Rt_id_ex == Rd_ex_mem) ) ? 1 : 0;
    
    // MEM hazard
    wire Rs_mem_hazard, Rt_mem_hazard;
    assign Rs_mem_hazard = (RegWriteMemWb & (Rs_id_ex == Rd_mem_wb)) ? 1 : 0;
    assign Rt_mem_hazard = (RegWriteMemWb & (Rt_id_ex == Rd_mem_wb)) ? 1 : 0;

    assign load_ex_mem = (MemReadExMem & RegWriteExMem & (Rs_id_ex == Rs_ex_mem)) ? 1 : 0;
    
    //for load -> forward 2'b11
    assign forwardA = (load_ex_mem)? 2'b11 : (Rs_ex_hazard) ? 2'b10 : (Rs_mem_hazard) ? 2'b01 : 2'b00;
    assign forwardB = (Rt_ex_hazard) ? 2'b10 : (Rt_mem_hazard) ? 2'b01 : 2'b00;

endmodule
