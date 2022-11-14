module tb_sign_ext;
    reg [3:0] Inp;

    wire [7:0] Out;

    wire Clk;

    // dummy wires used in clkrst module
    wire Rst;
    wire Err;
    reg [7:0] exp;

    clkrst my_clkrst(.clk(Clk), .rst(Rst), .err(Err));

    sign_ext #(.INPUT_WIDTH(4), .OUTPUT_WIDTH(8)) DUT(.in(Inp), .out(Out));

    initial begin
        Inp = 4'b0000;

        #4000 $finish;
    end

    always @(posedge Clk) begin
        Inp = $random;        
    end

    always @(negedge Clk) begin
        assign exp = { { 4{Inp[3]} }, Inp };
        // assign exp = {Inp[3], Inp[3], Inp[3], Inp[3], 
        //             Inp[3], Inp[2], Inp[1], Inp[0]};
        if (Out !== exp) begin
            $display ("ERRORCHECK Inp = 0x%x, Exp: 0x%x, Out: 0x%x", Inp, exp, Out);
        end
    end

endmodule