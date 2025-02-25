//`include "Parameter.v" //This line includes an external file Parameter.v, which defines the constants col(the bit with of each instruction) 
//and row the amount of instructions

module Instruction_Memory(
    input [31:0] Address,
    input clk,
    input [31:0] WriteData,
    input MemRead,
    input MemWrite,
    output reg [31:0] Instruction
);
reg [31:0]memory [46:0];
wire[4:0] rom_add = Address[7:2];
initial //This function only runs once at the beginning of the program 
begin 
    $readmemb("memory_init.txt", memory, 0, 46); //$readmemb loads binary instructions from "./test/test.prog" into memory[0] to memory[46]
end 
always @(posedge clk)begin
    if(MemWrite)begin
        memory[rom_add] <= WriteData;
    end 
    if(MemRead)begin
        Instruction <= memory[rom_add];
    end else begin
        Instruction <= 32'b0;
    end 
end 
endmodule 


