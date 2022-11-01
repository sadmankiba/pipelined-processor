module alu_control(aluOp, funct, invA, invB, sign, aluControl, cin, passA, passB);
    input [4:0] aluOp;
    input [1:0] funct;

    output reg invA;
    output reg invB;
    output reg sign;
    output reg [2:0] aluControl; 
    output reg cin;
    output reg passA, passB;

    always @(*)
    begin
        invA = 1'b0;
        invB = 1'b0;
        sign = 1'b0;
        aluControl = 3'b000;
        cin = 1'b0;
        passA = 1'b0;
        passB = 1'b0;
        casex({aluOp, funct})
        7'b00000_xx: 
            begin

            end
        
        7'b11000_xx: //LBI
            begin
            aluControl = 3'b000;
            passB = 1'b1;
            end
        7'b11011_00: //ADD
            begin
            aluControl = 3'b100;
            end
        7'b11011_11: //ANDN
            begin
            invB = 1'b1;
            aluControl = 3'b111;
            end
        7'b11011_01: //SUB
            begin
            invA = 1'b1;
            cin = 1'b1;
            aluControl = 3'b100;
            end
        7'b11011_10: //XOR
            begin
            aluControl = 3'b110;
            end
        7'b11100_xx: //SEQ
            begin
            invA = 1'b1;
            cin = 1'b1;
            aluControl = 3'b100;
            end
        7'b11101_xx: //SLT
            begin
            sign = 1'b1;
            invB = 1'b1;
            cin = 1'b1;
            aluControl = 3'b100;
            end
        7'b11110_xx: //SLE
            begin
            sign = 1'b1;
            invB = 1'b1;
            cin = 1'b1;
            aluControl = 3'b100;
            end
        7'b11111_xx: //SCO
            begin
            aluControl = 3'b100;
            end
        7'b10010_xx: //SLBI
            begin
            aluControl = 3'b101; //OR
            end
        7'b01000_xx: //ADDI
            begin
            sign = 1'b1;
            aluControl = 3'b100;
            end
        7'b01001_xx: //SUBI
            begin
            invA = 1'b1;
            cin = 1'b1;
            aluControl = 3'b100;
            end
        7'b01010_xx: //XORI
            begin
            aluControl = 3'b110;
            end
        7'b01011_xx: //ANDNI
            begin
            invB = 1'b1;
            aluControl = 3'b111;
            end
        7'b11010_00: //ROL
            begin
            aluControl = 3'b000;
            end
        7'b10100_xx: //ROLI
            begin
            aluControl = 3'b000;
            end
        7'b11010_01: //SLL
            begin
            aluControl = 3'b001;
            end
        7'b10101_xx: //SLLI
            begin
            aluControl = 3'b001;
            end
        7'b11010_10: //ROR
            begin
            aluControl = 3'b010;
            end
        7'b10110_xx: //RORI
            begin
            aluControl = 3'b010;
            end
        7'b11010_11: //SRL
            begin
            aluControl = 3'b011;
            end
        7'b10111_xx: //SRLI
            begin
            aluControl = 3'b011;
            end
        7'b10000_xx: //ST
            begin
            aluControl = 3'b100;
            end
        7'b10001_xx: //LD
            begin
            aluControl = 3'b100;
            end
        7'b10011_xx: //STU
            begin
            aluControl = 3'b100;
            end
        7'b11001_xx: //BTR
            begin
            aluControl = 3'b100;
            end
    ///////////////////////////////////////

        
        7'b01110_xx: //BLTZ
            begin
            sign = 1'b1;
            invB = 1'b1;
            cin = 1'b1;
            aluControl = 3'b100;
            end
        7'b01111_xx: //BGEZ
            begin
            sign = 1'b1;
            invB = 1'b1;
            cin = 1'b1;
            aluControl = 3'b100;
            end

        default:
            begin

            end
        endcase
    end
endmodule
