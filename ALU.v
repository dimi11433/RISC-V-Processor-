module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] aluControl,
    output reg [31:0] ALU_result,
    output zero

);
    always@(*)begin
        case(aluControl)
            4'b0000: ALU_result = A & B;
            4'b0001: ALU_result = A | B;
            4'b0010: ALU_result = A + B;
            4'b0110: ALU_result = A - B;
            4'b0111: ALU_result = A ^ B;
            default: ALU_result = 32'b0;
        endcase 
    end 
    //zero flag
    assign zero = (ALU_result == 32'b0);

endmodule 