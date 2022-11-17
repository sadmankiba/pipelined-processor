module control_reg(/* input */ opcode, 
    /* output */ RsValid, RtValid, writeRegValid);
    
    input [4:0] opcode;
    
    output reg RsValid, RtValid, writeRegValid;
    
    always @(opcode)
    begin
        RsValid = 1'b0;
        RtValid = 1'b0;
        writeRegValid = 1'b0;
        casex(opcode)
        5'b0_00xx: //HALT, NOP, SIIC, NOP/RTI
            begin
            end
        
        5'b0_10xx: //ADDI, SUBI, XORI, ANDNI
            begin
            RsValid = 1'b1;
            writeRegValid = 1'b1;
            end

        5'b1_01xx: //ROLI, SLLI, RORI, SRLI
            begin
            RsValid = 1'b1;
            writeRegValid = 1'b1;
            end

        5'b1_101x: //ADD, SUB, XOR, ANDN, ROL, SLL, ROR, SRL
            begin
            RsValid = 1'b1;
            RtValid = 1'b1;
            writeRegValid = 1'b1;
            end
    
        5'b1_11xx: //SEQ, SLT, SLE, SCO
            begin
            RsValid = 1'b1;
            RtValid = 1'b1;
            writeRegValid = 1'b1;
            end

        5'b1_1001: // BTR
            begin
            RsValid = 1'b1;
            writeRegValid = 1'b1;
            end

        5'b0_1100: //BEQZ, BNEZ, BLTZ, BGEZ
            begin
            RsValid = 1'b1;
            end
        
        5'b1_1000: //LBI
            begin
            writeRegValid = 1'b1;
            end
    
        5'b1_0010: //SLBI
            begin
            RsValid = 1'b1; writeRegValid = 1'b1;
            end

        5'b1_0000: //ST, LD
            begin
            
            RsValid = 1'b1;
            
            RtValid = 1'b1;
            
            writeRegValid = 1'b1;
            end
        5'b1_0001: //ST, LD
            begin
            
            RsValid = 1'b1;
            
            RtValid = 1'b1;
            
            writeRegValid = 1'b1;
            end
        
        5'b1_0011: //STU
            begin
            
            RsValid = 1'b1;
            
            RtValid = 1'b1;
            writeRegValid = 1'b1;
            end

        5'b0_0100: //J
            begin
            end
        5'b0_0101: //JR
            begin
            RsValid = 1'b1;
            end
        5'b0_0110: //JAL
            begin
            writeRegValid = 1'b1;
            RtValid = 1'b1;
            end
        5'b0_0111: //JALR
            begin
            RsValid = 1'b1;
            writeRegValid = 1'b1;
            RtValid = 1'b1;
            end
        default:
            begin
            //do nothing? throw err?
            end
        endcase
    end
endmodule
