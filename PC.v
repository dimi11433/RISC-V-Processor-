module PC(
    input[31:0] instructions,
    input PCWrite, PCWriteCond, zero, clk, reset,
    output reg [31:0] pc_instructions

);
    reg activate;

    always@(posedge clk or posedge reset)begin
        if(reset)begin
            pc_instructions <= 32'b0;
        end else begin
            activate <= (PCWriteCond & zero) | PCWrite;
            if(activate)begin
                pc_instructions <= instructions;
            end 
        end 
    end 

        

endmodule 