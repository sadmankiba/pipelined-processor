module tb_mem_system_ref();     
    wire [15:0]          DataOut;
    wire                 Done;
    wire                 CacheHit;                
    wire                 Stall;  
    wire                 Err;   
    
    reg [15:0]           Addr;                   
    reg [15:0]           DataIn;                 
    reg                  Rd;                     
    reg                  Wr;                     
    reg                  createdump; 
    reg [1:0]            bank;           

    wire                 clk;
    wire                 rst;

   
    clkrst clkgen(.clk(clk),
                    .rst(rst),
                    .err(err) );

    mem_system_ref DUT(/* output */
                      .DataOut          (DataOut),
                      .Done             (Done),
                      .Stall            (Stall),
                      .CacheHit         (CacheHit),
                      /* input */
                      .Addr             (Addr),
                      .DataIn           (DataIn),
                      .Rd               (Rd),
                      .Wr               (Wr),
                      .clk              (clk),
                      .rst              (rst) );
   
    reg    reg_readorwrite;
    integer n_requests;
    integer n_replies;
    integer req_cycle;
    integer n_cache_hits;
    reg test_success;
   
    assign DataOut_ref = 16'd0; 
    initial begin
        Rd = 1'b0;
        Wr = 1'b0;
        Addr = 16'd0;
        DataIn = 16'd0;
        reg_readorwrite = 1'b0;
        n_requests = 0;
        n_replies = 0;
        test_success = 1'b1;
        req_cycle = 0;
    end
   
    always @ (posedge clk) begin
        #2; // simulation delay
        $display("");

        if (Done) begin
            n_replies = n_replies + 1;
            $display("DONE: ReqNum %0d Cycle %0d ", n_replies, clkgen.cycle_count, 
                "ReqCycle %0d Rd %d Wr %d ", req_cycle, Rd, Wr, 
                "Addr 0x%04x DataOut 0x%04x ", Addr, DataOut,
                "DataIn 0x%04x ", DataIn);
            Rd = 1'd0;
            Wr = 1'd0;
        end
        
        // change inputs for next cycle
      
        #85;
        if (!rst && (!Stall)) begin      
            if (n_requests < 20) begin
                small_random_addr;
            end else if (n_requests < 40) begin
                full_random_addr;
            end else begin
                end_simulation;
            end
            if ( (Rd | Wr) && (!rst) ) begin
                req_cycle = clkgen.cycle_count;
            end
        end

        $display("EVERY: Cycle %0d ReqCycle %0d ", clkgen.cycle_count, req_cycle, 
                "Rd %d Wr %d ", Rd, Wr,
                "tbAddr 0x%04x memAddr 0x%04x DataOut 0x%04x ", 
                Addr, DUT.Addr, DataOut,
                "DataIn 0x%04x ", DataIn);
    end

    task check_dropped_request;
  	    begin	
            if (n_replies != n_requests) begin
                if (Rd) begin
                    $display("ERRLOG: ReqNum %4d Cycle %8d ReqCycle %8d Rd Addr 0x%04x\n",
                            n_replies, clkgen.cycle_count, req_cycle, Addr);
                end
                if (Wr) begin
                    $display("ERRLOG: ReQNum %4d Cycle %8d ReqCycle %8d Wr Addr 0x%04x Value 0x%04x\n",
                            n_replies, clkgen.cycle_count, req_cycle, Addr, DataIn);
                end
                $display("ERROR! Request dropped");
                test_success = 1'b0;             
                n_replies = n_requests;	       
            end            
        end
    endtask

    task full_random_addr;
        begin
            if (!rst && (clkgen.cycle_count > 5)) begin
                check_dropped_request;
                // reg_readorwrite = $random % 2;
                reg_readorwrite = 1;
                if (reg_readorwrite) begin
                    Wr = $random % 2;
                    Addr = ($random % 16'hffff) & 16'hFFFE;
                    DataIn = $random % 16'hffff;
                    Rd = ~Wr;
                    n_requests = n_requests + 1;
                    $display("REQ: ReqCy: %0d Rd %d Wr %d Addr 0x%04x DataIn 0x%04x", 
                        clkgen.cycle_count, Rd, Wr, Addr, DataIn);          
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
            if (!rst && (clkgen.cycle_count > 5) ) begin
                check_dropped_request;            
                // reg_readorwrite = $random % 2;
                reg_readorwrite = 1;
                if (reg_readorwrite) begin
                    Wr = $random % 2;
                    Addr = (($random % 16'hffff) & 16'h07FE) | 16'h6000;
                    DataIn = $random % 16'hffff;
                    Rd = ~Wr;
                    n_requests = n_requests + 1;    
                    $display("REQ: ReqCy: %0d Rd %d Wr %d Addr 0x%04x DataIn 0x%04x", 
                        clkgen.cycle_count, Rd, Wr, Addr, DataIn);           
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
                    clkgen.cycle_count);
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
