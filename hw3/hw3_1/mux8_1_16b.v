module mux8_1_16b (in, s, out);
    input [127:0] in;
    input [2:0] s;
    output [15:0] out;
    
    case (s)
        3'b000 : begin 
            assign out = in[15:0];
        end
        3'b001 : begin 
            assign out = in[31:16];
        end
        3'b010 : begin 
            assign out = in[47:32];
        end
        3'b011 : begin 
            assign out = in[63:48];
        end
        3'b100 : begin 
            assign out = in[79:64];
        end
        3'b101 : begin 
            assign out = in[95:80];
        end
        3'b110 : begin 
            assign out = in[111:96];
        end
        3'b111 : begin 
            assign out = in[127:112];
        end
    endcase
endmodule