module rev (in, out);
    input [15:0] in; 
    output [15:0] out; 
    
    assign out = {in[0],in[1],in[2],in[3],in[4],
            in[5],in[6], in[7], in[8],
            in[9],in[10],in[11],in[12],
            in[13],in[14],in[15]};
endmodule