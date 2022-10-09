module tb_demux1_2;
    reg in, s;

    wire out1, out2;

    wire clk, rst, err;
    clkrst my_clkrst(.clk(clk), .rst(rst), .err(err));

    demux1_2 DUT(.in(in), .s(s), .out1(out1), .out2(out2));

    initial begin
        in = 1'b1;
        s = 1'b0;

        #4000 $finish;
    end

    always @(posedge clk) begin
        in = $random;
        s = $random;        
    end

    always @(negedge clk) begin
        case (s)
            1'b0 :
                if ((out1 !== in) || (out2 !== 1'b0)) begin
                    $display ("ERRORCHECK Inp s = 1'b0");
                end
            1'b1 :
                if ((out1 !== 1'b0) || (out2 !== in)) begin
                    $display ("ERRORCHECK Inp s = 1'b1");
                end 
        endcase
    end

endmodule