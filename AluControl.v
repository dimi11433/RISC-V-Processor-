module AluControl(
    input [1:0]ALUop,
    input [2:0]funct3,
    input [6:0]funct7,
    output reg [3:0] aluControl
);
    always@(*)begin
        case(ALUop)
            2'b00: aluControl = 4'b0010; //ADD
            2'b01: aluControl = 4'b0110; //SUB- beq
            2'b10:begin 
                case(funct3)
                    3'b000:begin 
                        case(funct7)
                            7'b0000000: aluControl = 4'b0010; //ADD
                            7'b0100000: aluControl = 4'b0110; //SUB
                            default: aluControl = 4'b1111; //Invalid
                        endcase 
                    end 
                    3'b100: aluControl = 4'b0111; //XOR
                    3'b110: aluControl = 4'b0001; //OR
                    3'b111: aluControl = 4'b0000; //AND
                    default: aluControl = 4'b1111; //Invalid
                endcase 
            end 
            default: aluControl = 4'b1111; //Invalid
        endcase 

    end 
endmodule 