module tb_or4;
    reg in1, in2, in3, in4;
    reg aout;
    wire out;

    wire clk, rst, err;
    clkrst my_clkrst(.clk(clk), .rst(rst), .err(err));

    or4 DUT(out, in1, in2, in3, in4);

    initial begin
        in1 = 1'b1; in2 = 1'b0; in3 = 1'b1; in4 = 1'b0;

        #4000 $finish;
    end

    always @(posedge clk) begin
        in1 = $random; in2 = $random; in3 = $random; in4 = $random;
    end

    always @(negedge clk) begin
        aout = in1 | in2 | in3 | in4;
        $display ("out %x", out);
        if (aout !== out) begin
            $display ("ERRORCHECK out %x, aout %x", out, aout);
        end 
        
    end

endmodule