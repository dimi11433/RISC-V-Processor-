`include "PC.v"
`include "Memory.v"
`include "InstructionRegister.v"
`include "ControlUnit.v"
`include "RegisterFile.v"
`include "ALUControl.v"
`include "ALU.v"


module DataPath(
    input clk, reset,
    input [31:0] instructions, //Input Instructions
    output [31:0] pc //ProgramCounter

);
    //Instantiate internal wires
    wire PCWriteCond, PCWrite, IorD, PCSource, MemRead, MemWrite, MemtoReg, IRWrite, RegWrite, ALUSrcA, zero;
    wire [1:0] ALUOp, ALUSrcB;
    wire [31:0] ALU_result;
    wire [31:0] data_A, data_B, Instruction, WriteData, ImmGen, A, B, Instruct_input;
    wire [4:0] read_reg1, read_reg2, write_reg;
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [3:0] aluControl;
    reg[31:0] MemDataReg, ALUOut;

    //Write Data into Register File
    assign WriteData = (MemtoReg) ? MemDataReg : ALUOut;
   
   //Two ALU MUX
   assign A = (ALUSrcA) ? data_A : instructions;
   assign B = (ALUSrcB == 2'b00) ? data_B : (ALUSrcB == 2'b01) ? 32'b00000000000000000000000000000100 : ImmGen; 

   //PC assigning
    assign pc = (PCSource)? ALUOut: ALU_result;


    assign Instruction = (IorD) ? ALUOut: Instruct_input;
    assign ImmGen = {{20{Instruction[31]}},Instruction[31:20]};

    //Memory data Register

    always@(posedge clk or posedge reset)begin
        if(reset)begin
            MemDataReg <= 32'b0;
        end 
        else begin
            MemDataReg <= Instruction;
        end 
    end 

    //ALU Out store
    always@(posedge clk or posedge reset)begin
        if(reset)begin
            ALUOut <= 32'b0;
        end else begin
            ALUOut <= ALU_result;
        end 
    end 

   //Instantiate the PC 
   PC program_counter(
        .instructions(instructions),
        .PCWrite(PCWrite),
        .PCWriteCond(PCWriteCond),
        .zero(zero),
        .clk(clk),
        .reset(reset),
        .pc_instructions(Instruct_input)
   );

    //Instruction Memory get address and and move it on 
    Instruction_Memory Memory(
        .Address(Instruct_input),
        .clk(clk),
        .WriteData(data_B),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Instruction(Instruction)
    );
    //Instruction Register
    IR Instruction_Register(
        .clk(clk),
        .reset(reset),
        .Instruction_in(Instruction),
        .IRWrite(IRWrite),
        .opcode(opcode),
        .rs1(read_reg1),
        .rs2(read_reg2),
        .rd(write_reg),
        .funct3(funct3),
        .funct7(funct7)

    );
    //Control Unit
    controlU control(
        .opcode(opcode),
        .reset(reset),
        .clk(clk),
        .PCWriteCond(PCWriteCond),
        .PCWrite(PCWrite),
        .IorD(IorD),
        .PCSource(PCSource),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .IRWrite(IRWrite),
        .RegWrite(RegWrite),
        .ALUSrcA(ALUSrcA),
        .ALUOp(ALUOp),
        .ALUSrcB(ALUSrcB)
    );
    //Register File
    regFile RegisterFile(
        .clk(clk),
        .reset(reset),
        .readreg1(read_reg1),
        .readreg2(read_reg2),
        .writereg(write_reg),
        .regwrite_in(RegWrite),
        .writedata(WriteData),
        .readdata1(data_A),
        .readdata2(data_B)
    );
    ALUControl alu_Control(
        .ALUop(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .aluControl(aluControl)
    );
    ALU alu(
        .A(A),
        .B(B),
        .aluControl(aluControl),
        .ALU_result(ALU_result),
        .zero(zero)
    );


endmodule 