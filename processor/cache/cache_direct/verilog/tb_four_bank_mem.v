module tb_four_bank_mem();     
    wire [15:0]          DataOut;                
    wire [3:0]           Busy;                   
    wire                 Stall;  
    wire Err;                
    
    reg [15:0]           Addr;                   
    reg [15:0]           DataIn;                 
    reg                  Rd;                     
    reg                  Wr;                     
    reg                  createdump;             

    wire                 clk;
    wire                 rst;

   
    clkrst clkgen(.clk(clk),
                    .rst(rst),
                    .err(err) );

    four_bank_mem DUT(  /* input */
                       .addr            (Addr[15:0]),
                       .data_in         (DataIn[15:0]),
                       .rd              (Rd),
                       .wr              (Wr),
                       .clk(clk), 
                       .rst(rst),
                       .createdump      (1'b0)
                       
                       /* output */
                       .data_out         (DataOut[15:0]),
                       .busy            (Busy),
                       .stall           (Stall),
                       .err        (Err),
                       );
    
    wire [15:0]          DataOut_ref;
    wire                 Done_ref;
    wire                 Stall_ref;
    wire                 CacheHit_ref;

    mem_system_ref ref(
                      // Outputs
                      .DataOut          (DataOut_ref[15:0]),
                      .Done             (Done_ref),
                      .Stall            (Stall_ref),
                      .CacheHit         (CacheHit_ref),
                      // Inputs
                      .Addr             (Addr[15:0]),
                      .DataIn           (DataIn[15:0]),
                      .Rd               (Rd),
                      .Wr               (Wr),
                      .clk( DUT.clkgen.clk),
                      .rst( DUT.clkgen.rst) );
   
    reg    reg_readorwrite;
    integer n_requests;
    integer n_replies;
    integer req_cycle;
    reg test_success;
   
   
    initial begin
        Rd = 1'b0;
        Wr = 1'b0;
        Addr = 16'd0;
        DataIn = 16'd0;
        reg_readorwrite = 1'b0;
        n_requests = 0;
        n_replies = 0;
        test_success = 1'b1;
    end
   
    always @ (posedge clk) begin
        #2; // simulation delay
        n_replies = n_replies + 1;
         
        if (Rd) begin
            $display("LOG: ReqNum %4d Cycle %8d ReqCycle %8d Rd Addr 0x%04x Value 0x%04x ValueRef 0x%04x\n",
                n_replies,
                DUT.clkgen.cycle_count,
                req_cycle,
                Addr,
                DataOut,
                DataOut_ref);
            if (DataOut != DataOut_ref) begin
                $display("ERROR");
                test_success = 1'b0;
            end
        end
        if (Wr) begin
        $display("LOG: ReqNum %4d Cycle %8d ReqCycle %8d Wr Addr 0x%04x Value 0x%04x ValueRef 0x%04x\n",
                    n_replies, DUT.clkgen.cycle_count, req_cycle, Addr, DataIn, DataIn);
        end
        Rd = 1'd0;
        Wr = 1'd0;
      

        // change inputs for next cycle
      
        #85;
        if (!rst && (!Stall)) begin      
            if (n_requests < 1000) begin
                small_random_addr;
            end else if (n_requests < 2000) begin
                full_random_addr;
            end else begin
                end_simulation;
            end
            if ( (Rd | Wr) && (!rst && (!Stall)) ) begin
                req_cycle = DUT.clkgen.cycle_count;
            end
        end
    end

    task check_dropped_request;
  	    begin	
            if (n_replies != n_requests) begin
                if (Rd) begin
                    $display("LOG: ReqNum %4d Cycle %8d ReqCycle %8d Rd Addr 0x%04x RefValue 0x%04x\n",
                            n_replies, DUT.clkgen.cycle_count, req_cycle, Addr, DataOut_ref);
                end
                if (Wr) begin
                    $display("LOG: ReQNum %4d Cycle %8d ReqCycle %8d Wr Addr 0x%04x Value 0x%04x\n",
                            n_replies, DUT.clkgen.cycle_count, req_cycle, Addr, DataIn);
                end
                $display("ERROR! Request dropped");
                test_success = 1'b0;               
                n_replies = n_requests;	       
            end            
        end
    endtask

    task full_random_addr;
        begin
            if (!rst && (!Stall)  && (DUT.clkgen.cycle_count > 10)) begin
                check_dropped_request;
                reg_readorwrite = $random % 2;
                if (reg_readorwrite) begin
                Wr = $random % 2;
                Addr = ($random % 16'hffff) & 16'hFFFE;
                DataIn = $random % 16'hffff;
                Rd = ~Wr;
                n_requests = n_requests + 1;               
                end else begin
                Wr = 1'd0;
                Rd = 1'd0;
                end  // if (reg_readorwrite) 
            end // if (!Stall)
        end
    endtask
    task small_random_addr;
        // tag bits are always constant
        // all addresses will fit in cache
        // should generate a lot of cache hits
        begin
            if (!rst && (!Stall) && (DUT.clkgen.cycle_count > 10) ) begin
                check_dropped_request;            
                reg_readorwrite = $random % 2;
                if (reg_readorwrite) begin
                Wr = $random % 2;
                Addr = (($random % 16'hffff) & 16'h07FE) | 16'h6000;
                DataIn = $random % 16'hffff;
                Rd = ~Wr;
                n_requests = n_requests + 1;               
                end else begin
                Wr = 1'd0;
                Rd = 1'd0;
                end  // if (reg_readorwrite) 
            end // if (!Stall)
        end
    endtask

    task end_simulation;
        begin
            $display("LOG: Done Requests: %10d Replies: %10d Cycles: %10d",
                    n_requests,
                    n_replies,
                    DUT.clkgen.cycle_count);
            if (!test_success)  begin
                $display("Test status: FAIL");
            end else begin
                $display("Test status: SUCCESS");
            end
            $finish;
        end
    endtask // end_simulation
   
endmodule // mem_system_randbench
// DUMMY LINE FOR REV CONTROL :9:
