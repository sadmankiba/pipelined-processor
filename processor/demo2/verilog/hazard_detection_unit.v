module hazard_detection_unit(/* input */ MemRead_id_ex, Rt_id_ex, Rs_if_id, Rt_if_id,
        RtValid_id_ex, RsValid_if_id, RtValid_if_id,
        /* output */ PCWrite, IF_ID_Write, controlZero);
  
    /* Load-use hazard detection */ 
    input MemRead_id_ex;
    input [2:0] Rt_id_ex, Rs_if_id, Rt_if_id;
    input RtValid_id_ex, RsValid_if_id, RtValid_if_id;
    
    output PCWrite; 
    output IF_ID_Write; 
    output controlZero; 
    
    assign loadUse = MemRead_id_ex && 
            (((Rt_id_ex == Rs_if_id) & RtValid_id_ex & RsValid_if_id) || 
            ((Rt_id_ex == Rt_if_id) & RtValid_id_ex & RtValid_if_id));

    assign PCWrite = (loadUse) ? 1'b0 : 1'b1;
    assign IF_ID_Write  = (loadUse) ? 1'b0 : 1'b1;
    assign controlZero = (loadUse) ? 1'b1 : 1'b0;
endmodule
