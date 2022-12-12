module control_reg(/* input */ instr, 
    /* output */ Rs, Rt, RsValid, RtValid, writeRegValid);
    
    input [15:0] instr;
    
    output [2:0] Rs, Rt;
    output reg RsValid, RtValid, writeRegValid;
    
    wire [4:0] opcode;

    assign opcode = instr[15:11];

    assign Rs = instr[10:8];
    assign Rt = instr[7:5];

    always @(opcode)
    begin
        RsValid = 1'b0;
        RtValid = 1'b0;
        writeRegValid = 1'b0;
        casex(opcode)
            5'b0_00xx: 
                begin
                end
            
            5'b0_10xx: 
                begin
                RsValid = 1'b1;
                writeRegValid = 1'b1;
                end

            5'b1_01xx: 
                begin
                RsValid = 1'b1;
                writeRegValid = 1'b1;
                end

            5'b1_101x: 
                begin
                RsValid = 1'b1;
                RtValid = 1'b1;
                writeRegValid = 1'b1;
                end
        
            5'b1_11xx: 
                begin
                RsValid = 1'b1;
                RtValid = 1'b1;
                writeRegValid = 1'b1;
                end

            5'b1_1001: 
                begin
                RsValid = 1'b1;
                writeRegValid = 1'b1;
                end

            5'b0_11xx: 
                begin
                RsValid = 1'b1;
                end
            
            5'b1_1000: 
                begin
                writeRegValid = 1'b1;
                end
        
            5'b1_0010: 
                begin
                RsValid = 1'b1; writeRegValid = 1'b1;
                end

            5'b1_0000: 
                begin
                RsValid = 1'b1;
                // Set for load-use hzd and setting forwardB
                RtValid = 1'b1;
                end
            5'b1_0001: 
                begin
                RsValid = 1'b1;
                writeRegValid = 1'b1;
                end
            
            5'b1_0011: 
                begin
                RsValid = 1'b1;
                // set for same as ST
                RtValid = 1'b1;
                writeRegValid = 1'b1;
                end

            5'b0_0100: 
                begin
                end
            5'b0_0101: 
                begin
                RsValid = 1'b1;
                end
            5'b0_0110: 
                begin
                writeRegValid = 1'b1;
                RtValid = 1'b1;
                end
            5'b0_0111: 
                begin
                RsValid = 1'b1;
                writeRegValid = 1'b1;
                RtValid = 1'b1;
                end
            default:
                begin
                end
        endcase
    end
endmodule
