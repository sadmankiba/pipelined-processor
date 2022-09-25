module tb_demux1_4;
    reg in;
    reg [1:0] s;

    wire out1, out2, out3, out4;

    wire clk, rst, err;
    clkrst my_clkrst(.clk(clk), .rst(rst), .err(err));

    demux1_4 DUT(.in(in), .s(s), .out1(out1), .out2(out2), .out3(out3), .out4(out4));

    initial begin
        in = 1'b1;
        s = 2'b00;

        #8000 $finish;
    end

    always @(posedge clk) begin
        in = $random;
        s = $random;        
    end

    always @(negedge clk) begin
        case (s)
            2'b00 :
                if ((out1 !== in) || (out2 !== 1'b0) || (out3 !== 1'b0) || (out4 !== 1'b0)) begin
                    $display ("ERRORCHECK inp s = 2'b00");
                end
            2'b01 :
                if ((out1 !== 1'b0) || (out2 !== in) || (out3 !== 1'b0) || (out4 !== 1'b0)) begin
                    $display ("ERRORCHECK inp s = 2'b01");
                end
            2'b10 :
                if ((out1 !== 1'b0) || (out2 !== 1'b0) || (out3 !== in) || (out4 !== 1'b0)) begin
                    $display ("ERRORCHECK inp s = 2'b10");
                end
            2'b11 :
                if ((out1 !== 1'b0) || (out2 !== 1'b0) || (out3 !== 1'b0) || (out4 !== in)) begin
                    $display ("ERRORCHECK inp s = 2'b11");
                end 
        endcase
    end

endmodule