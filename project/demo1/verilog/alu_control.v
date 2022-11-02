module alu_control(aluOp, funct, invA, invB, sign, aluControl, cin);
    input [4:0] aluOp;
    input [1:0] funct;

    output reg invA, invB, sign, cin;
    output reg [2:0] aluControl; 
    /*
    Instr             |     ALU Control
    -----------------------------------
    roli, rol               000
    slli, sll               001
    ror, rori               010
    srli, srl               011
    addi, subi, add, sub    100
    xori, xor               110
    andni, andn             111
    */

    always @(*)
    begin
        invA = 1'b0;
        invB = 1'b0;
        sign = 1'b0;
        aluControl = 3'b000;
        cin = 1'b0;
        
        casex(aluOp)
            5'b01000: begin // addi
                sign = 1'b1; aluControl = 3'b100;
            end
            5'b01001: begin // subi
                invA = 1'b1; cin = 1'b1; aluControl = 3'b100;
            end
            5'b01010: begin // xori
                aluControl = 3'b110;
            end
            5'b01011: begin // andni
                invB = 1'b1; aluControl = 3'b111;
            end
            5'b10100: begin // roli
                aluControl = 3'b000;
            end
            
            5'b10101: begin // slli
                aluControl = 3'b001;
            end
            
            5'b10110: begin // rori 
                aluControl = 3'b010;
            end
            5'b10111: begin // srli
                aluControl = 3'b011;
            end
            5'b10000: begin // st
                aluControl = 3'b100;
            end
            5'b10001: begin // ld
                aluControl = 3'b100;
            end
            5'b10011: begin // stu
                aluControl = 3'b100;
            end
            5'b11001: begin // btr
                aluControl = 3'b100;
            end
            5'b11011: begin  // add, sub, xor, andn
                case(funct)
                    2'b00: begin 
                        aluControl = 3'b100;
                    end
                    2'b01: begin
                        invA = 1'b1;
                        cin = 1'b1;
                        aluControl = 3'b100;
                    end
                    2'b10: begin 
                        aluControl = 3'b110;
                    end
                    2'b11: begin
                        invB = 1'b1; aluControl = 3'b111;
                    end 
                endcase 
            end
            5'b11010: begin // rol, sll, ror, srl
                case(funct)
                    2'b00: begin 
                        aluControl = 3'b000;
                    end
                    2'b01: begin
                        aluControl = 3'b001;
                    end
                    2'b10: begin 
                        aluControl = 3'b010;
                    end
                    2'b11: begin
                        aluControl = 3'b011;
                    end 
                endcase
                
            end
            5'b11100: begin   // seq    
                invA = 1'b1; cin = 1'b1; aluControl = 3'b100;
            end
            5'b11101: begin // slt
                sign = 1'b1; invB = 1'b1;
                cin = 1'b1; aluControl = 3'b100;
            end
            5'b11110: begin // sle
                sign = 1'b1; invB = 1'b1;
                cin = 1'b1; aluControl = 3'b100;
            end
            5'b11111: begin // sco
                aluControl = 3'b100;
            end
            5'b01110: begin // bltz
                sign = 1'b1;
                invB = 1'b1;
                cin = 1'b1;
                aluControl = 3'b100;
            end
            5'b01111: begin // bgez
                sign = 1'b1;
                invB = 1'b1;
                cin = 1'b1;
                aluControl = 3'b100;
            end
            5'b11000: begin    // lbi
                aluControl = 3'b000;
            end
            5'b10010: begin // slbi
                aluControl = 3'b101; 
            end
            default: begin // halt, nop 
            end
        endcase
    end
endmodule
