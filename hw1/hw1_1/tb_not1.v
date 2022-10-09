module tb_not1;
    reg Inp;

    wire Out;

    wire Clk;

    // dummy wires used in clkrst module
    wire Rst;
    wire Err;

    clkrst my_clkrst(.clk(Clk), .rst(Rst), .err(Err));

    not1 DUT(.in1(Inp), .out(Out));

    initial begin
        Inp = 1'b1;

        #4000 $finish;
    end

    always @(posedge Clk) begin
        Inp = $random;        
    end

    always @(negedge Clk) begin
        case (Inp)
            1'b0 :
                if (Out !== 1'b1) begin
                        $display ("ERRORCHECK Inp = 1'b0");
                end
            2'b1 :
                if (Out !== 1'b0) begin
                        $display ("ERRORCHECK Inp = 1'b1");
                end 
        endcase
    end

endmodule