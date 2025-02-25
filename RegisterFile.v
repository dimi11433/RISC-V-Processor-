module regFile(
    input clk,
    input reset,
    input [4:0] readreg1,
    input [4:0] readreg2,
    input [4:0] writereg,
    input regwrite_in,
    input [31:0] writedata,
    output reg[31:0] readdata1,
    output reg[31:0] readdata2
);
    reg [31:0] registers [0:31];
    integer i;

always@(posedge clk or posedge reset)begin
    if(reset)begin
        for(i = 0; i < 32; i = i + 1)begin
            registers[i] <= 32'b0;
        end 
    end else if(regwrite_in && writereg != 5'b00000)begin
         registers[writereg] <= writedata;
    end 

end 
always@(*)begin
    readdata1 <= registers[readreg1];
    readdata2 <=  registers[readreg2];
end 

endmodule 